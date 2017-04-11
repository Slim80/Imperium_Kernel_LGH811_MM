#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export ARCH=arm64
export SUBARCH=arm64
export PATH=/home/slim80/Scrivania/Kernel/Compilatori/aarch64-linux-android-4.9/bin:$PATH
export CROSS_COMPILE=aarch64-linux-android-

IMPERIUM="/home/slim80/Scrivania/Kernel/LG/Imperium"
EXFAT="/home/slim80/Scrivania/Kernel/LG/Imperium/exfat"
KERNELDIR="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811"
BUILDEDKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Builded_Kernel"
ANYKERNEL="/home/slim80/Scrivania/Kernel/LG/Imperium/Imperium_Kernel_H811/AnyKernel"

rm -f $BUILDEDKERNEL/Builded_Kernel/system/lib/modules/texfat.ko
cp -f tuxera_update.sh $IMPERIUM
mkdir -p $EXFAT/sign
mkdir -p $EXFAT/out/system/lib/modules

sleep 1

sh $IMPERIUM/tuxera_update.sh --target target/lg.d/mobile-msm8992-3.10.84 --use-cache --latest --max-cache-entries 2 --source-dir $KERNELDIR --output-dir $EXFAT/sign -a --user lg-mobile --pass AumlTsj0ou

sleep 1

if [ -e signing_key.priv ]; then
	mv signing_key.priv $EXFAT/sign;
	mv signing_key.x509 $EXFAT/sign;
fi;

tar -xzf tuxera-exfat*.tgz
cp tuxera-exfat*/exfat/kernel-module/texfat.ko $EXFAT/out/system/lib/modules/
cp tuxera-exfat*/exfat/tools/* $EXFAT/out/
perl ./scripts/sign-file sha1 $EXFAT/sign/signing_key.priv $EXFAT/sign/signing_key.x509 $EXFAT/out/system/lib/modules/texfat.ko
cp $EXFAT/out/system/lib/modules/texfat.ko $ANYKERNEL/modules/
rm -f kheaders*.tar.bz2
rm -f tuxera-exfat*.tgz
rm -rf tuxera-exfat*
rm -rf .tuxera_update_cache
rm -rf $EXFAT/sign
rm -rf $EXFAT/out
rm -f $IMPERIUM/tuxera_update.sh

