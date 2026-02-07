#!/system/bin/sh

MODDIR=${0%/*}

read -r zarad < /sys/class/power_supply/battery/capacity
read -r cikli < /sys/class/power_supply/battery/cycle_count
read -r heal < /sys/class/power_supply/battery/health
read -r zayavl < /sys/class/power_supply/battery/charge_full_design
read -r ful < /sys/class/power_supply/battery/charge_full
read -r se4as < /sys/class/power_supply/battery/charge_counter

# Conversões em mAh
zayavl=$((zayavl / 1000))
ful=$((ful / 1000))
se4as=$((se4as / 1000))

# Texto para descrição
text="👌 Serviço injetado | 👌 Build.prop Tweaks | 👌 ShellScript executado | 🔋 Otimizado para $(getprop ro.product.board) com Android $(getprop ro.build.version.release) | 👌 $(getprop ro.hardware) otimizado para uso diário!"

# Remove linha antiga e insere nova descrição
sed -i '/^description=/d' "$MODDIR/module.prop"
echo "description=$text" >> "$MODDIR/module.prop"

# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

MODDIR="${0%/*}"
. "${MODDIR}/common/functions.sh"

# Wait for the key press for 3 seconds
press_check 3 && disable_modules
