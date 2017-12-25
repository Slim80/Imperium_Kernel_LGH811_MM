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
NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
VERSION=7.4a

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

make ARCH=arm64 imperium_H811_defconfig || exit 1

make -j$NUM_CPUS || exit 1

DTB=`find . -name "*.dtb" | head -1`echo $DTB
echo $DTB
DTBDIR=`dirname $DTB`
echo $DTBDIR
[[ -z `strings $DTB | grep "qcom,board-id"` ]] || DTBVERCMD="--force-v3"
echo $DTBVERCMD
./scripts/dtbtoolv3 $DTBVERCMD -o dt.img -s 4096 -p scripts/dtc/ $DTBDIR/

sh ./fix_ramfs_permissions_H811.sh

cd $RAMFS
find . | cpio -H newc -o | gzip > $KERNELDIR/ramfs_imperium_H811.cpio.gz
cd $KERNELDIR

./scripts/mkbootimg --kernel $IMAGE/Image --ramdisk $KERNELDIR/ramfs_imperium_H811.cpio.gz --base 0x00000000 --pagesize 4096 --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --second_offset 0x00f00000 --hash sha1 --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.selinux=permissive msm_rtb.filter=0x37 androidboot.hardware=p1' --dt dt.img -o $BUILDKERNEL/boot.img

rm -rf imperium_install
mkdir -p imperium_install
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} -j4 INSTALL_MOD_PATH=imperium_install INSTALL_MOD_STRIP=1 modules_install
find imperium_install/ -name '*.ko' -type f -exec cp -av {} $BUILDKERNEL/system/lib/modules/ \;

cd $BUILDKERNEL
zip -r Imperium_Kernel_G4_H811_v$VERSION.zip .
 
mv ./Imperium_Kernel_G4_H811_v* $FINALKERNEL

echo "* Done! *"
echo "* Imperium Kernel v$VERSION is ready to be flashed *"
