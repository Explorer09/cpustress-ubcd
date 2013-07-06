#!/bin/sh
#
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
#
# Licensed under the GNU General Public License, version 2 or later.
# This program comes with ABSOLUTLY NO WARRANTY. See the GNU GPL for details:
# <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#
# Written by Explorer.
# Last updated on 6 July 2013.

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
drivers/acpi/acpi_i2c.ko
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
drivers/hid/hid-holtek-kbd.ko
drivers/hid/hid-holtekff.ko
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
drivers/hwmon/abituguru.ko
drivers/hwmon/abituguru3.ko
drivers/hwmon/acpi_power_meter.ko
drivers/hwmon/ad7414.ko
drivers/hwmon/ad7418.ko
drivers/hwmon/adm1021.ko
drivers/hwmon/adm1025.ko
drivers/hwmon/adm1026.ko
drivers/hwmon/adm1029.ko
drivers/hwmon/adm1031.ko
drivers/hwmon/adm9240.ko
drivers/hwmon/ads1015.ko
drivers/hwmon/ads7828.ko
drivers/hwmon/adt7410.ko
drivers/hwmon/adt7411.ko
drivers/hwmon/adt7462.ko
drivers/hwmon/adt7470.ko
drivers/hwmon/adt7475.ko
drivers/hwmon/amc6821.ko
drivers/hwmon/applesmc.ko
drivers/hwmon/asb100.ko
drivers/hwmon/asc7621.ko
drivers/hwmon/asus_atk0110.ko
drivers/hwmon/atxp1.ko
drivers/hwmon/coretemp.ko
drivers/hwmon/dme1737.ko
drivers/hwmon/ds1621.ko
drivers/hwmon/ds620.ko
drivers/hwmon/emc1403.ko
drivers/hwmon/emc2103.ko
drivers/hwmon/emc6w201.ko
drivers/hwmon/f71805f.ko
drivers/hwmon/f71882fg.ko
drivers/hwmon/f75375s.ko
drivers/hwmon/fam15h_power.ko
drivers/hwmon/fschmd.ko
drivers/hwmon/g760a.ko
drivers/hwmon/gl518sm.ko
drivers/hwmon/gl520sm.ko
drivers/hwmon/hih6130.ko
drivers/hwmon/hwmon-vid.ko
drivers/hwmon/hwmon.ko
drivers/hwmon/i5k_amb.ko
drivers/hwmon/ina2xx.ko
drivers/hwmon/it87.ko
drivers/hwmon/jc42.ko
drivers/hwmon/k10temp.ko
drivers/hwmon/k8temp.ko
drivers/hwmon/lineage-pem.ko
drivers/hwmon/lm63.ko
drivers/hwmon/lm73.ko
drivers/hwmon/lm75.ko
drivers/hwmon/lm77.ko
drivers/hwmon/lm78.ko
drivers/hwmon/lm80.ko
drivers/hwmon/lm83.ko
drivers/hwmon/lm85.ko
drivers/hwmon/lm87.ko
drivers/hwmon/lm90.ko
drivers/hwmon/lm92.ko
drivers/hwmon/lm93.ko
drivers/hwmon/lm95241.ko
drivers/hwmon/lm95245.ko
drivers/hwmon/ltc4151.ko
drivers/hwmon/ltc4215.ko
drivers/hwmon/ltc4245.ko
drivers/hwmon/ltc4261.ko
drivers/hwmon/max16065.ko
drivers/hwmon/max1619.ko
drivers/hwmon/max1668.ko
drivers/hwmon/max197.ko
drivers/hwmon/max6639.ko
drivers/hwmon/max6642.ko
drivers/hwmon/max6650.ko
drivers/hwmon/mcp3021.ko
drivers/hwmon/ntc_thermistor.ko
drivers/hwmon/pc87360.ko
drivers/hwmon/pc87427.ko
drivers/hwmon/pcf8591.ko
drivers/hwmon/pmbus/adm1275.ko
drivers/hwmon/pmbus/lm25066.ko
drivers/hwmon/pmbus/ltc2978.ko
drivers/hwmon/pmbus/max16064.ko
drivers/hwmon/pmbus/max34440.ko
drivers/hwmon/pmbus/max8688.ko
drivers/hwmon/pmbus/pmbus.ko
drivers/hwmon/pmbus/pmbus_core.ko
drivers/hwmon/pmbus/ucd9000.ko
drivers/hwmon/pmbus/ucd9200.ko
drivers/hwmon/pmbus/zl6100.ko
drivers/hwmon/sht15.ko
drivers/hwmon/sht21.ko
drivers/hwmon/sis5595.ko
drivers/hwmon/smm665.ko
drivers/hwmon/smsc47b397.ko
drivers/hwmon/smsc47m1.ko
drivers/hwmon/smsc47m192.ko
drivers/hwmon/thmc50.ko
drivers/hwmon/tmp102.ko
drivers/hwmon/tmp401.ko
drivers/hwmon/tmp421.ko
drivers/hwmon/via-cputemp.ko
drivers/hwmon/via686a.ko
drivers/hwmon/vt1211.ko
drivers/hwmon/vt8231.ko
drivers/hwmon/w83627ehf.ko
drivers/hwmon/w83627hf.ko
drivers/hwmon/w83781d.ko
drivers/hwmon/w83791d.ko
drivers/hwmon/w83792d.ko
drivers/hwmon/w83793.ko
drivers/hwmon/w83795.ko
drivers/hwmon/w83l785ts.ko
drivers/hwmon/w83l786ng.ko
drivers/i2c/algos/i2c-algo-bit.ko
drivers/i2c/algos/i2c-algo-pca.ko
drivers/i2c/busses/i2c-ali1535.ko
drivers/i2c/busses/i2c-ali1563.ko
drivers/i2c/busses/i2c-ali15x3.ko
drivers/i2c/busses/i2c-amd756-s4882.ko
drivers/i2c/busses/i2c-amd756.ko
drivers/i2c/busses/i2c-amd8111.ko
drivers/i2c/busses/i2c-designware-core.ko
drivers/i2c/busses/i2c-designware-pci.ko
drivers/i2c/busses/i2c-eg20t.ko
drivers/i2c/busses/i2c-i801.ko
drivers/i2c/busses/i2c-intel-mid.ko
drivers/i2c/busses/i2c-isch.ko
drivers/i2c/busses/i2c-nforce2-s4985.ko
drivers/i2c/busses/i2c-nforce2.ko
drivers/i2c/busses/i2c-ocores.ko
drivers/i2c/busses/i2c-pca-platform.ko
drivers/i2c/busses/i2c-piix4.ko
drivers/i2c/busses/i2c-pxa.ko
drivers/i2c/busses/i2c-scmi.ko
drivers/i2c/busses/i2c-simtec.ko
drivers/i2c/busses/i2c-sis5595.ko
drivers/i2c/busses/i2c-sis630.ko
drivers/i2c/busses/i2c-sis96x.ko
drivers/i2c/busses/i2c-via.ko
drivers/i2c/busses/i2c-viapro.ko
drivers/i2c/busses/i2c-xiic.ko
drivers/i2c/i2c-core.ko
drivers/i2c/i2c-dev.ko
drivers/i2c/i2c-mux.ko
drivers/i2c/muxes/i2c-mux-pca9541.ko
drivers/i2c/muxes/i2c-mux-pca954x.ko
drivers/input/input-polldev.ko
drivers/input/mouse/psmouse.ko
drivers/input/serio/altera_ps2.ko
drivers/input/serio/pcips2.ko
drivers/input/serio/ps2mult.ko
drivers/input/serio/serio_raw.ko
drivers/input/serio/serport.ko
drivers/leds/led-class.ko
drivers/mfd/lpc_sch.ko
drivers/mfd/mfd-core.ko
drivers/of/of_i2c.ko
drivers/platform/x86/acerhdf.ko
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
