#!/bin/bash
# toggle_sidepad.sh — sidepad lateral izquierdo estilo ML4W
# Ventana siempre abierta: oculta = fuera de pantalla, visible = dentro

CLASS="sidepad-terminal"
STATE_FILE="/tmp/sidepad-visible"
WIDTH=550
VISIBLE_GAP=20    # px desde el borde izquierdo al mostrarse
TOP_GAP=60        # px desde arriba (deja espacio para waybar)
BOTTOM_GAP=50

# ── Kill mode ────────────────────────────────────────────────
if [ "$1" = "--kill" ]; then
    pkill -f "kitty --class $CLASS"
    rm -f "$STATE_FILE"
    exit 0
fi

# ── Geometría del monitor activo ─────────────────────────────
read -r MON_H < <(hyprctl monitors -j | python3 -c "
import json, sys
monitors = json.load(sys.stdin)
focused = next((m for m in monitors if m.get('focused')), monitors[0])
print(focused['height'])
")
WIN_H=$(( MON_H - TOP_GAP - BOTTOM_GAP ))
HIDDEN_X=$(( -(WIDTH - 8) ))   # casi fuera de pantalla, 8px de "pestaña" visible

client_exists() {
    hyprctl clients -j | grep -q "\"$CLASS\""
}

show_pad() {
    hyprctl dispatch resizewindowpixel "exact ${WIDTH} ${WIN_H},class:${CLASS}"
    hyprctl dispatch movewindowpixel  "exact ${VISIBLE_GAP} ${TOP_GAP},class:${CLASS}"
    echo "1" > "$STATE_FILE"
}

hide_pad() {
    hyprctl dispatch movewindowpixel "exact ${HIDDEN_X} ${TOP_GAP},class:${CLASS}"
    rm -f "$STATE_FILE"
}

# ── Lógica principal ──────────────────────────────────────────
if ! client_exists; then
    # Primera vez: lanzar y posicionar
    kitty --class "$CLASS" &
    for i in $(seq 1 25); do
        sleep 0.1
        if client_exists; then
            sleep 0.15
            show_pad
            exit 0
        fi
    done
else
    # Alternar visibilidad
    if [ -f "$STATE_FILE" ]; then
        hide_pad
    else
        show_pad
    fi
fi
