#!/bin/bash
# Indicador de Caps Lock para Waybar
# Lee el estado del LED desde /sys/class/leds/

CAPS=$(cat "/sys/class/leds/input3::capslock/brightness" 2>/dev/null || echo "0")

if [ "$CAPS" = "1" ]; then
    printf '{"text": "󰪛", "class": "active", "tooltip": "Caps Lock: ACTIVADO"}'
else
    printf '{"text": "", "class": "inactive", "tooltip": "Caps Lock: desactivado"}'
fi