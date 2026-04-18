# 🎮 Neovim — Guía de Comandos

> Configuración Cyberpunk Red — Todas las teclas y comandos disponibles

---

## 📁 Explorador de Archivos (nvim-tree)

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
| `y` | Copiar nombre del archivo |
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

---

## 🗂️ Tabs (Pestañas)

| Atajo | Acción |
|---|---|
| `Tab` | Siguiente tab |
| `Shift+Tab` | Tab anterior |
| `Ctrl+1` a `Ctrl+9` | Ir al tab N |
| `:tabnew archivo` | Abrir archivo en tab nueva |
| `:tabclose` | Cerrar tab actual |

### Indicadores del tabline

| Símbolo | Significado |
|---|---|
| `●` | Archivo modificado (sin guardar) |
| `✕` | Sin modificaciones |

---

## 🔀 Navegación entre Ventanas

| Atajo | Acción |
|---|---|
| `Ctrl+w h` | Ventana izquierda |
| `Ctrl+w l` | Ventana derecha |
| `Ctrl+w j` | Ventana abajo |
| `Ctrl+w k` | Ventana arriba |
| `Ctrl+w w` | Ciclar entre ventanas |
| `Ctrl+w p` | Ventana previa |

---

## 🔀 Git — gitsigns.nvim (sign column + hunks)

| Atajo | Acción |
|---|---|
| `]h` | Saltar al siguiente hunk (cambio) |
| `[h` | Saltar al hunk anterior |
| `<leader>hp` | Preview del hunk (popup) |
| `<leader>hs` | Stage hunk (agregar al staging area) |
| `<leader>hr` | Reset hunk (descartar cambio local) |
| `<leader>hu` | Undo stage hunk (deshacer stage) |
| `<leader>hb` | Toggle blame inline (autor al final de línea) |
| `<leader>hd` | Diff this (comparar archivo con HEAD) |

### Colores en la sign column

| Color | Significado |
|---|---|
| 🔵 Cyan `▎` | Línea añadida |
| 🟡 Amarillo `▎` | Línea modificada |
| 🔴 Rojo `█` | Línea eliminada |
| 🟠 Naranja `▎` | Línea modificada+eliminada |

### Git blame inline

Se muestra automáticamente al final de cada línea:
```
<autor>, <hace cuánto> • <mensaje del commit>
```

---

## 🔀 Git — vim-fugitive (operaciones Git)

| Comando | Acción |
|---|---|
| `:Git status` | Ver estado del repositorio |
| `:Git commit` | Hacer commit |
| `:Git push` | Push al remoto |
| `:Git pull` | Pull del remoto |
| `:Git diff` | Ver diferencias (split interactivo) |
| `:Git blame` | Blame completo del archivo |
| `:Git log` | Historial de commits |
| `:Git mergetool` | Resolver conflictos de merge |
| `:Git add %` | Stage el archivo actual |
| `:Git reset %` | Unstage el archivo actual |
| `:Gwrite` | Equivalente a `:Git add %` |
| `:Gread` | Restaurar archivo desde HEAD |
| `:GMove ruta` | Mover/renombrar archivo (git mv) |
| `:GDelete` | Eliminar archivo (git rm) |

### Dentro de `:Git status`

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

| Acción | Comando |
|---|---|
| Restaurar sesión | Automático al abrir `nvim` en el mismo directorio |
| Ignorar sesión una vez | `nvim --clean` |
| Detener persistencia | `:lua require("persistence").stop()` |
| Restaurar manualmente | `:lua require("persistence").load()` |
| Ver sesiones guardadas | `ls ~/.local/share/nvim/persistence/` |

### Qué se guarda
- ✅ Buffers abiertos (con cambios no guardados)
- ✅ Tabs y sus posiciones
- ✅ Tamaño de ventanas
- ✅ Directorio de trabajo actual
- ✅ Variables globales

---

## ⌨️ Comandos Esenciales de Vim

### Modos

| Tecla | Modo |
|---|---|
| `i` | Modo inserción (antes del cursor) |
| `a` | Modo inserción (después del cursor) |
| `o` | Nueva línea abajo + inserción |
| `O` | Nueva línea arriba + inserción |
| `v` | Modo visual (selección) |
| `V` | Modo visual (líneas completas) |
| `Esc` | Volver a modo normal |

### Edición

| Tecla | Acción |
|---|---|
| `dd` | Eliminar línea |
| `yy` | Copiar línea |
| `p` | Pegar después |
| `P` | Pegar antes |
| `u` | Deshacer |
| `Ctrl+r` | Rehacer |
| `x` | Eliminar carácter |
| `cw` | Cambiar palabra |
| `ci"` | Cambiar texto dentro de comillas |
| `:%s/viejo/nuevo/g` | Reemplazar todo en el archivo |

### Guardar y salir

| Comando | Acción |
|---|---|
| `:w` | Guardar |
| `:q` | Cerrar |
| `:wq` | Guardar y cerrar |
| `:q!` | Cerrar sin guardar |
| `:qa` | Cerrar todo (guarda sesión automáticamente) |
| `:wa` | Guardar todos los buffers |

### Búsqueda

| Tecla | Acción |
|---|---|
| `/texto` | Buscar hacia adelante |
| `?texto` | Buscar hacia atrás |
| `n` | Siguiente resultado |
| `N` | Resultado anterior |
| `*` | Buscar palabra bajo el cursor |
| `:%s/texto/reemplazo/gc` | Buscar y reemplazar con confirmación |