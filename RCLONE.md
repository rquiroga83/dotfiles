# Rclone - Google Drive

Montaje de Google Drive usando rclone como filesystem FUSE.

## Remoto configurado

| Campo | Valor |
|---|---|
| Nombre | `gdrive` |
| Tipo | Google Drive |
| Scope | `drive` (acceso completo) |
| Mount point | `~/gdrive` |

## Uso de almacenamiento

| Campo | Valor |
|---|---|
| Total | 5 TiB |
| Usado | ~106 GiB |
| Libre | ~4.8 TiB |

## Parámetros de montaje

```bash
rclone mount gdrive: ~/gdrive \
    --vfs-cache-mode full \
    --vfs-cache-max-age 1h \
    --vfs-cache-max-size 10G \
    --vfs-read-ahead 128k \
    --daemon
```

| Parámetro | Descripción |
|---|---|
| `--vfs-cache-mode full` | Cache completo para lectura y escritura |
| `--vfs-cache-max-age 1h` | Archivos en cache se eliminan después de 1h sin uso |
| `--vfs-cache-max-size 10G` | Tamaño máximo del cache en disco |
| `--vfs-read-ahead 128k` | Lectura anticipada para mejor rendimiento |
| `--daemon` | Ejecutar en segundo plano |

## Script de montaje

`hypr/scripts/mount-gdrive.sh` - Monta con notificaciones y verifica si ya está montado.

## Atajos en Yazi

| Atajo | Acción |
|---|---|
| `g d` | Navegar a `~/gdrive` |
| `m g` | Montar Google Drive |
| `m u` | Desmontar (`fusermount3 -u`) |

## Comandos útiles

```bash
# Verificar si está montado
mountpoint -q ~/gdrive && echo "Montado" || echo "No montado"

# Desmontar
fusermount3 -u ~/gdrive

# Ver espacio
rclone about gdrive:

# Sincronizar carpeta local a Drive
rclone sync /ruta/local gdrive:/carpeta-remota

# Listar archivos
rclone ls gdrive: --max-depth 1
```

## Configuración

El archivo de configuración está en `~/.config/rclone/rclone.conf`.

> **Nota**: Contiene credenciales OAuth. No compartir ni versionar.
