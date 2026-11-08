-- ============================================================
-- Hyprland (0.57+) — configuración en Lua
-- Migrada desde hyprland.conf (hyprlang).
-- Wiki: https://wiki.hypr.land/configuring/
-- ============================================================


------------------------
---- CONFIG. LOCAL ----
------------------------

-- Monitores, teclado y workspaces por monitor (dependiente del equipo).
-- Copia local.lua.example como local.lua y adáptalo.
local localConfig = os.getenv("HOME") .. "/.config/hypr/local.lua"
local f = io.open(localConfig, "r")
if f then
    f:close()
    dofile(localConfig)
else
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
end


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "rofi -show run"
local scripts     = "~/.config/hypr/scripts"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd(scripts .. "/hud.py")

    -- Demonio de notificaciones
    hl.exec_cmd("swaync")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Arasaka-Red'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

    hl.exec_cmd("hypridle")
    hl.exec_cmd("udiskie --tray")
    hl.exec_cmd(scripts .. "/mount-gdrive.sh")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- GTK theme
hl.env("GTK_THEME", "Arasaka-Red")
hl.env("GTK_ICON_THEME", "Tela-circle-red-dark")


-----------------------
---- LOOK AND FEEL ----
-----------------------

local red      = "rgba(ff0033ee)"
local darkRed  = "rgba(440000aa)"

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(ff0033ee)", "rgba(ff0000ee)", "rgba(ff0055ee)" }, angle = 45 },
            inactive_border = darkRed,
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    -- Group tabs — solo indicador, sin título
    group = {
        col = {
            border_active          = red,
            border_inactive        = darkRed,
            border_locked_active   = red,
            border_locked_inactive = darkRed,
        },
        groupbar = {
            render_titles = false,
            height        = 1,
            gradients     = false,
            col = {
                active   = red,
                inactive = darkRed,
            },
        },
    },

    decoration = {
        rounding       = 15,
        rounding_power = 1,

        active_opacity   = 1.0,
        inactive_opacity = 0.90,

        shadow = {
            enabled      = true,
            range        = 7,
            render_power = 3,
            color        = "rgba(ff000019)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.8,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

-- Curvas
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })
hl.curve("cyberSnappy",    { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.1} } })

-- Animaciones
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 3,    bezier = "linear" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4,    bezier = "cyberSnappy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4,    bezier = "cyberSnappy",  style = "popin 80%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3,    bezier = "linear",       style = "popin 80%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


---------------
---- INPUT ----
---------------

