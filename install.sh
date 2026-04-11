#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  Dotfiles Installer — Cyberpunk Red
#  Arch Linux · Hyprland · Waybar · Kitty · Rofi · SwayNC
# ─────────────────────────────────────────────────────────────

set -e

R='\033[38;2;255;0;60m'
Y='\033[38;2;252;238;10m'
C='\033[38;2;0;207;255m'
G='\033[38;2;255;204;204m'
B='\033[1m'
RST='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo -e "  ${C}::${RST} $*"; }
success() { echo -e "  ${Y}✓${RST}  $*"; }
warn()    { echo -e "  ${R}!${RST}  $*"; }
section() { echo -e "\n${R}${B}── $* ─────────────────────────────────────────${RST}"; }

# ── Comprobaciones previas ────────────────────────────────────
section "Verificando entorno"

if [ "$EUID" -eq 0 ]; then
    warn "No ejecutes este script como root."
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    warn "Este script es solo para Arch Linux."
    exit 1
fi

success "Arch Linux detectado"

# ── Instalar yay si no está ───────────────────────────────────
section "AUR helper (yay)"

if ! command -v yay &>/dev/null; then
    info "Instalando yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    success "yay instalado"
else
    success "yay ya está instalado"
fi

# ── Paquetes ──────────────────────────────────────────────────
section "Instalando paquetes"

PKGS_PACMAN=(
    # WM y compositor
    hyprland
    hyprpaper
    hypridle
    hyprlock
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # Barra
    waybar

    # Terminal
    kitty

    # Lanzador
    rofi-wayland

    # Notificaciones
    swaync

    # Fuentes
    ttf-jetbrains-mono-nerd

    # Audio
    pipewire
    pipewire-pulse
    wireplumber
    pavucontrol

    # Bluetooth
    bluez
    bluez-utils

    # Red
    networkmanager
    network-manager-applet

    # Brillo
    brightnessctl

    # Captura de pantalla
    grim
    slurp
    wl-clipboard

    # Media
    playerctl

    # Monitor de recursos
    btop

    # Editor
    neovim

    # Gestores de archivos
    yazi
    ranger
    udiskie

    # ls moderno
    lsd

    # Utilidades
    python
    libnotify
    polkit-gnome
    qt5-wayland
    qt6-wayland
)

PKGS_AUR=(
    # Wallpaper extra / utilidades Hyprland
    hyprshade
    wlogout
)

info "Instalando paquetes oficiales..."
sudo pacman -S --needed --noconfirm "${PKGS_PACMAN[@]}"
success "Paquetes oficiales instalados"

info "Instalando paquetes AUR..."
yay -S --needed --noconfirm "${PKGS_AUR[@]}" || warn "Algunos paquetes AUR fallaron (no críticos)"

# ── Servicios ─────────────────────────────────────────────────
section "Habilitando servicios"

sudo systemctl enable --now bluetooth.service
success "Bluetooth habilitado"

sudo systemctl enable --now NetworkManager.service
success "NetworkManager habilitado"

# ── Symlinks ──────────────────────────────────────────────────
section "Creando symlinks en ~/.config"

mkdir -p "$HOME/.config"

link_config() {
    local src="$DOTFILES_DIR/$1"
    local dst="$HOME/.config/$1"
    if [ ! -e "$src" ]; then
        warn "No existe $src, omitiendo"
        return
    fi
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        info "Backup: $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -s "$src" "$dst"
    success "~/.config/$1 → $src"
}

link_config hypr
link_config waybar
link_config kitty
link_config rofi
link_config nvim
link_config yazi
link_config udiskie
link_config swaync
link_config lsd
link_config ranger

# ── Scripts ejecutables ───────────────────────────────────────
section "Permisos de scripts"

chmod +x "$DOTFILES_DIR/hypr/scripts/"*.sh 2>/dev/null && \
    success "hypr/scripts/ → ejecutables"

chmod +x "$DOTFILES_DIR/util/bluetooth/btmenu" \
         "$DOTFILES_DIR/util/wifi/wifimenu" \
         "$DOTFILES_DIR/util/udiskie/"*.sh 2>/dev/null && \
    success "util/ → ejecutables"

# ── Directorio de imágenes ────────────────────────────────────
section "Directorio de wallpapers"

if [ ! -d "$HOME/images" ]; then
    mkdir -p "$HOME/images"
    info "Creado ~/images/ — copia tu wallpaper.png aquí"
    warn "hyprpaper.conf apunta a ~/images/wallpaper.png"
else
    success "~/images/ ya existe"
fi

# ── Resumen ───────────────────────────────────────────────────
echo ""
echo -e "${R}${B}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   Instalación completada                 ║"
echo "  ╠══════════════════════════════════════════╣"
echo "  ║                                          ║"
echo -e "  ║  ${Y}Próximos pasos:${R}                          ║"
echo -e "  ║  ${G}1.${RST} Copia wallpaper.png a ~/images/    ${R}  ║"
echo -e "  ║  ${G}2.${RST} Reinicia o ejecuta: Hyprland       ${R}  ║"
echo -e "  ║  ${G}3.${RST} Super+R para abrir Rofi            ${R}  ║"
echo -e "  ║  ${G}4.${RST} Super+S para el sidepad            ${R}  ║"
echo -e "${R}${B}"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${RST}"
