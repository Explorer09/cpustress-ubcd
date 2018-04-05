#!/bin/sh
# Script to download and package EGLIBC source tarball.
# EGLIBC did not provide packaged tarballs upon releases, and required users to
# checkout source code from official SVN server. This script can help download
# the source and package a tarball for later use or redistribution.
#
#
# Copyright (C) 2018 Kang-Che Sung <explorer09@gmail.com>
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e

VERSION=2.19

url=http://www.eglibc.org/svn/branches/eglibc-`echo "$VERSION"| tr . _`/libc/
dist_name=eglibc-$VERSION

(
    case `tar --version 2>/dev/null | sed '1 q'` in #(
        *GNU*)
            tar -c --no-recursion --format=pax --owner=root:0 --group=root:0 \
                --pax-option='' -f - . >/dev/null
            ;; #(
        *)
            exit 1
            ;;
    esac
) || { echo 'Requires GNU tar 1.27 or later' >&2; exit 1; }

info=`svn info --xml "$url" | tr -- '\t\n' '  '`
revision=`echo "$info"|
    sed -e 's|.*<commit[^>]* revision="\{0,1\}\([^">]*\)"\{0,1\}>.*|\1|'`
tar_name=${dist_name}-r${revision}
# Subversion's commit timestamps can be as precise as 0.000001 seconds, but
# sub-second precision is only available through --xml output format.
date=`echo "$info"|
    sed -e 's|.*<commit[^>]*>.*<date>\([^<]*\)</date>.*</commit>.*|\1|'`

# Factors that would make tarball non-deterministic include:
# - umask
# - Ordering of file names
# - Timestamps of directories ("svn export" doesn't update them)
# - User and group names and IDs
# - Format of "tar" ("gnu", "ustar" or "pax")
# - If using "pax" format, the name and contents of extended header blocks

umask ug=rwx,o=rx
svn export -r "$revision" "$url" "$dist_name"
# "svn export" will update file modification time to the latest time of commit
# that modified the file, but won't do so on directories.
find . -type d | xargs touch -c -m -d "$date" --

trap 's=$?; rm -f "${tar_name}.tar" || : ; exit $s' 1 2 3 15

# We use "pax" format for storage of extended metadata including:
# - Archive comment in global header ("git archive" stores the commit ID in
#   "comment" field in the global header (of file name "pax_global_header").)
# - File modification times with sub-second precision.

# The POSIX default name patterns for extended headers ("%d/PaxHeaders.%p/%f"
# and "${TMPDIR}/GlobalHead.%p.%n") would contain process IDs ("%p"), which
# would make tarball non-deterministic.
# For files in the top directory of the tarball, "%d" in exthdr.name expands to
# ".". Let's avoid "./" in the header names.
# GNU tar (<=1.30) has a bug that it rejects globexthdr.mtime that contain
# fraction of seconds.
pax_options=`printf '%s%s%s%s%s%s' \
    "globexthdr.name=.PaxHeaders/GlobalHead," \
    "globexthdr.mtime={\`echo ${date}|sed 's/\.[0123456789]*//'\`}," \
    "comment=${revision}," \
    "exthdr.name=.PaxHeaders/%f," \
    "delete=atime," \
    "delete=ctime"`
tar -c --no-recursion --format=pax --owner=root:0 --group=root:0 \
    --pax-option="$pax_options" -f "${tar_name}.tar" "$dist_name"

pax_options=`printf '%s%s%s' \
    "exthdr.name=.PaxHeaders/%d/%f," \
    "delete=atime," \
    "delete=ctime"`
find "$dist_name" ! -path "$dist_name" \
    \( -type d -exec printf '%s/\n' '{}' \; -o -print \) |
    LC_ALL=C sort |
    tar -r --no-recursion --format=pax --owner=root:0 --group=root:0 \
    --pax-option="$pax_options" -f "${tar_name}.tar" -T -

# Compression (gzip/xz) can add additional non-deterministic factors.
# XZ format does not store the original file name or timestamp, and so is
# deterministic already.
trap 's=$?; rm -f "${tar_name}.tar.xz" || : ; exit $s' 1 2 3 15
xz -9e -k "${tar_name}.tar"

# Gzip requires either --no-name option or input from stdin for deterministic
# compression.
trap 's=$?; rm -f "${tar_name}.tar.gz" || : ; exit $s' 1 2 3 15
gzip --no-name -9 -k "${tar_name}.tar" &&
    { advdef -4 -z "${tar_name}.tar.gz" || : ; }
