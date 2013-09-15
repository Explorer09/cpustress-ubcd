In the previous versions, the Parted Magic's kernel was usually used to boot
with the CPUstress initrd image. However, since version 2.3, using Parted
Magic's kernel is no longer supported. This is because I (Explorer) found out
that a lot of problems from PMagic's kernel can be solved by building a kernel
myself.

This directory contains various scripts and patches that can help you
customize CPUstress to work with PMagic's kernel.

Use at your own risk! Because I will not support or answer any questions
regarding these scripts and patches.

Here are the problems that you may encounter when using PMagic's kernel:
- USB keyboard is not functioning.
- The 'sensors' program detects no hardware sensors.
- mdev does not load necessary modules, and you'll have to probe the modules
  manually.
- When using the i686 kernel, old processors won't boot. When using the i586
  kernel, you'll lose SMP and can only stress one processor.

Some of the problems can be solved using the patches here; other don't.

compile-notes.patch: This file patched the busybox config to enable modprobe
and lsmod. You'll need to re-compile BusyBox after this. It also updates the
compile notes of the kernel in case you want to work with modules.

initrd-modules-support.patch: This file updates some init scripts in initrd
image to support modprobe.

pmagic-kernel-modules.sh: Run this in Parted Magic and you'll get the
necessary kernel modules for CPUstress.

--Explorer <explorer09@gmail.com>
