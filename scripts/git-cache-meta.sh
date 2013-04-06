#!/bin/sh -e

# Modified from git-cache-meta.sh originally written by andris9 and others:
# https://gist.github.com/andris9/1978266

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..

# -----------------------------------------------------------------------------
#git-cache-meta -- simple file meta data caching and applying.
#Simpler than etckeeper, metastore, setgitperms, etc.
#from http://www.kerneltrap.org/mailarchive/git/2009/1/9/4654694
#modified by n1k
# - save all files metadata not only from other users
# - save numeric uid and gid
 
# 2012-03-05 - added filetime, andris9
 
: ${GIT_CACHE_META_FILE=.git_cache_meta}
case $@ in
    --store|--stdout)
        case $1 in
            --store)
                exec > $GIT_CACHE_META_FILE;
        esac
        find $(git ls-files)\
            \( -printf 'touch -c -d "%AY-%Am-%Ad %AH:%AM:%AS" %p\n' \) \
            \( -printf 'chmod %#m %p\n' \)
        find cpustress/build/build-initrd/dev \
             cpustress/build/build-initrd/proc \
             cpustress/build/build-initrd/sys \
             cpustress/build/build-initrd/tmp \
            \( -printf 'mkdir -p %p\n' \) \
            \( -printf 'touch -c -d "%AY-%Am-%Ad %AH:%AM:%AS" %p\n' \) \
            \( -printf 'chmod %#m %p\n' \)
        ;;
    --apply) sh -e $GIT_CACHE_META_FILE;;
    *) 1>&2 echo "Usage: $0 --store|--stdout|--apply"; exit 1;;
esac
