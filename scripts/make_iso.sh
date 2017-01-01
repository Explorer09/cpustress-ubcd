#!/bin/sh
#
# Script to create a bootable CPUstress ISO image.
#
# This script is modified from ubcd2iso.sh script in Ultimate Boot CD.

# Define VOLUME_ID (LABEL) of the ISO
VOLUME_ID=CPUSTRESS

# Define ISO filename
ISO_FILENAME=cpustress-develop.iso

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..
ROOT_OF_ISO_PATH=`pwd`/iso-tmp

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

if [ -e "$ROOT_OF_ISO_PATH" ]; then
    rm -Ri "$ROOT_OF_ISO_PATH"
fi

# Clone the directory so that the "iso" directory can stay intact.
cp -PRp iso "$ROOT_OF_ISO_PATH"
# Copy the cpustress directory for building ISO image.
rm -Rf "$ROOT_OF_ISO_PATH/ubcd/boot/cpustress"/*
cp -PRp cpustress/* "$ROOT_OF_ISO_PATH/ubcd/boot/cpustress"
# Don't include the source directory.
rm -Rf "$ROOT_OF_ISO_PATH/ubcd/boot/cpustress/build"

# Save IFS
SAVED_IFS=$IFS

# Poor man's 'which' command
MKISOFS=''
IFS=:
for i in $PATH ; do
    if [ -x "$i/mkisofs" ]; then
        MKISOFS=$i/mkisofs
        break
    fi
done

# Restore IFS
IFS=$SAVED_IFS

if [ -n "$MKISOFS" ] && [ -n "$ROOT_OF_ISO_PATH" ]; then
    if [ -f "${ROOT_OF_ISO_PATH}/boot/syslinux/isolinux.bin" ]; then
        rm -f "${ROOT_OF_ISO_PATH}/boot/syslinux/boot.catalog"
        rm -Rf "${ROOT_OF_ISO_PATH}/[BOOT]/"
        rm -Rf "${ROOT_OF_ISO_PATH}/boot.images/"

        # mkisofs manpage: http://linux.die.net/man/8/mkisofs
        #
        # -iso-level 4: Required for Win2K/XP booting to work
        # -l: Allow full 31 character ISO9660 filenames
        # -r: Rock Ridge Interchange Protocol allows Unix long filenames up to 255 bytes
        # -J -joliet-long: Joliet extension allows Windows long filenames up to 103 Unicode chars
        # -D: Disable deep directory relocation
        #
        # Note: UBCD2ISO_ARGS is used to pass user-specific arguments to mkisofs without modifying the script
        "$MKISOFS" -iso-level 4 -l -r -J -joliet-long -D -V "${VOLUME_ID}" \
          -o "${ISO_FILENAME}" -b "boot/syslinux/isolinux.bin" -c "boot/syslinux/boot.catalog" \
          -hide "boot/syslinux/boot.catalog" -hide-joliet "boot/syslinux/boot.catalog" \
          $UBCD2ISO_ARGS -no-emul-boot -boot-load-size 4 -boot-info-table "${ROOT_OF_ISO_PATH}"
        if [ "$?" -eq "0" ]; then
            echo
            echo "'${ISO_FILENAME}' was successfully created."
        else
            echo
            echo "ERROR: Something went wrong, while creating '${ISO_FILENAME}'." >&2
        fi
    else
        echo "ERROR: '${ROOT_OF_ISO_PATH}/boot/syslinux/isolinux.bin' could not be found." >&2
    fi
elif [ -z "$MKISOFS" ]; then
    echo "ERROR: The 'mkisofs' program could not be found. Install it and try again." >&2
fi

# Clean up.
rm -Rf "$ROOT_OF_ISO_PATH"

echo "'$ROOT_OF_ISO_PATH' has been cleaned up."
