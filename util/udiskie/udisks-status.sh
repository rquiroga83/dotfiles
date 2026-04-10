#!/bin/bash
# Muestra unidades removibles montadas y permite expulsarlas con rofi

MOUNTS=$(udiskie-umount --list 2>/dev/null | grep -E "^\s+/run/media" | awk '{print $1}')

COUNT=$(echo "$MOUNTS" | grep -c "/" 2>/dev/null || echo 0)

if [ "$COUNT" -gt 0 ]; then
  echo "{\"text\":\" $COUNT\", \"tooltip\":\"$COUNT unidad(es) montada(s)\", \"class\":\"active\"}"
else
  echo "{\"text\":\"\", \"tooltip\":\"Sin unidades montadas\", \"class\":\"empty\"}"
fi
