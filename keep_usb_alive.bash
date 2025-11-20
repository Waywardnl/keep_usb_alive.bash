#!/bin/bash
# usb-keepalive.sh
# Prevent USB devices from sleeping, only when AC power is connected
# Logs actions to /var/log/usb-keepalive.log

AC_PATH="/sys/class/power_supply/ACAD/online"
LOGFILE="/var/log/usb-keepalive.log"


    if [ -f "$AC_PATH" ] && [ "$(cat $AC_PATH)" -eq 1 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') AC power detected, keeping devices awake" >> "$LOGFILE"
        for dev in /sys/bus/usb/devices/*; do
            if [ -f "$dev/power/control" ]; then
                echo on | sudo tee "$dev/power/control" > /dev/null
                echo "$(date '+%Y-%m-%d %H:%M:%S') Set $(basename $dev) power/control=on" >> "$LOGFILE"
            fi
        done
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') On battery, skipping keepalive" >> "$LOGFILE"
    fi

