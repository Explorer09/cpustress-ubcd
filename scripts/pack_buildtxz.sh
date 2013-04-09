#!/bin/sh

# Change working directory to the directory of the script.
cd `dirname $0`
# Then change directory to where we create the build.txz file.
cd ../cpustress

if [ -d "build" ]; then
    rm -i build.txz build.tar
    # The files in build/build-initrd are excluded, but the directory itself 
    # isn't.
    tar -c -v --exclude='build/build-initrd/*' --exclude='build/initrd.gz' \
      --exclude-backups --exclude-vcs -f build.tar build
    xz -F xz -6 -c <build.tar >build.txz
    rm -f build.tar
else
    echo "ERROR: $(pwd)/build is not a directory."
    exit 1
fi

exit 0
