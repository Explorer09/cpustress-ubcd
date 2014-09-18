#!/bin/sh
#
# This script removes all files generated by other scripts in this directory.
# It is analogous to 'make clean' in most projects that have a makefile.

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..

ISO_FILENAME="cpustress-2.5.3.iso"

ARCHIVE_NAME="cpustress-2.5.3"

rm -f "$ISO_FILENAME"
rm -f "${ARCHIVE_NAME}.7z"
rm -f "cpustress/build.txz"
rm -f "cpustress/initrd.xz"
rm -f "cpustress/build/initrd"
rm -f "cpustress/build/initrd.xz"
rm -f "cpustress/build/initrd.xz.old"
