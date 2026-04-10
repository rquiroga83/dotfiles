#!/bin/bash
# Lista unidades montadas y permite expulsarlas con rofi

MOUNTS=$(lsblk -o NAME,MOUNTPOINT,LABEL,SIZE,TRAN -J 2>/dev/null | \
  python3 -c "
import json, sys
data = json.load(sys.stdin)
results = []
def walk(devices):
    for d in devices:
        mp = d.get('mountpoint', '')
        if mp and '/run/media' in mp:
            label = d.get('label') or d.get('name', '')
            size  = d.get('size', '')
            results.append(f\"{mp}  [{label}  {size}]\")
        for child in d.get('children', []):
            walk([child])
walk(data.get('blockdevices', []))
for r in results:
    print(r)
")

if [ -z "$MOUNTS" ]; then
  notify-send "udiskie" "No hay unidades montadas" --icon=drive-removable-media
  exit 0
fi

SELECTED=$(echo "$MOUNTS" | rofi -dmenu -i -p "󰆼 Expulsar unidad" -theme-str '
window { width: 500px; }
')

[ -z "$SELECTED" ] && exit 0

MOUNTPOINT=$(echo "$SELECTED" | awk '{print $1}')

udiskie-umount "$MOUNTPOINT" && \
  notify-send "udiskie" "󰆼 Expulsada: $MOUNTPOINT" --icon=drive-removable-media || \
  notify-send "udiskie" "Error al expulsar $MOUNTPOINT" --icon=dialog-error
