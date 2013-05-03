#!/bin/sh
#
# Script to make a 7z package for CPUstress release.
#
# The ! and * are interpreted differently by the shell, so they have to be
# escaped.

ARCHIVE_NAME="cpustress-2.3.2"

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..

# Execute other build scripts when needed.
if [ ! -f "cpustress/initrd.gz" ]; then
    if [ ! -f "cpustress/build/initrd.gz" ]; then
        echo "Executing ./cpustress/build/build ..."
        sh ./cpustress/build/build
        if [ "$?" -ne "0" ]; then
            exit 1
        fi
    fi
    echo 'cp -a "cpustress/build/initrd.gz" "cpustress/initrd.gz"'
    cp -a "cpustress/build/initrd.gz" "cpustress/initrd.gz"
fi
if [ ! -f "cpustress/build.txz" ]; then
    echo "Executing ./scripts/pack_buildtxz.sh ..."
    sh ./scripts/pack_buildtxz.sh
    if [ "$?" -ne "0" ]; then
        exit 1
    fi
fi

P7ZIP=
for i in 7z 7za 7zr; do
    if [ "X$P7ZIP" = "X" ] && which ${i}; then
        P7ZIP=${i}
    fi
done

if [ "X$P7ZIP" = "X" ]; then
    echo "ERROR: 7-zip is not found. Please install 'p7zip' from your OS distribution,"
    echo "or download here (http://sourceforge.net/projects/p7zip/)."
    exit 1
fi

if [ -e "${ARCHIVE_NAME}" ]; then
    rm -i ${ARCHIVE_NAME}
fi
cp -aR cpustress ${ARCHIVE_NAME}
${P7ZIP} a -t7z -mx=9 ${ARCHIVE_NAME}.7z ${ARCHIVE_NAME}/\* -xr-\!${ARCHIVE_NAME}/build -xr\!\*.txz -xr\!\*.gz -xr\!bzImage
${P7ZIP} a -t7z -mx=0 ${ARCHIVE_NAME}.7z ${ARCHIVE_NAME}/build.txz ${ARCHIVE_NAME}/initrd.gz ${ARCHIVE_NAME}/bzImage
# Delete the temp directory.
rm -rf ${ARCHIVE_NAME}

echo "Done."
