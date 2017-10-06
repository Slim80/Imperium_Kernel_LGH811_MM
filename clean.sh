#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export ARCH=arm64
export SUBARCH=arm64
# export PATH=/home/slim80/Scrivania/Kernel/Compilatori/aarch64-linux-android-4.9/bin:$PATH
export PATH=/home/slim80/Scrivania/Kernel/Compilatori/DespairFactor-aarch64-linux-android-4.9/bin:$PATH
export CROSS_COMPILE=aarch64-linux-android-
export KCONFIG_NOTIMESTAMP=true

IMPERIUM="/home/slim80/Scrivania/Kernel/LG/Imperium"
KERNELDIR="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811"
BUILDKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Build_Kernel_H811"
FINALKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Final_Kernel"
IMAGE="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/arch/arm64/boot"
RAMFS="/home/slim80/Scrivania/Kernel/LG/Imperium/ramfs_imperium_H811"

rm -f arch/arm64/boot/*.cmd
rm -f arch/arm64/boot/dts/*.cmd
rm -f arch/arm64/boot/Image*.*
rm -f arch/arm64/boot/.Image*.*
find -name '*.gz*' -exec rm -rf {} \;
find -name '*.dtb' -exec rm -rf {} \;
find -name '*.ko' -exec rm -rf {} \;
rm -f dt.img
rm -f $BUILDKERNEL/boot.img
rm -f $BUILDKERNEL/system/lib/modules/*
rm -f $KERNELDIR/ramfs_imperium_H811.cpio.gz

make clean
make distclean
rm -rf ~/.ccache
ccache -C
