#!/bin/bash
set -m

# Build script for JBX-Kernel RELEASE
echo "Cleaning out kernel source directory..."
make mrproper
make ARCH=arm distclean

# Switch to kernel folder
echo "Entering kernel source..."
cd ~/razr_kdev_kernel/android_kernel_motorola_omap4-common

# Exporting the toolchain (You may change this to your local toolchain location)
echo "Starting configuration of kernel..."
export PATH=~/build/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin:$PATH

# export the flags (leave this alone)
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-eabi-

# define the defconfig (Do not change)
make ARCH=arm mapphone_OCE_defconfig
export LOCALVERSION="-JBX-0.7c-Core"

# execute build command with "-j4 core flag" 
# (You may change this to the count of your CPU.
# Don't set it too high or it will result in a non-bootable kernel.
echo "Building..."
make -j4


echo "done"
