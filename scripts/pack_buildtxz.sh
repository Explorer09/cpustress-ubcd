#!/bin/sh

# Change working directory to the directory of the script.
cd `dirname $0`
# Then change directory to where we create the build.txz file.
cd ../cpustress

if [ -d "build" ]; then
    rm -f build.txz build.tar
    # The --exclude switch excludes files in build/build-initrd, but not the
    # directory itself.
    case `tar --version | sed -n -e '1 p'` in
    *GNU*)
        find build \( -type d -exec printf '%s/\n' '{}' \; \) -o -print |
            LC_ALL=C sort |
            tar -c -v --no-recursion --format=ustar -f build.tar -T - \
                --exclude='build/build-initrd/*' --exclude='build/initrd.gz' \
                --exclude-backups --exclude-vcs
        STATUS="$?"
        ;;
    *bsdtar*)
        # Note: --no-recursion is a synonym of -n but does not work with old
        # version of bsdtar. (Don't confuse with -n in GNU tar which means
        # --seek.)
        find build \( -type d -exec printf '%s/\n' '{}' \; \) -o -print |
            LC_ALL=C sort |
            tar -c -v -n --format ustar -f build.tar -T - \
                --exclude 'build/build-initrd/*' --exclude 'build/initrd.gz'
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
