#!/bin/bash
# Toggle OpenVPN on/off
# Unidad: openvpn-client@home.service

UNIT="openvpn-client@home.service"

if systemctl is-active --quiet "$UNIT"; then
    sudo systemctl stop "$UNIT" && \
        notify-send -i network-vpn-disabled "VPN" "Desconectado" -u normal || \
        notify-send -i dialog-error "VPN" "Error al desconectar" -u critical
else
    sudo systemctl start "$UNIT" && \
        notify-send -i network-vpn "VPN" "Conectado" -u normal || \
        notify-send -i dialog-error "VPN" "Error al conectar\nRevisa: journalctl -u $UNIT" -u critical
fi
