#!/bin/sh
#
# Script to create a bootable CPUstress ISO image.
#
# This script is modified from ubcd2iso.sh script in Ultimate Boot CD.

# Define VOLUME_ID (LABEL) of the ISO
VOLUME_ID="CPUSTRESS"

# Define ISO filename
ISO_FILENAME="cpustress-2.3.2.iso"

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..
ROOT_OF_ISO_PATH="$(pwd)/iso-tmp"

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

if [ -e "$ROOT_OF_ISO_PATH" ]; then
    rm -Ri "$ROOT_OF_ISO_PATH"
fi

# Clone the directory so that the "iso" directory can stay intact.
cp -aR iso "$ROOT_OF_ISO_PATH"
# Copy the cpustress directory for building ISO image.
rm -fR "$ROOT_OF_ISO_PATH/ubcd/boot/cpustress"/*
cp -aR cpustress/* "$ROOT_OF_ISO_PATH/ubcd/boot/cpustress"
# Don't include the source directory.
rm -fR "$ROOT_OF_ISO_PATH/ubcd/boot/cpustress/build"

# Save IFS
SAVED_IFS=$IFS

# Poor man's 'which' command
MKISOFS=''
IFS=:
for i in $PATH ; do
    if [ -x "$i/mkisofs" ]; then
        MKISOFS="$i/mkisofs"
        break
    fi
done

# Restore IFS
IFS=$SAVED_IFS

if [ -n "$MKISOFS" ] && [ -n "$ROOT_OF_ISO_PATH" ]; then
    if [ -f "${ROOT_OF_ISO_PATH}/boot/syslinux/isolinux.bin" ]; then
        rm -f "${ROOT_OF_ISO_PATH}/boot/syslinux/boot.catalog"
        rm -fR "${ROOT_OF_ISO_PATH}/[BOOT]/"
        rm -fR "${ROOT_OF_ISO_PATH}/boot.images/"

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
            echo "ERROR: Something went wrong, while creating '${ISO_FILENAME}'".
        fi
    else
        echo "ERROR: '${ROOT_OF_ISO_PATH}/boot/syslinux/isolinux.bin' could not be found."
    fi
elif [ -z "$MKISOFS" ]; then
    echo "ERROR: The 'mkisofs' program could not be found. Install it and try again."
fi

# Clean up.
rm -fR "$ROOT_OF_ISO_PATH"

echo "'$ROOT_OF_ISO_PATH' has been cleaned up."
