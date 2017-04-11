#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

# macro to write pids to system-background cpuset
function writepid_sbg() {
    if [ ! -z "$1" ]
        then
            echo -n $1 > /dev/cpuset/system-background/tasks
    fi
}

function writepid_top_app() {
    if [ ! -z "$1" ]
        then
            echo -n $1 > /dev/cpuset/top-app/tasks
    fi
}
################################################################################

sleep 10

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 307200
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 307200
#write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2188800
#write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 2342400

write /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction 1
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 0
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 100
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq 0
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads "35 460800:40 691200:45 844800:50 1056000:60 1286400:70 1440000:85 1516800:95"
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 30000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 60000
write /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif 0

write /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq 825600
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay "19000 1400000:39000 1700000:19000 2100000:79000"
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads "70 1593600:80 1824000:90 2150400:95"
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/enable_prediction 1
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate 30000
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/ignore_hispeed_on_notif 0
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time 19000
write /sys/devices/system/cpu/cpu2/cpufreq/interactive/max_freq_hysteresis 39000

write /sys/module/cpu_boost/parameters/input_boost_freq "0:1209600 2:825600"
write /sys/module/cpu_boost/parameters/input_boost_duration 40

# Setting b.L scheduler parameters
write /proc/sys/kernel/sched_downmigrate 90
write /proc/sys/kernel/sched_upmigrate 95
write /proc/sys/kernel/sched_freq_inc_notify 400000
write /proc/sys/kernel/sched_freq_dec_notify 400000
write /proc/sys/kernel/sched_spill_nr_run 3
write /proc/sys/kernel/sched_init_task_load 100

sleep 20

FINGERPRINTD=`pidof fingerprintd`
QSEECOMD=`pidof qseecomd`
THERMAL-ENGINE=`pidof thermal-engine`
TIME_DAEMON=`pidof time_daemon`
IMSQMIDAEMON=`pidof imsqmidaemon`
IMSDATADAEMON=`pidof imsdatadaemon`
DASHD=`pidof dashd`
CND=`pidof cnd`
DPMD=`pidof dpmd`
RMT_STORAGE=`pidof rmt_storage`
TFTP_SERVER=`pidof tftp_server`
NETMGRD=`pidof netmgrd`
IPACM=`pidof ipacm`
QTI=`pidof qti`
LOC_LAUNCHER=`pidof loc_launcher`
QSEEPROXYDAEMON=`pidof qseeproxydaemon`
IFAADAEMON=`pidof ifaadaemon`
LOGCAT=`pidof logcat`

writepid_top_app $FINGERPRINTD
writepid_sbg $QSEECOMD
writepid_sbg $THERMAL-ENGINE
writepid_sbg $TIME_DAEMON
writepid_sbg $IMSQMIDAEMON
writepid_sbg $IMSDATADAEMON
writepid_sbg $DASHD
writepid_sbg $CND
writepid_sbg $DPMD
writepid_sbg $RMT_STORAGE
writepid_sbg $TFTP_SERVER
writepid_sbg $NETMGRD
writepid_sbg $IPACM
writepid_sbg $QTI
writepid_sbg $LOC_LAUNCHER
writepid_sbg $QSEEPROXYDAEMON
writepid_sbg $IFAADAEMON
writepid_sbg $LOGCAT