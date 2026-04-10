#!/bin/bash
# Lista unidades bajo /run/media y permite expulsarlas con rofi

DRIVES=$(lsblk -o NAME,MOUNTPOINT,LABEL,SIZE -rn 2>/dev/null | \
  awk '$2 ~ /\/run\/media/ {
    gsub(/\\x20/, " ", $3)
    printf "/dev/%s\t%s\t%s\t%s\n", $1, $2, $3, $4
  }')

if [ -z "$DRIVES" ]; then
  notify-send "udiskie" "No hay unidades montadas" --icon=drive-removable-media
  exit 0
fi

MENU=$(echo "$DRIVES" | awk -F'\t' '{
  label = ($3 != "") ? $3 : $1
  printf "%s  %s  (%s)\n", label, $4, $2
}')

SELECTED_LINE=$(echo "$MENU" | rofi -dmenu -i -p "󰆼 Expulsar unidad" -format d)

[ -z "$SELECTED_LINE" ] && exit 0

DEVICE=$(echo "$DRIVES" | sed -n "${SELECTED_LINE}p" | awk -F'\t' '{print $1}')
LABEL=$(echo "$DRIVES"  | sed -n "${SELECTED_LINE}p" | awk -F'\t' '{label = ($3 != "") ? $3 : $1; print label}')

udiskie-umount --detach "$DEVICE" && \
  notify-send "udiskie" "󰆼 Expulsada: $LABEL" --icon=drive-removable-media || \
  notify-send "udiskie" "Error al expulsar $LABEL" --icon=dialog-error
