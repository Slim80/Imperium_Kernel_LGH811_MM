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
BUILDEDKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Builded_Kernel"
IMAGE="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/arch/arm64/boot"
ANYKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/AnyKernel"
NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
VERSION=6.8

find -name '*.gz*' -exec rm -rf {} \;
find -name '*.dtb' -exec rm -rf {} \;
find -name '*.ko' -exec rm -rf {} \;
rm -rf $ANYKERNEL/zImage
rm -rf $ANYKERNEL/dt.img

rm -rf ~/.ccache
ccache -C

make ARCH=arm64 imperium_H811_defconfig || exit 1

make -j$NUM_CPUS || exit 1

cp arch/arm64/boot/Image.gz-dtb $ANYKERNEL/zImage

DTB=`find . -name "*.dtb" | head -1`echo $DTB
echo $DTB
DTBDIR=`dirname $DTB`
echo $DTBDIR
[[ -z `strings $DTB | grep "qcom,board-id"` ]] || DTBVERCMD="--force-v3"
echo $DTBVERCMD
./scripts/dtbtoolv3 $DTBVERCMD -o dt.img -s 4096 -p scripts/dtc/ $DTBDIR/

cp dt.img $ANYKERNEL/dt.img

rm -rf imperium_install
mkdir -p imperium_install
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} -j4 INSTALL_MOD_PATH=imperium_install INSTALL_MOD_STRIP=1 modules_install
find imperium_install/ -name '*.ko' -type f -exec cp '{}' $ANYKERNEL/modules/ \;

sh ./exfat.sh

cd $ANYKERNEL
zip -r ../../Builded_Kernel/Imperium_Kernel_G4_H811_v$VERSION.zip .

echo "* Done! *"
echo "* Imperium Kernel v$VERSION is ready to be flashad *"
