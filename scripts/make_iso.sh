#!/bin/sh
#
# Script to create a bootable CPUstress ISO image.
#
# This script is modified from ubcd2iso.sh script in Ultimate Boot CD.

# Change working directory to the parent directory of the script.
cd `dirname $0`
cd ..

# Define VOLUME_ID (LABEL) of the ISO
VOLUME_ID="CPUSTRESS"

# Define ISO filename
ISO_FILENAME="cpustress-2.2.iso"

ROOT_OF_ISO_PATH="$(pwd)/iso"

# Copy the cpustress directory for building ISO image.
rm -rf iso/ubcd/boot/cpustress/*
cp -aR cpustress/* iso/ubcd/boot/cpustress

# Save IFS
SAVED_IFS=$IFS

# Poor man's 'which' command
MKISOFS=''
IFS=:
for i in $PATH ; do
    if [ -x "$i/mkisofs" ] ; then
        MKISOFS="$i/mkisofs"
        break
    fi
done

# Restore IFS
IFS=$SAVED_IFS

if [ -n "$MKISOFS" -a -n "$ROOT_OF_ISO_PATH" ]; then
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
rm -rf iso/ubcd/boot/cpustress/*
cat >iso/ubcd/boot/cpustress/NOTICE.txt <<NOTICE
Please don't put any files inside this directory. They will be DELETED when 
building the ISO image.

The make_iso.sh script will temporarily copy the contents from the cpustress 
directory (at the top of the repo) to here. Then this directory will be 
cleaned up again, leaving only this NOTICE.txt.
NOTICE

echo "'iso/ubcd/boot/cpustress' has been cleaned up."
