#!/bin/bash
# Montar Google Drive con rclone (bajo demanda + auto-limpieza)

MOUNTPoint="$HOME/mnt/gdrive"
REMOTE="gdrive:"

mkdir -p "$MOUNTPoint"

if mountpoint -q "$MOUNTPoint"; then
    notify-send "Google Drive" "Ya está montado en $MOUNTPoint"
else
    rclone mount "$REMOTE" "$MOUNTPoint" \
        --vfs-cache-mode full \
        --vfs-cache-max-age 1h \
        --vfs-cache-max-size 10G \
        --vfs-read-ahead 128k \
        --daemon

    if mountpoint -q "$MOUNTPoint"; then
        notify-send "Google Drive" "Montado en $MOUNTPoint"
    else
        notify-send -u critical "Google Drive" "Error al montar"
    fi
fi