-- Teclado configurado en local.lua (dependiente del equipo)
hl.config({
    input = {
        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 = sin modificación

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local function key(k) return mainMod .. " + " .. k end
local exec = hl.dsp.exec_cmd

hl.bind(key("Q"), exec(terminal))
hl.bind(key("C"), hl.dsp.window.close())
hl.bind(key("M"), exec("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(key("E"), exec(fileManager))
hl.bind(key("V"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(key("R"), exec(menu))
hl.bind(key("D"), hl.dsp.window.pseudo())          -- dwindle
hl.bind(key("J"), hl.dsp.layout("togglesplit"))    -- dwindle
hl.bind(key("F"), hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Agrupar ventanas (tabs estilo i3wm)
hl.bind(key("G"),             hl.dsp.group.toggle())
hl.bind(key("Tab"),           hl.dsp.group.next())
hl.bind(key("SHIFT + Tab"),   hl.dsp.group.prev())

hl.bind(key("I"), exec("pkill -USR1 -f hud.py"))              -- Toggle HUD reloj/batería
hl.bind(key("P"), exec(scripts .. "/pip-toggle.sh"))         -- Toggle Picture-in-Picture
hl.bind(key("N"), exec("swaync-client -t -sw"))              -- Centro de notificaciones
hl.bind(key("L"), exec("pkill waybar; waybar &"))            -- Reiniciar waybar

-- Sidepad
hl.bind(key("S"),              exec(scripts .. "/toggle_sidepad.sh"))
hl.bind(key("CTRL + S"),       exec(scripts .. "/toggle_sidepad.sh --kill"))
hl.bind(key("SHIFT + S"),      exec(scripts .. "/toggle_sidepad_active.sh"))
hl.bind(key("CTRL + SHIFT + S"), exec(scripts .. "/toggle_sidepad_active.sh --release"))

-- Mover foco con Super + flechas / mover ventana con Super + Alt + flechas
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(key(dir),           hl.dsp.focus({ direction = dir }))
    hl.bind(key("ALT + " .. dir), hl.dsp.window.move({ direction = dir }))
end

-- Workspaces: Super + [0-9] / mover ventana: Super + Shift + [0-9]
for i = 1, 10 do
    local k = i % 10 -- 10 → tecla 0
    hl.bind(key(k),              hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(key("H"),         hl.dsp.workspace.toggle_special("magic"))
hl.bind(key("SHIFT + H"), hl.dsp.window.move({ workspace = "special:magic" }))

-- Recorrer workspaces con Super + scroll
hl.bind(key("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Mover/redimensionar con Super + clic izq/der
hl.bind(key("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Teclas multimedia (volumen y brillo) — swayosd
local repeatLocked = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  exec("swayosd-client --output-volume raise"),      repeatLocked)
hl.bind("XF86AudioLowerVolume",  exec("swayosd-client --output-volume lower"),      repeatLocked)
hl.bind("XF86AudioMute",         exec("swayosd-client --output-volume mute-toggle"), repeatLocked)
hl.bind("XF86AudioMicMute",      exec("swayosd-client --input-volume mute-toggle"),  repeatLocked)
hl.bind("XF86MonBrightnessUp",   exec("swayosd-client --brightness raise"),         repeatLocked)
hl.bind("XF86MonBrightnessDown", exec("swayosd-client --brightness lower"),         repeatLocked)

-- Capturas de pantalla (grim, slurp, wl-clipboard)
local shotFile = 'mkdir -p ~/images/screenshots && FILE=~/images/screenshots/$(date +%Y%m%d_%H%M%S).png'
hl.bind("SHIFT + Print", exec(shotFile .. ' && grim - | tee "$FILE" | wl-copy && notify-send "Captura" "Pantalla completa copiada y guardada"'))
hl.bind("Print",         exec(shotFile .. ' && grim -g "$(slurp)" - | tee "$FILE" | wl-copy && notify-send "Captura" "Área seleccionada copiada y guardada"'))
hl.bind(key("SHIFT + P"), exec('grim -g "$(slurp)" - | wl-copy && notify-send "Captura" "Área copiada al portapapeles"'))
hl.bind(key("SHIFT + F"), exec("/home/andres/dotfiles/util/sftp/sftp-toggle.sh"))

-- Multimedia (playerctl)
hl.bind("XF86AudioNext",  exec("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  exec("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignorar peticiones de maximizar
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Arreglar arrastre en XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- hyprland-run
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- btmenu / wifimenu — flotantes esquina superior derecha
for _, cls in ipairs({ "btmenu", "wifimenu" }) do
    hl.window_rule({
        name  = cls .. "-float",
        match = { class = cls },
        float = true,
        size  = "550 500",
        move  = "monitor_w-560 50",
    })
end

-- sidepad — terminal scratchpad lateral
hl.window_rule({
    name  = "sidepad",
    match = { class = "sidepad-terminal" },
    float = true,
    pin   = true,
})

-- yazi — file manager flotante centrado
hl.window_rule({
    name   = "yazi-float",
    match  = { class = "yazi-fm" },
    float  = true,
    size   = "900 550",
    center = true,
})

-- btop — abre en workspace nuevo sin flotar
hl.window_rule({
    name      = "btop-workspace",
    match     = { class = "btop" },
    workspace = "empty",
})

-- Diálogos comunes — siempre flotantes y centrados
local floatingDialogs = {
    { "float-open-dialog",     { title = "^(Open)$" } },
    { "float-save-dialog",     { title = "^(Save As)$" } },
    { "float-file-progress",   { title = "^(File Operation Progress)$" } },
    { "float-confirm-replace", { title = "^(Confirm to replace files)$" } },
    { "float-choose-files",    { title = "^(Choose Files)$" } },
    { "float-xdg-portal",      { class = "^(xdg-desktop-portal-gtk)$" } },
    { "float-polkit",          { class = "^(polkit-gnome-authentication-agent-1)$" } },
}
for _, d in ipairs(floatingDialogs) do
    hl.window_rule({ name = d[1], match = d[2], float = true, center = true })
end
