#!/system/bin/sh

BB=/sbin/busybox

$BB mount -t rootfs -o remount,rw rootfs

sync

# Installing Busybox
$BB chmod 06755 /system/xbin/busybox
./system/xbin/busybox --install -s /system/xbin/

# Fixing su permissions
if [ -e /system/xbin/su ]; then
	$BB chmod 06755 /system/xbin/su;
fi;
if [ -e /system/xbin/daemonsu ]; then
	$BB chmod 06755 /system/xbin/daemonsu;
fi;

# Fixing ROOT
/system/xbin/daemonsu --auto-daemon &

# Fix init.d folder permissions
$BB chown -R root.root /system/etc/init.d
$BB chmod -R 755 /system/etc/init.d
$BB chmod 755 /system/etc/init.d/*

# Start script in init.d folder
$BB run-parts /system/etc/init.d/

# Cleaning
$BB rm -rf /cache/lost+found/* 2> /dev/null;
$BB rm -rf /data/lost+found/* 2> /dev/null;
$BB rm -rf /data/tombstones/* 2> /dev/null;

### Improve Battery
# vm tweaks
busybox sysctl -w vm.swappiness=80

# setprop
setprop persist.adb.notify 0
setprop persist.service.adb.enable 1
setprop pm.sleep_mode 1
setprop logcat.live disable
setprop profiler.force_disable_ulog 1
setprop wifi.supplicant_scan_interval 320

# Stop LG logging to /data/logger/$FILE we dont need that. draning power.
setprop persist.service.events.enable 0
setprop persist.service.main.enable 0
setprop persist.service.power.enable 0
setprop persist.service.radio.enable 0
setprop persist.service.system.enable 0

# Stop google service and restart it on boot. This remove high cpu load and ram leak!
if [ "$($BB pidof com.google.android.gms | wc -l)" -eq "1" ]; then
	$BB kill "$($BB pidof com.google.android.gms)";
fi;
if [ "$($BB pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
	$BB kill "$($BB pidof com.google.android.gms.unstable)";
fi;
if [ "$($BB pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
	$BB kill "$($BB pidof com.google.android.gms.persistent)";
fi;
if [ "$($BB pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
	$BB kill "$($BB pidof com.google.android.gms.wearable)";
fi;

# Google Services battery drain fixer by Alcolawl@xda
# http://forum.xda-developers.com/google-nexus-5/general/script-google-play-services-battery-t3059585/post59563859
pm enable com.google.android.gms/.update.SystemUpdateActivity
pm enable com.google.android.gms/.update.SystemUpdateService
pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
pm enable com.google.android.gsf/.update.SystemUpdateActivity
pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
pm enable com.google.android.gsf/.update.SystemUpdateService
pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver

# Turn off debugging for certain modules
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
echo 0 > /sys/module/alarm_dev/parameters/debug_mask
echo 0 > /sys/module/ipc_router_core/parameters/debug_mask
echo 0 > /sys/module/xt_qtaguid/parameters/debug_mask
echo 0 > /sys/module/smd/parameters/debug_mask
echo 0 > /sys/module/smem/parameters/debug_mask
echo 0 > /sys/module/msm_serial_hs_lge/parameters/debug_mask
echo 0 > /sys/module/smp2p/parameters/debug_mask
echo 0 > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo 0 > /sys/module/mpm_of/parameters/debug_mask
echo 0 > /sys/module/msm_pm/parameters/debug_mask

# Script finish here
rm /data/local/tmp/Imperium_Kernel
touch /data/local/tmp/Imperium_Kernel
echo "Imperium Kernel script correctly applied" > /data/local/tmp/Imperium_Kernel;

$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,rw /data

