# 🎮 Neovim — Guía de Comandos

> Configuración **Cyberpunk Red** — Todos los atajos, comandos y operaciones disponibles

---

## 📁 Explorador de Archivos (nvim-tree)

### Atajos globales

| Atajo | Acción |
|---|---|
| `Ctrl+b` | Abrir / cerrar el panel del árbol |
| `Ctrl+e` | Alternar foco entre árbol y editor |

### Dentro del árbol de archivos

| Tecla | Acción |
|---|---|
| `Enter` | Abrir archivo o expandir carpeta |
| `a` | Crear nuevo archivo (terminar con `/` para carpeta) |
| `d` | Eliminar archivo/carpeta |
| `r` | Renombrar archivo |
| `c` | Copiar archivo |
| `x` | Cortar archivo |
| `p` | Pegar archivo |
| `y` | Copiar nombre del archivo al portapapeles |
| `q` | Cerrar el árbol |
| `R` | Refrescar el árbol |
| `H` | Mostrar/ocultar archivos ocultos |
| `I` | Mostrar/ocultar archivos ignorados por git |
| `s` | Abrir archivo con sistema externo |
| `f` | Buscar archivo dentro del árbol |
| `F` | Limpiar filtro de búsqueda |
| `W` | Colapsar todo el árbol |
| `E` | Expandir todo el árbol |
| `m` | Marcar/desmarcar archivo |
| `U` | Desmarcar todos |
| `Ctrl+e` | Volver al editor (sobrescrito dentro del árbol) |
| `Ctrl+t` | Abrir archivo en nueva tab |
| `Ctrl+v` | Abrir archivo en split vertical |
| `Ctrl+x` | Abrir archivo en split horizontal |

### Colores del panel

| Elemento | Color |
|---|---|
| Carpetas | Rojo neón `#ff003c` |
| Archivos | Cyan neón `#00cfff` |
| Nombres de archivo | Texto suave `#ffcccc` |
| Línea activa | Fondo `#1a0000` |
| Marcadores de indentación | `#2b0000` |
| Git dirty | Amarillo `#fcee0a` |
| Git new | Cyan `#00cfff` |
| Git deleted | Rojo `#ff003c` |

---

## 🗂️ Tabs (Pestañas)

### Atajos

| Atajo | Comando | Acción |
|---|---|---|
| `Tab` | `:tabnext` | Siguiente tab |
| `Shift+Tab` | `:tabprevious` | Tab anterior |
| `Ctrl+1` | `1gt` | Ir al tab 1 |
| `Ctrl+2` | `2gt` | Ir al tab 2 |
| `Ctrl+3` | `3gt` | Ir al tab 3 |
| `Ctrl+4` | `4gt` | Ir al tab 4 |
| `Ctrl+5` | `5gt` | Ir al tab 5 |
| `Ctrl+6` | `6gt` | Ir al tab 6 |
| `Ctrl+7` | `7gt` | Ir al tab 7 |
| `Ctrl+8` | `8gt` | Ir al tab 8 |
| `Ctrl+9` | `9gt` | Ir al tab 9 |

### Comandos de tabs

| Comando | Acción |
|---|---|
| `:tabnew archivo` | Abrir archivo en tab nueva |
| `:tabclose` | Cerrar tab actual |
| `:tabonly` | Cerrar todos los tabs menos el actual |
| `:tabmove N` | Mover tab a la posición N |

### Indicadores del tabline

| Símbolo | Significado |
|---|---|
| `●` | Archivo modificado (sin guardar) |
| `✕` | Sin modificaciones |

El tabline muestra: número de tab, icono del archivo, nombre del archivo, y estado de modificación, todo alineado a la derecha con separadores `│`.

---

## 🔀 Navegación entre Ventanas

| Atajo | Acción |
|---|---|
| `Ctrl+w h` | Ir a ventana izquierda |
| `Ctrl+w l` | Ir a ventana derecha |
| `Ctrl+w j` | Ir a ventana abajo |
| `Ctrl+w k` | Ir a ventana arriba |
| `Ctrl+w w` | Ciclar entre ventanas |
| `Ctrl+w p` | Ventana previa |
| `Ctrl+w v` | Dividir verticalmente |
| `Ctrl+w s` | Dividir horizontalmente |
| `Ctrl+w q` | Cerrar ventana (buffer) |
| `Ctrl+w o` | Cerrar todas menos la actual |
| `Ctrl+w =` | Igualar tamaño de ventanas |

