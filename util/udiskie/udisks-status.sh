#!/bin/bash
# Detecta unidades montadas bajo /run/media (siempre son removibles)

DRIVES=$(lsblk -o NAME,MOUNTPOINT,LABEL -rn 2>/dev/null | \
  awk '$2 ~ /\/run\/media/ {
    label = ($3 != "") ? $3 : $1
    gsub(/\\x20/, " ", label)
    print label
  }')

COUNT=$(echo "$DRIVES" | grep -vc "^$")
[ -z "$DRIVES" ] && COUNT=0

if [ "$COUNT" -gt 0 ]; then
  NAMES=$(echo "$DRIVES" | paste -sd ", ")
  echo "{\"text\":\"󰆼 $COUNT\", \"tooltip\":\"Montada(s):\\n$NAMES\", \"class\":\"active\"}"
else
  echo "{\"text\":\"󰆼\", \"tooltip\":\"Sin unidades montadas\", \"class\":\"empty\"}"
fi
