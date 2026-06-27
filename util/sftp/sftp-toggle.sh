#!/bin/bash
# Toggle SFTP server (sshd) on/off
# Usage: sftp-toggle.sh

get_ip() {
    ip -4 addr show wlp3s0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1
}

if systemctl is-active --quiet sshd; then
    sudo systemctl stop sshd
    notify-send -i network-server-disconnected "SFTP" "Servidor desactivado" -u normal
else
    sudo systemctl start sshd
    IP=$(get_ip)
    notify-send -i network-server "SFTP" "Servidor activado\n\nsftp://$IP\nUsuario: $(whoami)" -u normal -t 8000
fi