---

## 🔀 Git — gitsigns.nvim (sign column + hunks)

gitsigns gestiona los indicadores en la columna de signos y las operaciones sobre hunks.

### Atajos

| Atajo | Acción |
|---|---|
| `]h` | Saltar al siguiente hunk (cambio) |
| `[h` | Saltar al hunk anterior |
| `<leader>hs` | Stage hunk (agregar al staging area) |
| `<leader>hr` | Reset hunk (descartar cambio local) |
| `<leader>hu` | Undo stage hunk (deshacer stage) |
| `<leader>hp` | Preview del hunk (popup con diff) |
| `<leader>hb` | Toggle blame inline (autor al final de línea) |
| `<leader>hd` | Diff this (comparar archivo con HEAD) |

> `<leader>` es `\` por defecto en Neovim.

### Colores en la sign column

| Indicador | Color | Significado |
|---|---|---|
| `▎` cyan | `#00cfff` | Línea añadida |
| `▎` amarillo | `#fcee0a` | Línea modificada |
| `█` rojo | `#ff003c` | Línea eliminada |
| `▎` naranja | `#ff6e00` | Línea modificada + eliminada |
| `▎` gris | `#553333` | Archivo sin seguimiento (untracked) |

### Git blame inline

Se muestra automáticamente al final de cada línea (con delay de 300ms):

```
<autor>, <hace cuánto> • <mensaje del commit>
```

Color: `#553333` en cursiva.

---

## 🔀 Git — vim-fugitive (operaciones Git completas)

vim-fugitive expone todos los comandos de Git como `:Git <subcomando>`.

### Comandos principales

| Comando | Acción | Equivalente git CLI |
|---|---|---|
| `:Git status` | Ver estado del repositorio | `git status` |
| `:Git commit` | Hacer commit (abre buffer) | `git commit` |
| `:Git commit -m "msg"` | Commit con mensaje directo | `git commit -m` |
| `:Git push` | Push al remoto | `git push` |
| `:Git pull` | Pull del remoto | `git pull` |
| `:Git diff` | Ver diferencias (split interactivo) | `git diff` |
| `:Git blame` | Blame completo del archivo | `git blame` |
| `:Git log` | Historial de commits | `git log` |
| `:Git mergetool` | Resolver conflictos de merge | `git mergetool` |
| `:Git add %` | Stage el archivo actual | `git add <archivo>` |
| `:Git reset %` | Unstage el archivo actual | `git reset <archivo>` |

### Atajos rápidos

| Comando | Equivalente a |
|---|---|
| `:Gwrite` | `:Git add %` |
| `:Gread` | Restaurar archivo desde HEAD |
| `:GMove destino` | `git mv <origen> <destino>` |
| `:GDelete` | `git rm <archivo>` |

### Dentro del buffer `:Git status`

| Tecla | Acción |
|---|---|
| `s` | Stage archivo bajo el cursor |
| `u` | Unstage archivo bajo el cursor |
| `cc` | Hacer commit |
| `dd` | Ver diff del archivo |
| `X` | Descartar cambios del archivo |

---

## 💾 Persistencia de Sesión (persistence.nvim)

La sesión se guarda automáticamente al salir de Neovim y se restaura al reabrir.

### Comportamiento por defecto

| Acción | Comportamiento |
|---|---|
| Abrir `nvim` | Restaura la sesión anterior automáticamente |
| Cerrar `nvim` | Guarda la sesión actual automáticamente |

### Comandos manuales

| Comando | Acción |
|---|---|
| `nvim --clean` | Iniciar sin restaurar sesión (ignora una vez) |
| `:lua require("persistence").load()` | Restaurar sesión manualmente |
| `:lua require("persistence").stop()` | Detener la persistencia |
| `:lua require("persistence").load({ last = true })` | Restaurar última sesión guardada |

### Archivos de sesión

Las sesiones se guardan en:
```
~/.local/share/nvim/persistence/
```

### Qué se guarda

- Buffers abiertos (incluyendo cambios no guardados)
- Tabs y su orden
- Tamaño y posición de ventanas
- Directorio de trabajo actual
- Ayuda abierta
- Variables globales
- Skiprtp (no recarga plugins al restaurar)

---

## ⌨️ Comandos Esenciales de Vim

### Modos

