#!/usr/bin/env python3
"""Cyberpunk HUD — reloj + batería en overlay sobre fullscreen."""
import gi
gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gtk, GLib, GtkLayerShell

import os, signal, socket, threading, time

_toggle_flag = threading.Event()

CSS = b"""
window {
  background-color: transparent;
  background-image:
    linear-gradient(135deg, transparent 8px, rgba(26,0,0,0.72) 8px),
    linear-gradient(315deg, transparent 8px, rgba(26,0,0,0.72) 8px);
  background-position: top left, bottom right;
  background-size: 51% 100%, 51% 100%;
  background-repeat: no-repeat, no-repeat;
}
box {
  padding: 6px 14px;
}
label {
  color: #fcee0a;
  font-family: "JetBrainsMono Nerd Font";
  font-size: 13px;
}
label.battery {
  color: #00cfff;
  margin-right: 10px;
}
"""

BAT = "/sys/class/power_supply/BAT0"

CHARGING_ICONS = ["󰢜","󰂆","󰂇","󰂈","󰢝","󰂉","󰢞","󰂊","󰂋","󰂅"]
DISCHARGING_ICONS = ["󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]


def battery_text():
    try:
        cap = int(open(f"{BAT}/capacity").read().strip())
        status = open(f"{BAT}/status").read().strip()
        idx = min(cap // 10, 9)
        icon = CHARGING_ICONS[idx] if status == "Charging" else DISCHARGING_ICONS[idx]
        return f"{icon} {cap}%"
    except Exception:
        return ""


class HUD(Gtk.Window):
    def __init__(self):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)

        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.BOTTOM, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.BOTTOM, 18)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, 18)
        GtkLayerShell.set_namespace(self, "hud")
        GtkLayerShell.set_exclusive_zone(self, -1)

        self.set_decorated(False)
        self.set_resizable(False)

        provider = Gtk.CssProvider()
        provider.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            self.get_screen(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        self.add(box)

        self.bat_label = Gtk.Label(label="")
        self.bat_label.get_style_context().add_class("battery")
        self.clock_label = Gtk.Label(label="")

        box.pack_start(self.bat_label, False, False, 0)
        box.pack_start(self.clock_label, False, False, 0)

        self._shown = False
        signal.signal(signal.SIGUSR1, lambda s, f: _toggle_flag.set())
        GLib.timeout_add(150, self._check_toggle)

        self._update()
        GLib.timeout_add_seconds(1, self._update)

        threading.Thread(target=self._watch_hyprland, daemon=True).start()

    # ── visibilidad ──────────────────────────────────────────────────────────

    def _show(self):
        if not self._shown:
            self._shown = True
            self.show_all()

    def _hide(self):
        if self._shown:
            self._shown = False
            self.hide()

    def _check_toggle(self):
        if _toggle_flag.is_set():
            _toggle_flag.clear()
            self._hide() if self._shown else self._show()
        return GLib.SOURCE_CONTINUE

    def _set_fs(self, active: bool):
        GLib.idle_add(self._show if active else self._hide)

    # ── actualización de widgets ─────────────────────────────────────────────

    def _update(self):
        self.clock_label.set_text(" " + time.strftime("%I:%M %p"))
        bat = battery_text()
        self.bat_label.set_text(bat)
        self.bat_label.set_visible(bool(bat))
        return GLib.SOURCE_CONTINUE

    # ── monitor de eventos Hyprland ──────────────────────────────────────────

    def _watch_hyprland(self):
        sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
        if not sig:
            return
        sock_path = f"/run/user/{os.getuid()}/hypr/{sig}/.socket2.sock"

        while True:
            try:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
                    s.connect(sock_path)
                    buf = ""
                    while True:
                        chunk = s.recv(4096).decode(errors="replace")
                        if not chunk:
                            break
                        buf += chunk
                        while "\n" in buf:
                            line, buf = buf.split("\n", 1)
                            if line.startswith("fullscreen>>"):
                                self._set_fs(line.endswith("1"))
            except Exception:
                time.sleep(2)


if __name__ == "__main__":
    hud = HUD()
    hud.connect("destroy", Gtk.main_quit)
    Gtk.main()
