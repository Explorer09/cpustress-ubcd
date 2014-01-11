CPUstress image - development version:
======================================

Made by Gert Hulselmans ("Icecube") and modified by Kang-Che Sung ("Explorer").

Released under the GNU General Public License, version 2.

Last edited on 11 January 2014.


Content of this package:
_________________________

./build.txz      ==> tar archive that contains the files that you need to
                     rebuild the image and the kernel

./bzImage        ==> kernel image (from Parted Magic)

./changes.txt    ==> a changelog

./gpl-2.0.txt    ==> GNU General Public License, version 2

./help/          ==> contains help texts for some programs (also available in
                     the image itself)

./initrd.xz      ==> initrd

./nonfree.txt    ==> notes about the non-free programs

./readme.txt     ==> this readme file


Content of the ./build.txz archive:
____________________________________

./build-initrd/  ==> contains all files which will be packed in the initrd

./compile-notes/ ==> contains notes about the compiled binaries as well as
                     configfiles for the kernel and busybox

./build          ==> build script to build the image

./extract        ==> script to extract the initrd.xz image

The ./build-initrd/ directory is empty. See the section below for how to
extract the files from initrd.xz.


How to start?
_____________


Copy initrd.xz to ./ubcd/boot/cpustress/ of your extracted UBCD iso.

Windows:
--------

e.g.: If you have extracted UBCD to c:\ubcd-extract\, this place is:
      c:\ubcd-extract\ubcd\boot\cpustress\

Linux:
------

e.g.: If you have extracted UBCD to ~/ubcd-extract/, this place is:
      ~/ubcd-extract/ubcd/boot/cpustress/


How to edit the CPUstress image?
________________________________

