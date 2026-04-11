#!/usr/bin/env python3
# waybar_cal.py — Calendario con festivos colombianos para tooltip de Waybar
# Salida: JSON con "text" (hora) y "tooltip" (calendario 2 meses + festivos)

import json
import calendar
import datetime
import re

MONTHS_ES = [
    "", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
]
MONTHS_SHORT = [
    "", "Ene", "Feb", "Mar", "Abr", "May", "Jun",
    "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
]
DAYS_ES = ["Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"]

RED    = "#ff003c"
YELLOW = "#fcee0a"
CYAN   = "#00cfff"
SOFT   = "#ffcccc"


def s(text, color, bold=False, underline=False):
    """Pango span helper."""
    inner = str(text)
    if underline:
        inner = f"<u>{inner}</u>"
    if bold:
        inner = f"<b>{inner}</b>"
    return f"<span color='{color}'>{inner}</span>"


# ── Cálculo de Pascua (algoritmo de Butcher / Meeus) ──────────────────────────

def get_easter(year):
    a = year % 19
    b, c = divmod(year, 100)
    d, e = divmod(b, 4)
    f = (b + 8) // 25
    g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30
    i, k = divmod(c, 4)
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) // 451
    month = (h + l - 7 * m + 114) // 31
    day   = (h + l - 7 * m + 114) % 31 + 1
    return datetime.date(year, month, day)


def next_monday(date):
    """Devuelve date si ya es lunes, si no el lunes siguiente (Ley Emiliani)."""
    wd = date.weekday()   # 0 = lunes
    return date if wd == 0 else date + datetime.timedelta(days=7 - wd)


# ── Festivos colombianos ───────────────────────────────────────────────────────

def get_colombian_holidays(year):
    """Devuelve dict {datetime.date: nombre} de festivos para ese año."""
    h = {}

    def add(date, name):
        h[date] = name

    def emiliani(m, d, name):
        add(next_monday(datetime.date(year, m, d)), name)

    # Fijos
    add(datetime.date(year,  1,  1), "Año Nuevo")
    add(datetime.date(year,  5,  1), "Día del Trabajo")
    add(datetime.date(year,  7, 20), "Independencia de Colombia")
    add(datetime.date(year,  8,  7), "Batalla de Boyacá")
    add(datetime.date(year, 12,  8), "Inmaculada Concepción")
    add(datetime.date(year, 12, 25), "Navidad")

    # Ley Emiliani (se mueven al lunes siguiente si no caen en lunes)
    emiliani( 1,  6, "Reyes Magos")
    emiliani( 3, 19, "San José")
    emiliani( 6, 29, "San Pedro y San Pablo")
    emiliani( 8, 15, "Asunción de la Virgen")
    emiliani(10, 12, "Día de la Raza")
    emiliani(11,  1, "Todos los Santos")
    emiliani(11, 11, "Independencia de Cartagena")

    # Semana Santa y móviles de Pascua
    easter = get_easter(year)
    add(easter - datetime.timedelta(days=3), "Jueves Santo")
    add(easter - datetime.timedelta(days=2), "Viernes Santo")
    add(next_monday(easter + datetime.timedelta(days=39)), "Ascensión del Señor")
    add(next_monday(easter + datetime.timedelta(days=60)), "Corpus Christi")
    add(next_monday(easter + datetime.timedelta(days=68)), "Sagrado Corazón de Jesús")

    return h


# ── Utilidades de centrado ────────────────────────────────────────────────────

def visible_len(line):
    """Longitud visible de una línea (sin tags Pango)."""
    return len(re.sub(r'<[^>]+>', '', line))

def center_line(line, width):
    """Añade espacios a la izquierda para centrar dentro de `width` chars visibles."""
    pad = max(0, (width - visible_len(line)) // 2)
    return ' ' * pad + line


# ── Renderizado de calendario ──────────────────────────────────────────────────

def format_month(year, month, today, holidays):
    """Devuelve lista de líneas con Pango markup para un mes."""
    calendar.setfirstweekday(0)  # semana empieza en lunes
    weeks = calendar.monthcalendar(year, month)

    title = f"{MONTHS_ES[month]} {year}"
    lines = [
        s(f"{title:^20}", CYAN, bold=True),
        " ".join(s(d, YELLOW, bold=True) for d in DAYS_ES),
    ]

    for week in weeks:
        cells = []
        for day in week:
            if day == 0:
                cells.append("  ")
            else:
                date = datetime.date(year, month, day)
                ds = f"{day:2d}"
                if date == today:
                    cells.append(s(ds, RED, bold=True, underline=True))
                elif date in holidays:
                    cells.append(s(ds, YELLOW, bold=True))
                else:
                    cells.append(s(ds, SOFT))
        lines.append(" ".join(cells))

    return lines


# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    today = datetime.date.today()
    now   = datetime.datetime.now()

    y1, m1 = today.year, today.month
    y2, m2 = (y1, m1 + 1) if m1 < 12 else (y1 + 1, 1)

    holidays = get_colombian_holidays(y1)
    if y2 != y1:
        holidays.update(get_colombian_holidays(y2))

    # Festivos de los dos meses (se generan primero para medir el ancho)
    shown = sorted(
        (d, n) for d, n in holidays.items()
        if (d.year == y1 and d.month == m1) or (d.year == y2 and d.month == m2)
    )

    hlines = []
    if shown:
        hlines.append(s("── Festivos ──────────────────", CYAN, bold=True))
        for date, name in shown:
            month_lbl = s(f"{MONTHS_SHORT[date.month]}", RED, bold=True)
            day_lbl   = s(f"{date.day:2d}", RED, bold=True)
            hlines.append(f"{s('★', YELLOW)} {day_lbl} {month_lbl}  {s(name, SOFT)}")

    # Ancho de referencia = línea más ancha de los festivos (mín. 20)
    ref_w = max((visible_len(l) for l in hlines), default=20)
    ref_w = max(ref_w, 20)

    # Calendarios centrados respecto al ancho de referencia
    block1 = "\n".join(center_line(l, ref_w) for l in format_month(y1, m1, today, holidays))
    block2 = "\n".join(center_line(l, ref_w) for l in format_month(y2, m2, today, holidays))

    sections = [block1, block2]
    if hlines:
        sections.append("\n".join(hlines))

    tooltip_body = "\n\n".join(sections)
    tooltip = (
        f"<span font_family='JetBrainsMono Nerd Font' size='10pt'>"
        f"{tooltip_body}"
        f"</span>"
    )

    # Texto del reloj (mismo formato que el módulo original)
    text = f"{now.strftime('%d %I:%M %p')}"

    print(json.dumps({"text": text, "tooltip": tooltip, "class": "clock"}))


if __name__ == "__main__":
    main()
