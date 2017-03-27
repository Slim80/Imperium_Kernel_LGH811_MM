#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export ARCH=arm64
export SUBARCH=arm64
# export PATH=/home/slim80/Scrivania/Kernel/Compilatori/aarch64-linux-android-4.9/bin:$PATH
export PATH=/home/slim80/Scrivania/Kernel/Compilatori/DespairFactor-aarch64-linux-android-4.9/bin:$PATH
export CROSS_COMPILE=aarch64-linux-android-
export TARGET_PREBUILT_KERNEL=/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/arch/arm64/boot/Image.gz-dtb
export KCONFIG_NOTIMESTAMP=true

IMPERIUM="/home/slim80/Scrivania/Kernel/LG/Imperium"
KERNELDIR="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811"
BUILDEDKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/1_Imperium"
IMAGE="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/arch/arm64/boot"
RAMFS="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_ramdisk_H811"
VERSION=6.8

find -name '*.dtb' -exec rm -rf {} \;
find -name '*.ko' -exec rm -rf {} \;
rm -f $BUILDEDKERNEL/Builded_Kernel/boot.img
rm -f dt.img
rm -f $IMPERIUM/Imperium_ramdisk_H811.cpio.gz
rm -f $IMPERIUM/Imperium_ramdisk_H811_systemless.cpio.gz

rm -rf ~/.ccache
ccache -C

make ARCH=arm64 imperium_H811_defconfig || exit 1

make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} -j4 || exit 1

DTB=`find . -name "*.dtb" | head -1`echo $DTB
echo $DTB
DTBDIR=`dirname $DTB`
echo $DTBDIR
[[ -z `strings $DTB | grep "qcom,board-id"` ]] || DTBVERCMD="--force-v3"
echo $DTBVERCMD
./scripts/dtbtoolv3 $DTBVERCMD -o dt.img -s 4096 -p scripts/dtc/ $DTBDIR/

sh ./fix_ramfs_permissions_H811.sh

cd $RAMFS
find | fakeroot cpio -H newc -o > $RAMFS.cpio 2>/dev/null
ls -lh $RAMFS.cpio
gzip -9 $RAMFS.cpio
cd $KERNELDIR

./scripts/mkbootimg --kernel $IMAGE/Image --ramdisk $IMPERIUM/Imperium_ramdisk_H811.cpio.gz --base 0x00000000 --pagesize 4096 --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.selinux=permissive msm_rtb.filter=0x37 androidboot.hardware=p1' --dt dt.img -o $BUILDEDKERNEL/Builded_Kernel/boot.img

rm -rf imperium_install
mkdir -p imperium_install
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} -j4 INSTALL_MOD_PATH=imperium_install INSTALL_MOD_STRIP=1 modules_install
find imperium_install/ -name '*.ko' -type f -exec cp '{}' $BUILDEDKERNEL/Builded_Kernel/system/lib/modules/ \;

sh ./exfat.sh

cd $BUILDEDKERNEL/Builded_Kernel/
zip -r ../Imperium_Kernel_G4_H811_v$VERSION.zip .

echo "* Done! *"
echo "* Imperium Kernel v$VERSION is ready to be flashad *"