Unpack the cpustress-develop.7z archive (you probably already did this, else you
couldn't read this README.
$ 7z x "./path/to/file/cpustress-develop.7z"

Extract the ./build tar archive and the initrd.xz file:
$ cd cpustress-develop
$ tar xvJf build.txz
$ cd build
$ cp ../initrd.xz .
$ ./extract

Now you can edit the files in ./build-initrd/ and remaster the initrd.xz with
the ./build script.

./build-initrd/usr/local/bin/ (/usr/local/bin/ directory in the image) contains
the cpustress specific programs, like cpuburn, cpuinfo, helpinfo, menu, mprime,
stress, stresscpu2 and systester.

./build-initrd/opt/ (/opt/ directory in the image) directory contains some help
files and some cpustress specific programs.


Contents of the isolinux config files:
______________________________________

  ############################################################
  # REMARK: All APPEND stuff should be on 1 line.            #
  #         For readability reasons it is placed on 2 lines. #
  ############################################################

CPUburn v1.4a: burn
--------------

The following isolinux entry will run burn, which automatically detects which
test to run:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=burn

If you want to run burn with a different test, use something similar to:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=burn ubcdargs="MMX 64k"

You can specify which test to run in the ubcdargs parameter, as well as the
option that you want to pass to the test program.


CPU Burn-in v1.00: cpuburn-in
------------------

Run cpuburn-in without time parameter (it will run cpuburn-in for 10080
minutes (= 7 days)).

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=cpuburn-in

Run cpuburn-in with a time parameter:

  eg. Run cpuburn-in for 10 days.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=cpuburn-in days=10


  eg. Run cpuburn-in for 10 hours.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=cpuburn-in hours=10


  eg. Run cpuburn-in for 10 minutes.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=cpuburn-in minutes=10


If those parameters are all provided to the APPEND command of the isolinux
config, the run time will be determined by the first value of the time duration
which will be searched in the following order: days > hours > minutes.
So if 'minutes=100000000' and 'days=10' is found, the run time will be set to
14400 minutes (= 10 days).


CPUinfo v1.00: cpuinfo
--------------

The following isolinux entry will run CPUinfo:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=cpuinfo


Helpinfo: helpinfo
---------

The following isolinux entry will run Helpinfo:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=helpinfo


The following isolinux entry will run Helpinfo for cpuburn:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=helpinfo ubcdargs=cpuburn

You can change the ubcdargs parameter to:
    - burn
    - cpuburn-in
    - cpuinfo
    - helpinfo
    - linpack
    - mprime
    - sensors
    - stress
    - stresscpu2
    - systester


Intel Optimized LINPACK 11.1.1: linpack
-------------------------------

The following isolinux entry will run the LINPACK benchmark in interactive
mode:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=helpinfo ubcdargs=linpack

The LINPACK benchmark accepts input data files. A sample data file is included
in the /opt/linpack directory in the cpustress image. After booting, you can
edit the data file using vi. To run LINPACK benchmark with the data file, use
something like 'linpack /opt/linpack/lininput_xeon32' on the command-line.


Menu: menu
-----

The following isolinux entry will display the menu.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=menu


Mersenne Prime Torture test: mprime
----------------------------

The following isolinux entry will prompt to ask which version of mprime you
want to run.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=mprime

If you want to run a specific version of mprime, when you boot the image, use:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=mprime23

      This will start 'Mersenne Prime 23.9.2'.


    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=mprime27

      This will start 'Mersenne Prime 27.9'.


Stress v1.0.4: stress
--------------

The following isolinux entry will run stress (will display the help text).

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=stress

If you want to run a stress with specific parameters, when you boot the image,
use something similar to:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=stress ubcdargs="--quiet -c 1k"

The ubcdargs parameter contains the options that you want to pass to stress.


CPU stress tester 2.0: stresscpu2
----------------------

The following isolinux entry will run stresscpu2:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=stresscpu2

If you want to run stresscpu2 with specific parameters, when you boot the
image, use something similar to:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=stresscpu2 ubcdargs="-s -t 48:00:00"

The ubcdargs parameter contains the options that you want to pass to
stresscpu2.


System Stability Tester 1.5.1: systester-cli
------------------------------

The following isolinux entry will run systester in the default test mode.
('systester -test -qcborwein 128K')

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=systester

If you want to run systester with specific parameters, when you boot the image,
use something similar to:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.xz
    APPEND noapic ubcdcmd=systester ubcdargs="-gausslg 1M -threads 2 -bench"

The ubcdargs parameter contains the options that you want to pass to systester.


Other notes:
------------

You can add 'quiet' to all APPEND lines to suppress the kernel text output at
boot time.

You can specify how many child processes or threads the program creates. The
way to specify this is different among programs.

    burn, cpuburn-in, and mprime23: Add instances=N to the APPEND line,
                                    where N is a positive integer.
    linpack:    Add OMP_NUM_THREADS=N to the APPEND line.
    stresscpu2: Add ubcdargs="-n N" to the APPEND line.
    systester:  Add ubcdargs="-threads N" to the APPEND line.
    mprime27:   You need to use the interactive menu. Adding ubcdargs="-m" will
                take you to the menu.


Thanks:
_______

Thanks go to the following persons:

* deadite:        for testing my first cpustress image, for revealing the
                  booting problem on some machines, for revealing that USB and
                  wireless keyboards didn't work with the first version and for
                  correcting the help files.
* StopSpazzing:   for testing the second version of my cpustress image with an
                  USB keyboard.
* Patrick Verner: for compiling a minimal kernel that enables support for USB
                  and wireless keyboards and for solving some other problems
                  that I had.
* alm:            for discovering the 'FATAL ERROR: Writing to temp file' bug
                  with mprime.
* owcraftsman     for discovering the 'FATAL ERROR: Writing to temp file' bug
                  with mprime after I thought it was fixed. (quad core)


Contact:
________

http://www.ultimatebootcd.com/forums/viewtopic.php?t=1476
Ask for Icecube ;-).

For Explorer's modifications, go to this discussion thread instead:
http://www.ultimatebootcd.com/forums/viewtopic.php?t=14643
