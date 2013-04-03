#!/bin/sh

# This script collects the linux kernel modules from Parted Magic to use with 
# CPUstress initrd. To use this script:
#   1. Boot a Parted Magic live CD (either on a real machine or a VM)
#   2. Copy this script (pmagic-kernel-modules.sh) to the home directory 
#      (usually /root) on PMagic.
#   3. Run pmagic-kernel-modules.sh and watch the modules being prepared in 
#      the "fmu" directory inside home.
#   4. Copy the "lib" directory in "fmu" to the CPUstress initrd.
#
# You probably don't need this script, unless you need to boot CPUstress with
# a Parted Magic kernel.
#
# Written by Explorer.
# Last updated on 1 April 2013.

uname -r | grep 'pmagic64' > /dev/null
if [ "$?" -eq "0" ]; then
    echo "Please run this script on 32-bit version of Parted Magic."
    exit 1
fi

uname -r | grep 'pmagic' > /dev/null
if [ "$?" -ne "0" ]; then
    echo "Please run this script on 32-bit version of Parted Magic."
    exit 1
fi

if [ -z "$DESTDIR" ]; then
    DESTDIR="${HOME}/fmu"
fi
MODULES_DIR="${DESTDIR}/lib/modules/`uname -r`/kernel"

mkdir -p "$DESTDIR"
mkdir -p "$MODULES_DIR"
cd "/lib/modules/`uname -r`/kernel"
tar -c -f - -T - << MODULES_LIST | ( cd "${MODULES_DIR}" && tar -x -v -f -; )
arch/x86/kernel/microcode.ko
arch/x86/platform/iris/iris.ko
arch/x86/platform/scx200/scx200.ko
drivers/acpi/ac.ko
drivers/acpi/acpi_pad.ko
drivers/acpi/battery.ko
drivers/acpi/button.ko
drivers/acpi/container.ko
drivers/acpi/fan.ko
drivers/acpi/processor.ko
drivers/acpi/thermal.ko
drivers/char/i8k.ko
drivers/char/toshiba.ko
drivers/clocksource/scx200_hrt.ko
drivers/hid/hid-a4tech.ko
drivers/hid/hid-apple.ko
drivers/hid/hid-belkin.ko
drivers/hid/hid-cherry.ko
drivers/hid/hid-chicony.ko
drivers/hid/hid-cypress.ko
drivers/hid/hid-ezkey.ko
drivers/hid/hid-generic.ko
drivers/hid/hid-gyration.ko
drivers/hid/hid-holtekff.ko
drivers/hid/hid-holtek-kbd.ko
drivers/hid/hid-kensington.ko
drivers/hid/hid-keytouch.ko
drivers/hid/hid-logitech.ko
drivers/hid/hid-microsoft.ko
drivers/hid/hid-monterey.ko
drivers/hid/hid-ortek.ko
drivers/hid/hid-petalynx.ko
drivers/hid/hid-pl.ko
drivers/hid/hid-primax.ko
drivers/hid/hid-roccat-arvo.ko
drivers/hid/hid-roccat-common.ko
drivers/hid/hid-roccat-isku.ko
drivers/hid/hid-roccat-kone.ko
drivers/hid/hid-roccat-koneplus.ko
drivers/hid/hid-roccat-kovaplus.ko
drivers/hid/hid-roccat-lua.ko
drivers/hid/hid-roccat-pyra.ko
drivers/hid/hid-roccat-savu.ko
drivers/hid/hid-roccat.ko
drivers/hid/hid-samsung.ko
drivers/hid/hid-sony.ko
drivers/hid/hid-sunplus.ko
drivers/hid/hid.ko
drivers/hid/usbhid/usbhid.ko
drivers/hwmon/hwmon.ko
drivers/input/mouse/psmouse.ko
drivers/input/serio/altera_ps2.ko
drivers/input/serio/pcips2.ko
drivers/input/serio/ps2mult.ko
drivers/input/serio/serio_raw.ko
drivers/input/serio/serport.ko
drivers/scsi/sg.ko
drivers/thermal/thermal_sys.ko
drivers/usb/chipidea/ci13xxx_imx.ko
drivers/usb/chipidea/ci13xxx_msm.ko
drivers/usb/chipidea/ci13xxx_pci.ko
drivers/usb/chipidea/ci_hdrc.ko
drivers/usb/chipidea/usbmisc_imx6q.ko
drivers/usb/host/ehci-hcd.ko
drivers/usb/host/hwa-hc.ko
drivers/usb/host/isp116x-hcd.ko
drivers/usb/host/isp1362-hcd.ko
drivers/usb/host/isp1760.ko
drivers/usb/host/ohci-hcd.ko
drivers/usb/host/oxu210hp-hcd.ko
drivers/usb/host/r8a66597-hcd.ko
drivers/usb/host/sl811-hcd.ko
drivers/usb/host/uhci-hcd.ko
drivers/usb/host/whci/whci-hcd.ko
drivers/usb/host/xhci-hcd.ko
drivers/usb/wusbcore/wusb-cbaf.ko
drivers/usb/wusbcore/wusb-wa.ko
drivers/usb/wusbcore/wusbcore.ko
drivers/uwb/hwa-rc.ko
drivers/uwb/umc.ko
drivers/uwb/uwb.ko
drivers/uwb/whc-rc.ko
drivers/uwb/whci.ko
fs/binfmt_aout.ko
fs/binfmt_misc.ko
fs/ext2/ext2.ko
fs/nls/nls_ascii.ko
fs/nls/nls_cp437.ko
fs/nls/nls_iso8859-1.ko
fs/nls/nls_utf8.ko
MODULES_LIST

cp "/lib/modules/`uname -r`/modules.order" "${DESTDIR}/lib/modules/`uname -r`"
cp "/lib/modules/`uname -r`/modules.builtin" "${DESTDIR}/lib/modules/`uname -r`"

depmod -a -w -b $DESTDIR
