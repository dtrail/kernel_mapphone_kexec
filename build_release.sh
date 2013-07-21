#!/bin/bash
set -m


# Build script for JBX-Kernel RELEASE
echo "Cleaning out kernel source directory..."
make mrproper
make ARCH=arm distclean


# Exporting the toolchain (You may change this to your local toolchain location)
echo "Starting configuration of kernel..."
export PATH=~/build/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin:$PATH


# export the flags (leave this alone)
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-eabi-


# define the defconfig (Do not change)
make ARCH=arm mapphone_defconfig
export LOCALVERSION="-Stock-1.0-Core"


# execute build command with "-j4 core flag" 
# (You may change this to the count of your CPU.
# Don't set it too high or it will result in a non-bootable kernel.
echo "Building..."
make -j4


# Copy and rename the zImage into nightly/nightly package folder
# Keep in mind that we assume that the modules were already built and are in place
# So we just copy and rename, then pack to zip including the date
echo "Packaging flashable Zip file..."
cp arch/arm/boot/zImage /home/mnl-manz/dtrail/built/system/etc/kexec/kernel

# Build modules
# make modules


# Move the modules to package folder
# echo "Copying modules to package folder"
# find -name '*.ko' -exec mv {} /home/mnl-manz/dtrail/built/system/lib/modules \;


# Pack the stuff together
cd /home/mnl-manz/dtrail/built
zip -r "Stock-1.0-Core-Kernel_$(date +"%Y-%m-%d").zip" *
mv "Stock-1.0-Core-Kernel_$(date +"%Y-%m-%d").zip" /home/mnl-manz/dtrail


# Exporting changelog to file
echo "Exporting changelog to file: '/built/Changelog-[date]'"
cd /home/mnl-manz/dtrail/kernel_mapphone_kexec
git log --oneline --after="yesterday" > /home/mnl-manz/dtrail/kernel_mapphone_kexec/changelog/Changelog_$(date +"%Y-%m-%d")
git add changelog/ .
git commit -m "Added todays changelog"
git push origin stock-mod

echo "Done. Kernel Package is ready!"
