#!/bin/sh

# Change working directory to the directory of the script.
cd `dirname $0`
# Then change directory to where we create the build.txz file.
cd ../cpustress

if [ -d "build" ]; then
    rm -f build.txz build.tar
    # The files in build/build-initrd are excluded, but the directory itself
    # isn't.
    case `tar --version | sed -n -e '1 p'` in
    *GNU*)
        tar -c -v --exclude='build/build-initrd/*' --exclude='build/initrd.gz' \
            --exclude-backups --exclude-vcs -f build.tar build
        STATUS="$?"
        ;;
    *bsdtar*)
        tar -c -v --exclude 'build/build-initrd/*' --exclude 'build/initrd.gz' \
            -f build.tar build
        STATUS="$?"
        ;;
    *)
        echo "ERROR: This script requires a GNU tar or bsdtar." >&2
        exit 1
    esac
    if [ "$STATUS" -eq 0 ]; then
        xz -F xz -6 -c <build.tar >build.txz
        STATUS="$?"
    fi
    rm -f build.tar
    exit $STATUS
else
    echo "ERROR: $(pwd)/build is not a directory." >&2
    exit 1
fi
