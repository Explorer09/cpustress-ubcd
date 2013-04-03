#!/bin/sh
#
# Script to make a 7z package for CPUstress release.
#
# The ! and * are interpreted differently by the shell, so they have to be
# escaped.
ARCHIVE_NAME="cpustress-2.2beta3"

# Change working directory to the directory of the script.
cd `dirname $0`

P7ZIP=
for i in 7z 7za 7zr; do
    if [ -z "$P7ZIP" -a `which ${i}` ]; then
        P7ZIP=${i}
    fi
done

if [ -z "$P7ZIP" ]; then
    echo "ERROR: 7-zip is not found. Please install 'p7zip' from your OS distribution,"
    echo "or download here (http://sourceforge.net/projects/p7zip/)."
    exit 1
fi

cd ..
if [ -e "${ARCHIVE_NAME}" ]; then
    rm -i ${ARCHIVE_NAME}
fi
cp -aR cpustress ${ARCHIVE_NAME}
${P7ZIP} a -t7z -mx=9 ${ARCHIVE_NAME}.7z ${ARCHIVE_NAME}/\* -xr-\!${ARCHIVE_NAME}/build -xr\!\*.txz -xr\!\*.gz -xr\!bzImage
${P7ZIP} a -t7z -mx=0 ${ARCHIVE_NAME}.7z ${ARCHIVE_NAME}/build.txz ${ARCHIVE_NAME}/initrd.gz ${ARCHIVE_NAME}/bzImage
# Delete the temp directory.
rm -rf ${ARCHIVE_NAME}

echo "Done."
