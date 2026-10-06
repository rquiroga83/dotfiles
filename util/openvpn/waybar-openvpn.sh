#!/bin/bash
# Indicador de estado OpenVPN para Waybar
# Unidad: openvpn-client@home.service

UNIT="openvpn-client@home.service"

if systemctl is-active --quiet "$UNIT"; then
    printf '{"text": "󰌾", "class": "connected", "tooltip": "VPN: Conectado\\nClick para desconectar"}'
elif systemctl is-failed --quiet "$UNIT"; then
    printf '{"text": "󰌾", "class": "failed", "tooltip": "VPN: Error al conectar\\nClick para reintentar"}'
else
    printf '{"text": "󰌿", "class": "disconnected", "tooltip": "VPN: Desconectado\\nClick para conectar"}'
fi
