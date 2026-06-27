# Paquetes necesarios

## Oficiales (pacman)

### WM y compositor
- `hyprland`
- `hyprpaper`
- `hypridle`
- `hyprlock`
- `xdg-desktop-portal-hyprland`
- `xdg-desktop-portal-gtk`

### Barra
- `waybar`

### Terminal
- `kitty`

### Lanzador
- `rofi-wayland`

### Notificaciones
- `swaync`

### Fuentes
- `ttf-jetbrains-mono-nerd`

### Audio
- `pipewire`
- `pipewire-pulse`
- `wireplumber`
- `pavucontrol`

### Bluetooth
- `bluez`
- `bluez-utils`

### Red
- `networkmanager`
- `network-manager-applet`

### Brillo
- `brightnessctl`

### Captura de pantalla
- `grim`
- `slurp`
- `wl-clipboard`

### Media
- `playerctl`

### Reproductor de video / audio
- `mpv`

### Visor de imágenes
- `imv`
- `feh`

### Visor de PDF
- `zathura`

### Archivos comprimidos
- `unar`

### Monitor de recursos
- `btop`

### Editor
- `neovim`

### Gestores de archivos
- `yazi`
- `ranger`
- `udiskie`

### ls moderno
- `lsd`

### Utilidades
- `python`
- `libnotify`
- `polkit-gnome`
- `qt5-wayland`
- `qt6-wayland`

---

## AUR (yay)

- `hyprshade`
- `wlogout`
- `swayosd-git`

---

## Instalación rápida

```bash
# Paquetes oficiales
sudo pacman -S --needed hyprland hyprpaper hypridle hyprlock xdg-desktop-portal-hyprland xdg-desktop-portal-gtk waybar kitty rofi-wayland swaync ttf-jetbrains-mono-nerd pipewire pipewire-pulse wireplumber pavucontrol bluez bluez-utils networkmanager network-manager-applet brightnessctl grim slurp wl-clipboard playerctl mpv imv feh zathura unar btop neovim yazi ranger udiskie lsd python libnotify polkit-gnome qt5-wayland qt6-wayland

# Paquetes AUR
yay -S --needed hyprshade wlogout swayosd-git
```
