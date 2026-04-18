# 📂 Yazi — Guía de Comandos

> Gestor de archivos en terminal — Configuración Cyberpunk Red

---

## 🧭 Navegación Básica

| Tecla | Acción |
|---|---|
| `h` | Directorio padre (subir) |
| `j` / `↓` | Bajar cursor |
| `k` / `↑` | Subir cursor |
| `l` / `Enter` | Abrir archivo / entrar a directorio |
| `q` | Salir de Yazi |
| `Esc` | Cancelar / cerrar popup |

---

## 📁 Operaciones con Archivos (Personalizadas)

| Atajo | Acción |
|---|---|
| `e` | Abrir con selector interactivo |
| `Ctrl+e` | Editar con Neovim |
| `a` `f` | Crear archivo nuevo |
| `a` `d` | Crear directorio nuevo |
| `R` | Renombrar archivo (soporte batch) |
| `D` | Mover a papelera (`trash-put`) |
| `.` | Mostrar/ocultar archivos ocultos |

### Portapapeles (Wayland)

| Atajo | Acción |
|---|---|
| `c` `p` | Copiar ruta absoluta al portapapeles |
| `c` `n` | Copiar nombre del archivo al portapapeles |

---

## 🔍 Búsqueda y Navegación Avanzada

| Atajo | Acción |
|---|---|
| `Ctrl+f` | Buscar archivos con fzf |
| `Z` | Saltar a directorio con zoxide (salto inteligente) |
| `/` | Buscar en directorio actual |
| `n` | Siguiente resultado de búsqueda |
| `N` | Resultado anterior de búsqueda |

---

## 📋 Selección y Copia

| Tecla | Acción |
|---|---|
| `Space` | Seleccionar/deseleccionar archivo |
| `V` | Modo visual (selección múltiple) |
| `y` | Copiar (yank) archivos seleccionados |
| `x` | Cortar archivos seleccionados |
| `p` | Pegar archivos copiados/cortados |
| `P` | Pegar (symlink) |
| `d` | Eliminar archivos seleccionados |
| `a` | Seleccionar todos |
| `r` | Invertir selección |

---

## 📂 Marcadores (Bookmarks)

| Tecla | Acción |
|---|---|
| `m` + `letra` | Guardar marcador con esa letra |
| `'` + `letra` | Saltar al marcador |
| `b` | Ver todos los marcadores |

---

## 🔄 Ordenación (Personalizada)

| Atajo | Acción |
|---|---|
| `s` `n` | Ordenar por nombre |
| `s` `s` | Ordenar por tamaño (mayor primero) |
| `s` `m` | Ordenar por fecha (más reciente primero) |

---

## 🖥️ Panel de Preview

El panel derecho muestra una preview del archivo bajo el cursor:

| Tipo | Preview |
|---|---|
| Texto/Código | Contenido del archivo |
| Imágenes | Vista previa de la imagen |
| Directorios | Contenido del directorio |
| PDF | No disponible |
| Video | No disponible |

### Atajos del preview

| Tecla | Acción |
|---|---|
| `i` | Preview a pantalla completa |
| `Ctrl+i` | Toggle preview (mostrar/ocultar) |
| `[` | Reducir ancho del panel izquierdo |
| `]` | Aumentar ancho del panel izquierdo |

---

## 🚀 Apertura de Archivos (Reglas Automáticas)

| Tipo de archivo | Aplicación | Comportamiento |
|---|---|---|
| Texto/Código (`*.lua`, `*.py`, `*.js`, etc.) | **Neovim** | Bloquea yazi hasta cerrar |
| JSON, XML, Shell scripts | **Neovim** | Bloquea yazi hasta cerrar |
| PDF | **Zathura** | Se abre en paralelo |
| Imágenes (PNG, JPG, GIF) | **imv** | Se abre en paralelo |
| Video (MP4, MKV, AVI) | **mpv** | Se abre en paralelo |
| Audio (MP3, FLAC, OGG) | **mpv** (sin video) | Se abre en paralelo |
| ZIP, TAR, 7Z, RAR | **unar** | Extrae en directorio actual |
| SVG | **imv** + **Neovim** | Opciones de abrir o editar |
| Otro (fallback) | **xdg-open** | Se abre en paralelo |

---

## 🧩 Plugins

| Plugin | Tecla | Descripción |
|---|---|---|
| **fzf** | `Ctrl+f` | Búsqueda difusa de archivos |
| **zoxide** | `Z` | Navegación inteligente a directorios frecuentes |

---

## ⌨️ Comandos de Línea

| Comando | Acción |
|---|---|
| `:` | Abrir consola de comandos |
| `cd ruta` | Cambiar directorio |
| `shell comando` | Ejecutar comando del shell |
| `quit` | Salir |
| `close` | Cerrar tab actual |

---

## 🗂️ Tabs

| Tecla | Acción |
|---|---|
| `t` | Abrir nueva tab |
| `1`-`9` | Ir a tab N |
| `[` | Tab anterior |
| `]` | Siguiente tab |
| `}` | Cerrar tab actual |

---

## 📌 Configuración del Layout

```
┌──────────┬───────────────────┬──────────────────────────────┐
│          │                   │                              │
│  Panel   │     Panel         │       Panel                  │
│ Izquierdo│     Central       │       Preview                │
│  (1/8)   │     (3/8)         │       (4/8)                  │
│          │                   │                              │
│ Árbol    │  Lista de         │  Vista previa del            │
│ de dirs  │  archivos         │  archivo seleccionado        │
│          │                   │                              │
└──────────┴───────────────────┴──────────────────────────────┘
```

- Proporción: `[1, 3, 4]`
- Directorios siempre primero
- Tamaño visible en cada línea
- Symlinks visibles