CPUstress image - version 2.2.1:
================================

Made by Gert Hulselmans ("Icecube") and modified by Kang-Che Sung ("Explorer").

Released under the GNU General Public License, version 2.

Last edited on 12 April 2013.


Content of this package:
_________________________

./build.txz      ==> tar archive that contains the files that you need to
                     rebuild the image and the kernel

./bzImage        ==> kernel image (from Parted Magic)

./changes.txt    ==> a changelog

./gpl-2.0.txt    ==> GNU General Public License, version 2

./help/          ==> contains help texts for some programs (also available in
                     the image itself)

./initrd.gz      ==> initrd

./readme.txt     ==> this readme file


Content of the ./build.txz archive:
____________________________________

./build-initrd/  ==> contains all files which will be packed in the initrd

./compile-notes/ ==> contains notes about the compiled binaries as well as
                     configfiles for the kernel and busybox

./build          ==> build script to build the image

./extract        ==> script to extract the initrd.gz image

The ./build-initrd/ directory is empty. See the section below for how to
extract the files from initrd.gz.


How to start?
_____________


Copy initrd.gz to ./ubcd/boot/cpustress/ of your extracted UBCD iso.

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

Unpack the cpustress-2.2.1.7z archive (you probably already did this, else you
couldn't read this README.
$ 7z x "./path/to/file/cpustress-2.2.1.7z"

Extract the ./build tar archive and the initrd.gz file:
$ cd cpustress-2.2.1
$ tar xvJf build.txz
$ cd build
$ cp ../initrd.gz .
$ ./extract

Now you can edit the files in ./build-initrd/ and remaster the initrd.gz with
the ./build script.

./build-initrd/usr/local/bin/ (/usr/local/bin/ directory in the image) contains
the cpustress specific programs, like cpuburn, cpuinfo, helpinfo, menu, mprime,
stress and stresscpu2.

./build-initrd/opt/ (/opt/ directory in the image) directory contains some help
files and some cpustress specific programs.


Contents of the isolinux config files:
______________________________________

  ############################################################
  # REMARK: All APPEND stuff should be on 1 line.            #
  #         For readability reasons it is placed on 2 lines. #
  ############################################################

CPU Burn-in v1.00: cpuburn
------------------

Run cpuburn without time parameter (it will run cpuburn-in for 10080
minutes (= 7 days)).

     COM32  linux.c32 /ubcd/boot/cpustress/bzImage
     INITRD /ubcd/boot/cpustress/initrd.gz
     APPEND noapic ubcdcmd=cpuburn

Run cpuburn with a time parameter:

  eg. Run cpuburn for 10 days.

     COM32  linux.c32 /ubcd/boot/cpustress/bzImage
     INITRD /ubcd/boot/cpustress/initrd.gz
     APPEND noapic ubcdcmd=cpuburn days=10


  eg. Run cpuburn for 10 hours.

     COM32  linux.c32 /ubcd/boot/cpustress/bzImage
     INITRD /ubcd/boot/cpustress/initrd.gz
     APPEND noapic ubcdcmd=cpuburn hours=10


  eg. Run cpuburn for 10 minutes.

     COM32  linux.c32 /ubcd/boot/cpustress/bzImage
     INITRD /ubcd/boot/cpustress/initrd.gz
     APPEND noapic ubcdcmd=cpuburn minutes=10


If those parameters are all provided to the APPEND command of the isolinux
config, the run time will be determined by the first value of the time duration
which will be searched in the following order: days > hours > minutes.
So if 'minutes=100000000' and 'days=10' is found, the run time will be set to
14400 minutes (= 10 days).


CPUinfo v1.00: cpuinfo
--------------

The following isolinux entry will run CPUinfo:

     COM32  linux.c32 /ubcd/boot/cpustress/bzImage
     INITRD /ubcd/boot/cpustress/initrd.gz
     APPEND noapic ubcdcmd=cpuinfo


Helpinfo: helpinfo
---------

The following isolinux entry will run Helpinfo:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=helpinfo


The following isolinux entry will run Helpinfo for cpuburn:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=helpinfo cmdhelpinfo=cpuburn

You can change the cmdhelpinfo parameter to:
    - cpuburn
    - cpuinfo
    - helpinfo
    - mprime
    - stress
    - stresscpu2


Menu: menu
-----

The following isolinux entry will display the menu.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=menu


Mersenne Prime Torture test: mprime
----------------------------

The following isolinux entry will prompt to ask which version of mprime you
want to run.

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=mprime

If you want to run a specific version of mprime, when you boot the image, use:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=mprime23

      This will start 'Mersenne Prime 23.9.2'.


    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=mprime27

      This will start 'Mersenne Prime 27.9'.


Stress v1.0.4: stress
--------------

The following isolinux entry will run stress (will display the help text).

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=stress

If you want to run a stress with specific parameters, when you boot the image,
use something similar to:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=stress cmdstress="--quiet -c 1k"

The cmdstress parameter contains the options that you want to pass to stress.


CPU stress tester 2.0: stresscpu2
----------------------

The following isolinux entry will run stresscpu2 (will display the help text).

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=stresscpu2

If you want to run a stresscpu2 with specific parameters, when you boot the
image, use something similar to:

    COM32  linux.c32 /ubcd/boot/cpustress/bzImage
    INITRD /ubcd/boot/cpustress/initrd.gz
    APPEND noapic ubcdcmd=stresscpu2 cmdstresscpu2="-s -t 48:00:00"

The cmdstresscpu2 parameter contains the options that you want to pass to
stresscpu2.


You can add 'quiet' to all APPEND lines to suppress the kernel text output at
boot time.


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
