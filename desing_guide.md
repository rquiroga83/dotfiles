# Cyberpunk Red — Guía de Diseño

Guía de referencia para replicar el estilo visual de la waybar en otros componentes del sistema (rofi, dunst, kitty, hyprland, etc.).

---

## Paleta de colores

| Rol                  | Token            | Hex       | Uso                                      |
|----------------------|------------------|-----------|------------------------------------------|
| Fondo profundo       | `--bg-deep`      | `#0a0000` | Fondo de barra, ventanas, tooltips       |
| Fondo de módulo      | `--bg-module`    | `#1a0000` | Fondo de paneles y tarjetas              |
| Fondo elevado        | `--bg-raised`    | `#2b0000` | Módulos con mayor contraste              |
| Acento principal     | `--red`          | `#ff003c` | Bordes, reloj, memoria, hover            |
| Acento rojo oscuro   | `--red-dark`     | `#660000` | Estados críticos, sombras                |
| Amarillo neón        | `--yellow`       | `#fcee0a` | Launcher, red, batería, disco, brillo    |
| Amarillo apagado     | `--yellow-dim`   | `#7a6e00` | Estado inactivo del amarillo (animación) |
| Azul neón            | `--cyan`         | `#00cfff` | Bluetooth, audio, temperatura, CPU, cava |
| Texto suave          | `--text-soft`    | `#ffcccc` | Texto en tooltips y menús                |
| Negro puro           | `--black`        | `#0a0000` | Texto sobre fondos de acento             |

### Regla de asignación de color por zona

```
Acción / crítico  →  Rojo    #ff003c
Datos / estado    →  Amarillo #fcee0a
Sistema / técnico →  Cyan    #00cfff
Peligro / alerta  →  Rojo    #ff003c  (fondo invertido)
```

---

## Tipografía

| Propiedad   | Valor                        |
|-------------|------------------------------|
| Fuente base | `JetBrainsMono Nerd Font`    |
| Tamaño base | `14px`                       |
| Tamaño menú | `13px`                       |
| Tamaño icono launcher | `18px`             |
| Peso normal | `normal`                     |
| Peso destacado | `bold`                    |

---

## Esquinas cortadas (efecto cyberpunk)

Las esquinas NO son redondeadas. Se usa un corte diagonal de **8px** en la esquina superior-izquierda de cada módulo mediante gradiente CSS.

### GTK CSS (waybar, dunst)
```css
background: linear-gradient(135deg, transparent 8px, #1a0000 8px);
```

### Rofi (rasi)
```css
border-radius: 0px;
/* Simular con background-image si el motor lo soporta */
background-image: url("path/to/corner-cut.svg");
```

### Hyprland (ventanas)
```ini
# No hay corte diagonal nativo — usar border-radius: 0
rounding = 0
```

### SVG / Iconos
Usar polígono con vértice cortado:
```
M 8,0  L W,0  L W,H  L 0,H  L 0,8  Z
```
(donde W = ancho, H = alto, 8 = tamaño del corte)

---

## Esquinas superiores de la barra (solo la barra principal)

Las dos esquinas superiores de la barra usan un corte de **10px**:

```css
background:
  linear-gradient(135deg, transparent 10px, #0a0000 10px) top left  / 51% 100% no-repeat,
  linear-gradient(225deg, transparent 10px, #0a0000 10px) top right / 51% 100% no-repeat;
```

> **Nota:** GTK3 soporta máximo 2 capas de `background-image` confiablemente. No agregar más capas o las esquinas se rompen.

---

## Espaciado y métricas

| Elemento              | Valor          |
|-----------------------|----------------|
| Margen entre módulos  | `6px`          |
| Padding interno       | `10px` L/R     |
| Margen vertical módulo | `5px` T/B     |
| Separación de la barra | `4px` (margin waybar) |
| Tamaño del corte (módulos) | `8px`     |
| Tamaño del corte (barra)   | `10px`    |

---

## Animaciones

### Parpadeo del workspace activo
```css
animation-name: blink-workspace;
animation-duration: 0.8s;
animation-timing-function: linear;
animation-iteration-count: infinite;
animation-direction: alternate;

@keyframes blink-workspace {
  from { color: #fcee0a; }
  to   { color: #7a6e00; }
}
```

### Parpadeo de alerta crítica
```css
animation-name: blink-critical;
animation-duration: 0.5s;
animation-timing-function: linear;
animation-iteration-count: infinite;
animation-direction: alternate;

@keyframes blink-critical {
  to {
    color: #ffcccc;
    background: linear-gradient(135deg, transparent 8px, #660000 8px);
  }
}
```

---

## Hover / estados interactivos

| Estado        | Fondo      | Texto      |
|---------------|------------|------------|
| Normal        | `#1a0000`  | según módulo |
| Hover / foco  | `#ff003c`  | `#0a0000` (invertido) |
| Crítico       | `#ff003c`  | `#0a0000`  |
| Deshabilitado | `#3a0000`  | `#660000`  |

---

## Recetas por componente

### Dunst (notificaciones)

```ini
[global]
    font = JetBrainsMono Nerd Font 13
    corner_radius = 0
    frame_color = "#ff003c"
    frame_width = 1

[urgency_low]
    background = "#0a0000"
    foreground = "#00cfff"

[urgency_normal]
    background = "#0a0000"
    foreground = "#fcee0a"

[urgency_critical]
    background = "#ff003c"
    foreground = "#0a0000"
    frame_color = "#660000"
```

### Rofi (launcher)

```css
* {
    font:            "JetBrainsMono Nerd Font 14";
    background-color: #0a0000;
    text-color:       #ffcccc;
    border-color:     #ff003c;
}
window {
    border:           1px;
    border-radius:    0px;
    padding:          8px;
}
element selected {
    background-color: #ff003c;
    text-color:       #0a0000;
}
inputbar {
    text-color: #fcee0a;
}
```

### Kitty / terminal

```ini
background            #0a0000
foreground            #ffcccc
cursor                #ff003c
color1                #ff003c
color3                #fcee0a
color6                #00cfff
color9                #ff6666
selection_background  #ff003c
selection_foreground  #0a0000
```

### Hyprland (borders)

```ini
general {
    col.active_border   = rgba(ff003cff)
    col.inactive_border = rgba(1a0000ff)
    border_size         = 1
    rounding            = 0
}
```

---

## Jerarquía visual — resumen rápido

```
#ff003c  →  Lo más importante (reloj, bordes, alertas)
#fcee0a  →  Información de uso (red, batería, disco)
#00cfff  →  Métricas del sistema (CPU, temp, audio)
#ffcccc  →  Texto secundario (tooltips, menús)
#1a0000  →  Superficie de módulo
#0a0000  →  Fondo base
```
