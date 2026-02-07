#!/system/bin/sh
MODDIR="${0%/*}"

sleep 60

echo '100' > /dev/memcg/memory.swappiness
echo '40' > /dev/memcg/system/memory.swappiness
echo '50' > /dev/memcg/apps/memory.swappiness

# Clear memg system
for clear in $(cat /dev/memcg/system/cgroup.procs); do
    echo $clear > /dev/memcg/cgroup.procs
done

# Executa o processo PID
process_name="system_server"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

MODDIR="${0%/*}"
. "${MODDIR}/common/functions.sh"

# Wait for the key press until the system boot is comleted
# check every second 
until [[ "$(resetprop sys.boot_completed)" == 1 ]]; do
  press_check 1 && disable_modules
done

process_name="surfaceflinger"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

# Reduz a carga do Composer do Android
process_name="android.hardware.graphics.composer@2.0-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="android.hardware.graphics.composer@2.1-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs


process_name="android.hardware.graphics.composer@2.2-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs


process_name="android.hardware.graphics.composer@2.3-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="android.hardware.graphics.composer@2.4-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="vendor.qti.hardware.display.composer-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

# altera zram para 3gb
chmod 644 > /sys/block/zram0/disksize
echo 3221225472 > /sys/block/zram0/disksize

#!/system/bin/sh
while [ -z "$(getprop sys.boot_completed)" ]; do
sleep 12
done
sh /data/adb/modules/BastionBattery/DeepBatterySaver/deep_props.sh

#############
# ESTADO DE SERVIÇO DO MÓDULO 
#######

#############

# REDUZ O SWAPINESS
sleep 60

echo '100' > /dev/memcg/memory.swappiness
echo '40' > /dev/memcg/system/memory.swappiness
echo '50' > /dev/memcg/apps/memory.swappiness

#######
# REDUZ PROCESSOS DESNECESSÁRIOS DURANTE O BOOT

for clear in $(cat /dev/memcg/system/cgroup.procs); do
    echo $clear > /dev/memcg/cgroup.procs
done

# Injeta processos PID
process_name="system_server"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="surfaceflinger"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

# 3b de zram
MODDIR=${0%/*}

chmod 644 > /sys/block/zram0/disksize
echo 3221225472 > /sys/block/zram0/disksize
exit 0

# Reduz a carga do Composer do Android
process_name="android.hardware.graphics.composer@2.0-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="android.hardware.graphics.composer@2.1-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="android.hardware.graphics.composer@2.2-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="android.hardware.graphics.composer@2.3-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="android.hardware.graphics.composer@2.4-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

process_name="vendor.qti.hardware.display.composer-service"
pid_proc=$(pidof "$process_name")
echo $pid_proc > /dev/memcg/system/cgroup.procs

exit 0