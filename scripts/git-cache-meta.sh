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

: ${GIT_CACHE_META_FILE=.git_cache_meta}
case $@ in
    --store|--stdout)
        case $1 in
            --store)
                exec > $GIT_CACHE_META_FILE;
        esac
        git ls-files -z | xargs -0 -I NAME find NAME \
            \( \! -type l -printf 'chmod %#m ' \
                  -exec ls --quoting-style=shell '{}' \; \) , \
            \( -printf 'touch -c -h -d "%TY-%Tm-%Td %TH:%TM:%TS %Tz" ' \
                  -exec ls --quoting-style=shell '{}' \; \)
        find cpustress/build/build-initrd/dev \
             cpustress/build/build-initrd/proc \
             cpustress/build/build-initrd/sys \
             cpustress/build/build-initrd/tmp \
            \( -printf 'mkdir -p %p\n' \) , \
            \( \( \! -type l \) -printf 'chmod %#m %p\n' \) , \
            \( -printf 'touch -c -h -d "%TY-%Tm-%Td %TH:%TM:%TS %Tz" %p\n' \)
        ;;
    --apply) sh -e $GIT_CACHE_META_FILE;;
    *) 1>&2 echo "Usage: $0 --store|--stdout|--apply"; exit 1;;
esac
