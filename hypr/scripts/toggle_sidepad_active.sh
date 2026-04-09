#!/bin/bash
# toggle_sidepad_active.sh
# Primera vez: toma la ventana activa y la convierte en sidepad lateral izquierdo
# Siguientes veces: alterna visible/oculto
# Super+Shift+S = activar/toggle  |  Super+Ctrl+Shift+S = liberar ventana

STATE_FILE="/tmp/sidepad-active-state"
VISIBLE_GAP=20
TOP_GAP=60

# ── Liberar: devuelve la ventana a floating normal ────────────
if [ "$1" = "--release" ]; then
    if [ -f "$STATE_FILE" ]; then
        ADDR=$(grep "^addr="  "$STATE_FILE" | cut -d= -f2)
        hyprctl dispatch pin "address:${ADDR}"
        hyprctl dispatch centerwindow "address:${ADDR}"
        rm -f "$STATE_FILE"
    fi
    exit 0
fi

# ── Si ya hay un sidepad activo: alternar visible/oculto ──────
if [ -f "$STATE_FILE" ]; then
    ADDR=$(grep  "^addr="  "$STATE_FILE" | cut -d= -f2)
    STATE=$(grep "^state=" "$STATE_FILE" | cut -d= -f2)
    WIN_W=$(grep "^width=" "$STATE_FILE" | cut -d= -f2)

    # Verificar que la ventana sigue existiendo
    if ! hyprctl clients -j | python3 -c "
import json, sys
clients = json.load(sys.stdin)
sys.exit(0 if any(c.get('address') == '${ADDR}' for c in clients) else 1)
"; then
        rm -f "$STATE_FILE"
        exit 0
    fi

    HIDDEN_X=$(( -(WIN_W - 8) ))

    # Re-aplicar float y pin si los perdió (ej: tras hyprctl reload)
    IS_FLOAT=$(hyprctl clients -j | python3 -c "
import json, sys
clients = json.load(sys.stdin)
w = next((c for c in clients if c.get('address') == '${ADDR}'), None)
print(w.get('floating', False) if w else False)
")
    if [ "$IS_FLOAT" != "True" ]; then
        hyprctl dispatch setfloating "address:${ADDR}"
        for i in $(seq 1 20); do
            sleep 0.05
            IS_FLOAT=$(hyprctl clients -j | python3 -c "
import json, sys
clients = json.load(sys.stdin)
w = next((c for c in clients if c.get('address') == '${ADDR}'), None)
print(w.get('floating', False) if w else False)
")
            [ "$IS_FLOAT" = "True" ] && break
        done
        hyprctl dispatch pin "address:${ADDR}"
        sleep 0.05
    fi

    if [ "$STATE" = "visible" ]; then
        hyprctl dispatch movewindowpixel "exact ${HIDDEN_X} ${TOP_GAP},address:${ADDR}"
        sed -i 's/state=visible/state=hidden/' "$STATE_FILE"
    else
        hyprctl dispatch movewindowpixel "exact ${VISIBLE_GAP} ${TOP_GAP},address:${ADDR}"
        sed -i 's/state=hidden/state=visible/' "$STATE_FILE"
    fi
    exit 0
fi

# ── Sin sidepad activo: tomar la ventana enfocada ─────────────
ACTIVE_JSON=$(hyprctl activewindow -j)
ADDR=$(echo "$ACTIVE_JSON" | python3 -c "
import json, sys
w = json.load(sys.stdin)
print(w.get('address', ''))
")
CLASS=$(echo "$ACTIVE_JSON" | python3 -c "
import json, sys
w = json.load(sys.stdin)
print(w.get('class', ''))
")
WIN_W=$(echo "$ACTIVE_JSON" | python3 -c "
import json, sys
w = json.load(sys.stdin)
print(w.get('size', [650, 0])[0])
")
WIN_H=$(echo "$ACTIVE_JSON" | python3 -c "
import json, sys
w = json.load(sys.stdin)
print(w.get('size', [0, 500])[1])
")

if [ -z "$ADDR" ] || [ "$ADDR" = "null" ]; then
    exit 0
fi

# Hacer flotante y esperar a que lo sea antes de continuar
hyprctl dispatch setfloating "address:${ADDR}"
for i in $(seq 1 20); do
    sleep 0.05
    IS_FLOAT=$(hyprctl clients -j | python3 -c "
import json, sys
clients = json.load(sys.stdin)
w = next((c for c in clients if c.get('address') == '${ADDR}'), None)
print(w.get('floating', False) if w else False)
")
    [ "$IS_FLOAT" = "True" ] && break
done

# Restaurar tamaño original (Hyprland lo cambia al hacer setfloating)
hyprctl dispatch resizewindowpixel "exact ${WIN_W} ${WIN_H},address:${ADDR}"
sleep 0.05
hyprctl dispatch pin "address:${ADDR}"
sleep 0.05
hyprctl dispatch movewindowpixel "exact ${VISIBLE_GAP} ${TOP_GAP},address:${ADDR}"

# Guardar estado con el ancho real de la ventana
{
    echo "addr=${ADDR}"
    echo "class=${CLASS}"
    echo "width=${WIN_W}"
    echo "height=${WIN_H}"
    echo "state=visible"
} > "$STATE_FILE"