| Tecla | Acción |
|---|---|
| `i` | Modo inserción (antes del cursor) |
| `a` | Modo inserción (después del cursor) |
| `o` | Nueva línea abajo + inserción |
| `O` | Nueva línea arriba + inserción |
| `v` | Modo visual (selección por caracteres) |
| `V` | Modo visual (selección por líneas) |
| `Ctrl+v` | Modo visual (selección por bloques) |
| `Esc` | Volver a modo normal |

### Edición

| Comando | Acción |
|---|---|
| `dd` | Eliminar línea |
| `yy` | Copiar línea |
| `p` | Pegar después del cursor |
| `P` | Pegar antes del cursor |
| `u` | Deshacer |
| `Ctrl+r` | Rehacer |
| `x` | Eliminar carácter bajo el cursor |
| `cw` | Cambiar palabra desde el cursor |
| `ci"` | Cambiar texto dentro de comillas |
| `:%s/viejo/nuevo/g` | Reemplazar todas las ocurrencias |
| `.` | Repetir última acción |

### Guardar y salir

| Comando | Acción |
|---|---|
| `:w` | Guardar archivo |
| `:q` | Cerrar buffer |
| `:wq` | Guardar y cerrar |
| `:q!` | Cerrar sin guardar |
| `:qa` | Cerrar todo (guarda sesión automáticamente) |
| `:wa` | Guardar todos los buffers |
| `ZZ` | Guardar y salir (equivalente a `:wq`) |
| `ZQ` | Salir sin guardar (equivalente a `:q!`) |

### Búsqueda

| Comando | Acción |
|---|---|
| `/texto` | Buscar hacia adelante |
| `?texto` | Buscar hacia atrás |
| `n` | Siguiente coincidencia |
| `N` | Coincidencia anterior |
| `*` | Buscar palabra bajo el cursor |
| `:%s/texto/reemplazo/gc` | Buscar y reemplazar con confirmación |

---

## ⚙️ Opciones de Configuración

| Opción | Valor | Descripción |
|---|---|---|
| `number` | `true` | Mostrar números de línea |
| `relativenumber` | `false` | Sin números relativos |
| `cursorline` | `true` | Resaltar línea del cursor |
| `hidden` | `true` | Permitir buffers con cambios sin guardar en background |
| `undofile` | `true` | Persistir historial de undo entre sesiones |
| `swapfile` | `true` | Archivo swap para recuperación ante crashes |
| `backup` | `false` | Sin archivos de backup (undo file es suficiente) |
| `showtabline` | `2` | Tabline siempre visible |
| `termguicolors` | `true` | Soporte de color completo (24-bit) |

---

## 🎨 Colores del Esquema (Cyberpunk Red)

### Áreas principales

| Elemento | Color | Hex |
|---|---|---|
| Fondo (Normal) | Transparente | `none` |
| Línea del cursor | `#1a0000` | Rojo oscuro |
| Número de línea | `#661111` | Rojo apagado |
| Número de línea activo | `#ff003c` | Rojo neón |
| Texto de archivos | `#ffcccc` | Texto suave |

### Tabline

| Elemento | Color de texto | Fondo | Negrita |
|---|---|---|---|
| Tab inactivo | `#884444` | `#0a0000` | No |
| Tab activo | `#ff003c` | `#1a0000` | Sí |
| Tab modificado | `#fcee0a` | `#0a0000` | No |
| Tab modificado + activo | `#fcee0a` | `#1a0000` | Sí |
| Número de tab | `#661111` | `#0a0000` | No |
| Número de tab activo | `#ff003c` | `#1a0000` | Sí |
| Separador | `#2b0000` | `#0a0000` | No |

### Regla de color

- **Rojo** `#ff003c` → acción, crítico, bordes activos, cursor
- **Amarillo** `#fcee0a` → datos/estado (cambios, modificaciones)
- **Cyan** `#00cfff` → sistema/técnico (archivos, líneas nuevas)
- **Texto suave** `#ffcccc` → contenido de archivos, tooltips

---

## 🧩 Plugins Instalados

| Plugin | Función | Carga |
|---|---|---|
| `folke/lazy.nvim` | Gestor de plugins | Al inicio |
| `nvim-tree/nvim-web-devicons` | Íconos de archivos | Al inicio |
| `folke/persistence.nvim` | Persistencia de sesión | Al inicio |
| `lewis6991/gitsigns.nvim` | Git en sign column | `BufReadPre` |
| `tpope/vim-fugitive` | Operaciones Git completas | Lazy |
| `nvim-tree/nvim-tree.lua` | Explorador de archivos | Lazy |
