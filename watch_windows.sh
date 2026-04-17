#!/bin/bash
# Watches for new X windows and logs their type/class immediately on creation.
# Run this in a terminal, trigger UE popups, then check /tmp/xprop_log.txt

LOGFILE="/tmp/xprop_log.txt"
> "$LOGFILE"
echo "Watching for new windows... output -> $LOGFILE"

xev -root -event substructure 2>/dev/null | \
while read -r line; do
    if [[ "$line" == *"CreateNotify"* ]]; then
        read -r line2
        winid=$(echo "$line2" | grep -o 'window 0x[0-9a-f]*' | awk '{print $2}')
        if [[ -n "$winid" ]]; then
            echo "=== New window: $winid ===" | tee -a "$LOGFILE"
            xprop -id "$winid" WM_CLASS _NET_WM_WINDOW_TYPE WM_NAME 2>/dev/null \
                | tee -a "$LOGFILE"
            echo "" >> "$LOGFILE"
        fi
    fi
done
