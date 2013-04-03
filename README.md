CPUstress test
==============

The CPUstress test image is an initramfs image that contains several tools for 
CPU stressing.

It contains the following tools:
* CPU Burn-in
* CPUinfo
* Mersenne Prime Test (prime95)
* Stress
* StressCPU

CPUstress is used in Ultimate Boot CD.

How to build
------------

This repositories contains a few shell scripts that allows you to build disk 
images for different uses. However, there's no Makefile yet so you have to 
execute several scripts in a sequence.

Building CPUstress for Ultimate Boot CD:
1. Run 'cpustress/build/build'
2. An initrd.gz file should appear at 'cpustress/build', move it to the parent 
   directory (that is, 'cpustress').
3. Run 'scripts/pack_buildtxz.sh'
4. Run 'scripts/make_7z.sh'
5. A 7z archive should appear in the top directory of the repo. This archive 
   contains files you need to update CPUstress in UBCD. Unpack it to the 
   'ubcd/boot/cpustress' of your extracted UBCD directory.

Building CPUstress in a standalone ISO image:
1. Run 'cpustress/build/build'
2. An initrd.gz file should appear at 'cpustress/build', move it to the parent 
   directory (that is, 'cpustress').
3. Run 'scripts/pack_buildtxz.sh'
4. Run 'scripts/make_iso.sh'
5. An ISO file should appear in the top directory of the repo. You may burn 
   it into a CD if you like.

Authors
-------

The CPUstress image is originally made by Gert Hulselmans ("Icecube").
Based on a CPU Burn-in bootable image by Adrian Stanciu.

The image is now modified and maintained by Kang-Che Sung ("Explorer") 
< explorer09 at gmail dot com > .

License
-------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 2 (only).

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Please note that some programs included in this image might be licensed under 
different terms. The GNU General Public License is applied to the initrd 
image and the shell scripts only.

For licensing information about individual programs, please refer to the 
website or the about page of that specific program.

Links
-----

CPU Burn-in
http://web.archive.org/web/20090620184505/http://users.bigpond.net.au/CPUBURN/

Prime95
http://www.mersenne.org/freesoft/

Stress
http://weather.ou.edu/~apw/projects/stress/

StressCPU2
http://www.gromacs.org/Downloads/User_contributions/Other_software/

Ultimate Boot CD
http://www.ultimatebootcd.com/

