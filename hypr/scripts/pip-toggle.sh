#!/bin/bash
# Toggle Picture-in-Picture mode on the active window.
# Floats, pins, resizes to 480x270, and snaps to bottom-right corner.
# A second press un-pins and un-floats the window.

PIP_W=384
PIP_H=216
MARGIN=20
WAYBAR_H=45

ACTIVE=$(hyprctl activewindow -j)
IS_PINNED=$(echo "$ACTIVE" | jq -r '.pinned')
ADDRESS=$(echo "$ACTIVE" | jq -r '.address')

if [ "$IS_PINNED" = "true" ]; then
    hyprctl dispatch pin
    hyprctl dispatch togglefloating
    hyprctl dispatch tagwindow PIP   # remove PIP tag
    # Restaurar opacidades a valores globales (active=1.0, inactive=0.90)
    hyprctl setprop address:$ADDRESS activeopacity 1.0
    hyprctl setprop address:$ADDRESS inactiveopacity 0.90
    hyprctl setprop address:$ADDRESS alphainactive 1.0
else
    MON=$(hyprctl monitors -j | jq -r '.[0] | "\(.width) \(.height) \(.scale)"')
    MON_W=$(echo "$MON" | cut -d' ' -f1)
    MON_H=$(echo "$MON" | cut -d' ' -f2)
    SCALE=$(echo "$MON" | cut -d' ' -f3)

    LOGICAL_W=$(echo "$MON_W $SCALE" | awk '{printf "%d", $1 / $2}')
    LOGICAL_H=$(echo "$MON_H $SCALE" | awk '{printf "%d", $1 / $2}')

    X=$(( LOGICAL_W - PIP_W - MARGIN ))
    Y=$(( LOGICAL_H - PIP_H - WAYBAR_H - MARGIN ))

    hyprctl dispatch togglefloating
    hyprctl dispatch pin
    hyprctl dispatch tagwindow PIP   # tag ventana PIP
    hyprctl dispatch resizeactive exact $PIP_W $PIP_H
    hyprctl dispatch moveactive exact $X $Y
    # Forzar opacidad 1.0 aunque la ventana pierda el foco
    hyprctl setprop address:$ADDRESS activeopacity 1.0
    hyprctl setprop address:$ADDRESS inactiveopacity 1.0
    hyprctl setprop address:$ADDRESS alpha 1.0
    hyprctl setprop address:$ADDRESS alphainactive 1.0
fi
