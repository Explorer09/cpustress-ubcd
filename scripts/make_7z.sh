#!/bin/sh
#
# Script to make a 7z package for CPUstress release.
#
# The ! and * are interpreted differently by the shell, so they have to be
# escaped.

ARCHIVE_NAME="cpustress-develop"

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..

# Execute other build scripts when needed.
if [ ! -f "cpustress/initrd.xz" ]; then
    if [ ! -f "cpustress/build/initrd.xz" ]; then
        echo "Executing ./cpustress/build/build ..."
        sh ./cpustress/build/build || exit $?
    fi
    echo 'cp -PRp "cpustress/build/initrd.xz" "cpustress/initrd.xz"'
    cp -PRp "cpustress/build/initrd.xz" "cpustress/initrd.xz"
fi
if [ ! -f "cpustress/build.txz" ]; then
    echo "Executing ./scripts/pack_buildtxz.sh ..."
    sh ./scripts/pack_buildtxz.sh || exit $?
fi

# Save IFS
SAVED_IFS=$IFS

# Poor man's 'which' command
IFS=:
P7ZIP=""
for n in 7z 7za 7zr; do
    for d in $PATH ; do
        if [ -x "$d/$n" ]; then
            P7ZIP="$n"
            break 2
        fi
    done
done

if [ "X$P7ZIP" = "X" ]; then
    echo "ERROR: 7-zip is not found. Please install 'p7zip' from your OS distribution," >&2
    echo "or download here (http://sourceforge.net/projects/p7zip/)." >&2
    exit 1
fi

# Restore IFS
IFS=$SAVED_IFS

if [ -e "${ARCHIVE_NAME}" ]; then
    rm -Ri ${ARCHIVE_NAME}
fi
cp -PRp cpustress ${ARCHIVE_NAME}
${P7ZIP} a -t7z -mx=9 ${ARCHIVE_NAME}.7z ${ARCHIVE_NAME}/\* -xr-\!${ARCHIVE_NAME}/build -xr\!\*.txz -xr\!\*.xz -xr\!bzImage
${P7ZIP} a -t7z -mx=0 ${ARCHIVE_NAME}.7z ${ARCHIVE_NAME}/build.txz ${ARCHIVE_NAME}/initrd.xz ${ARCHIVE_NAME}/bzImage
# Delete the temp directory.
rm -Rf ${ARCHIVE_NAME}

echo "Done."
