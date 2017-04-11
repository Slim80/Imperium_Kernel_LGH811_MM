# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Imperium-Kernel by Slim80 @xda-developers
do.devicecheck=1
do.initd=0
do.modules=1
do.cleanup=1
device.name1=p1_global_com
device.name2=LG-H815
device.name3=LG G4
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;

## end setup

# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel install
dump_boot;

# begin ramdisk changes
# set permissions
chmod 775 $ramdisk/sbin
chmod 755 $ramdisk/sbin/busybox

# init.qcom.rc
insert_line init.qcom.rc "init.imperium.rc" after "import init.qcom.usb.rc" "import init.imperium.rc";

# end ramdisk changes

write_boot;

## end install
