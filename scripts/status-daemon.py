#!/usr/bin/env python3
"""
Serpanplasma Status & Settings Daemon
Ultra-lightweight background daemon that queries system metrics (workspaces, media, battery, network, volume, weather, cpu, ram)
and provides real-time command execution for the Serpanplasma Top Bar, Dock, Desktop Widgets and Settings Dashboard.
"""

import datetime
import http.server
import json
import os
import shutil
import subprocess
import threading
import time
import urllib.parse

PORT = 19842
HOME = os.path.expanduser("~")
SETTINGS_FILE = os.path.join(HOME, ".config", "serpanplasma", "settings.json")

DEFAULT_SETTINGS = {
    "bar_floating": True,
    "bar_height": 38,
    "bar_opacity": 85,
    "bar_distinct_pills": True,
    "bar_mod_settings": True,
    "bar_mod_workspaces": True,
    "bar_mod_media": True,
    "bar_mod_clock": True,
    "bar_mod_weather": True,
    "bar_mod_volume": True,
    "bar_mod_network": True,
    "bar_mod_battery": True,
    "bar_mod_power": True,
    "dock_enabled": True,
    "dock_position": "bottom",
    "dock_floating": True,
    "dock_layer_top": False,
    "dock_exclusive": True,
    "dock_height": 54,
    "dock_opacity": 90,
    "hover_scale": 115,
    "cascade_scale": False,
    "scrolling": False,
    "visible_elements": 8,
    "dock_visibility": "dodgewindows",
    "smart_focus": True,
    "running_indicators": True,
    "show_all_tasks": True,
    "active_scope": "current",
    "color_scheme": "Serpanplasma-Obsidian",
    "wallpaper_slideshow": True,
    "wallpaper_interval": 900,
    "desktop_widgets": False,
    "power_profile": "performance",
    "widgets": {
        "hw": {"enabled": True, "x": 60, "y": 80},
        "clock": {"enabled": True, "x": 480, "y": 80},
        "weather": {"enabled": True, "x": 920, "y": 80},
        "music": {"enabled": True, "x": 920, "y": 420}
    }
}

THEME_PALETTES = {
    "Serpanplasma-Obsidian": {
        "name": "Obsidian",
        "bg": "#0f172a",
        "card": "#1e293b",
        "accent": "#38bdf8",
        "fg": "#f8fafc",
        "muted": "#94a3b8",
        "border": "#334155",
        "is_light": False
    },
    "Serpanplasma-Mocha": {
        "name": "Catppuccin Mocha",
        "bg": "#1e1e2e",
        "card": "#313244",
        "accent": "#89b4fa",
        "fg": "#cdd6f4",
        "muted": "#a6adc8",
        "border": "#45475a",
        "is_light": False
    },
    "Serpanplasma-Emerald": {
        "name": "Cyber Emerald",
        "bg": "#064e3b",
        "card": "#065f46",
        "accent": "#10b981",
        "fg": "#ecfdf5",
        "muted": "#6ee7b7",
        "border": "#047857",
        "is_light": False
    },
    "Serpanplasma-Amethyst": {
        "name": "Deep Amethyst",
        "bg": "#2e1065",
        "card": "#3b0764",
        "accent": "#a855f7",
        "fg": "#faf5ff",
        "muted": "#d8b4fe",
        "border": "#581c87",
        "is_light": False
    },
    "Serpanplasma-Ruby": {
        "name": "Neon Ruby",
        "bg": "#450a0a",
        "card": "#7f1d1d",
        "accent": "#f43f5e",
        "fg": "#fff1f2",
        "muted": "#fda4af",
        "border": "#991b1b",
        "is_light": False
    },
    "Serpanplasma-Porcelain": {
        "name": "Porcelain White",
        "bg": "#f8fafc",
        "card": "#e2e8f0",
        "accent": "#0284c7",
        "fg": "#0f172a",
        "muted": "#64748b",
        "border": "#cbd5e1",
        "is_light": True
    },
    "Serpanplasma-Latte": {
        "name": "Catppuccin Latte",
        "bg": "#eff1f5",
        "card": "#dce0e8",
        "accent": "#1e66f5",
        "fg": "#4c4f69",
        "muted": "#6c6f85",
        "border": "#ccd0da",
        "is_light": True
    },
    "Serpanplasma-NordSnow": {
        "name": "Nord Snow Polar",
        "bg": "#eceff4",
        "card": "#e5e9f0",
        "accent": "#5e81ac",
        "fg": "#2e3440",
        "muted": "#4c566a",
        "border": "#d8dee9",
        "is_light": True
    }
}

lock = threading.Lock()
settings = dict(DEFAULT_SETTINGS)

def load_settings():
    global settings
    try:
        if os.path.exists(SETTINGS_FILE):
            with open(SETTINGS_FILE, "r") as f:
                loaded = json.load(f)
                settings.update(loaded)
        else:
            os.makedirs(os.path.dirname(SETTINGS_FILE), exist_ok=True)
            with open(SETTINGS_FILE, "w") as f:
                json.dump(settings, f, indent=2)
    except Exception:
        pass

def save_setting(key, value):
    global settings
    with lock:
        settings[key] = value
        try:
            os.makedirs(os.path.dirname(SETTINGS_FILE), exist_ok=True)
            with open(SETTINGS_FILE, "w") as f:
                json.dump(settings, f, indent=2)
        except Exception:
            pass

load_settings()

state = {
    "media_title": "No hay nada reprc",
    "media_artist": "",
    "media_playing": False,
    "media_status": "Stopped",
    "active_popup": "",
    "battery": 100,
    "battery_str": "100%",
    "battery_charging": False,
    "battery_icon": "󰁹",
    "network": "Connected",
    "network_icon": "󰤨",
    "network_ssid": "Connected",
    "local_ip": "127.0.0.1",
    "public_ip": "Obteniendo...",
    "net_rx_rate": "0 KB/s",
    "net_tx_rate": "0 KB/s",
    "desktop": 1,
    "desktops_count": 8,
    "temp": "22.1°C",
    "weather_feels_like": "21.0°C",
    "weather_humidity": 55,
    "weather_wind": "4.0 km/h",
    "weather_icon": "󰖙",
    "weather_desc": "Despejado",
    "weather_forecast": [],
    "weather_hourly": [],
    "weather_hourly_by_day": {},
    "weather_pressure": "1013 hPa",
    "volume": 75,
    "volume_icon": "󰕾",
    "volume_muted": False,
    "audio_devices": [],
    "default_sink": "",
    "lang": "ES",
    "cpu_pct": 10,
    "ram_pct": 40,
    "ram_used_gb": 6.0,
    "ram_total_gb": 15.0,
    "disk_pct": 10,
    "disk_free_gb": 440.0,
    "uptime": "1h 0m",
    "power_profile": "performance",
    "theme_bg": "#0f172a",
    "theme_card": "#1e293b",
    "theme_accent": "#38bdf8",
    "theme_fg": "#f8fafc",
    "theme_muted": "#94a3b8",
    "theme_border": "#334155",
    "is_light": False
}

last_weather_fetch = 0
cached_weather_raw = None
prev_cpu_total = 0
prev_cpu_idle = 0

def run_cmd(args):
    try:
        res = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=1.5)
        return res.stdout.strip()
    except Exception:
        return ""

def get_gui_env():
    """Build complete GUI environment with active Wayland/X11 display and DBus for GUI child processes"""
    env = os.environ.copy()
    uid = os.getuid()
    runtime_dir = env.get("XDG_RUNTIME_DIR", f"/run/user/{uid}")
    env["XDG_RUNTIME_DIR"] = runtime_dir
    if not env.get("WAYLAND_DISPLAY"):
        for name in ["wayland-0", "wayland-1"]:
            if os.path.exists(os.path.join(runtime_dir, name)):
                env["WAYLAND_DISPLAY"] = name
                break
    if not env.get("DISPLAY"):
        for num in ["0", "1"]:
            if os.path.exists(f"/tmp/.X11-unix/X{num}"):
                env["DISPLAY"] = f":{num}"
                break
    if not env.get("DBUS_SESSION_BUS_ADDRESS"):
        env["DBUS_SESSION_BUS_ADDRESS"] = f"unix:path={runtime_dir}/bus"
    if not env.get("QT_QPA_PLATFORM"):
        env["QT_QPA_PLATFORM"] = "wayland" if env.get("WAYLAND_DISPLAY") else "xcb"
    return env

cached_apps = []
apps_last_scanned = 0

def get_installed_applications():
    """Scan and index all .desktop files on the system for Spotlight Launcher"""
    global cached_apps, apps_last_scanned
    now = time.time()
    if cached_apps and (now - apps_last_scanned < 60):
        return cached_apps

    apps = []
    seen = set()
    dirs = [
        os.path.expanduser("~/.local/share/applications"),
        "/usr/local/share/applications",
        "/usr/share/applications",
        "/var/lib/flatpak/exports/share/applications"
    ]
    for d in dirs:
        if not os.path.exists(d):
            continue
        for root, _, files in os.walk(d):
            for file in files:
                if not file.endswith(".desktop"):
                    continue
                path = os.path.join(root, file)
                try:
                    with open(path, "r", encoding="utf-8", errors="ignore") as f:
                        name, exec_cmd, icon, comment, nodisplay = "", "", "", "", False
                        in_entry = False
                        for line in f:
                            line = line.strip()
                            if line == "[Desktop Entry]":
                                in_entry = True
                            elif line.startswith("[") and in_entry:
                                break
                            elif in_entry:
                                if line.startswith("Name=") and not name:
                                    name = line[5:]
                                elif line.startswith("Exec=") and not exec_cmd:
                                    exec_cmd = line[5:].split(" %")[0]
                                elif line.startswith("Icon=") and not icon:
                                    icon = line[5:]
                                elif line.startswith("Comment=") and not comment:
                                    comment = line[8:]
                                elif line == "NoDisplay=true":
                                    nodisplay = True
                        if name and exec_cmd and not nodisplay:
                            if name.lower() not in seen:
                                seen.add(name.lower())
                                apps.append({
                                    "name": name,
                                    "exec": exec_cmd,
                                    "icon": icon if icon else "application-x-executable",
                                    "comment": comment,
                                    "id": file
                                })
                except Exception:
                    pass
    apps.sort(key=lambda x: x["name"].lower())
    cached_apps = apps
    apps_last_scanned = now
    return apps

def eval_plasma_script(js_code):
    try:
        res = subprocess.run(
            ["qdbus6", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.evaluateScript", js_code],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=2.0
        )
        return res.stdout.strip()
    except Exception:
        return ""

def ensure_virtual_desktops():
    """Ensure KWin has 8 virtual desktops configured for Serpantinum workspace navigation."""
    try:
        res = subprocess.run(
            ["qdbus6", "org.kde.KWin", "/VirtualDesktopManager", "org.kde.KWin.VirtualDesktopManager.count"],
            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=1.5
        )
        cnt = int(res.stdout.strip()) if res.stdout.strip().isdigit() else 1
        if cnt < 8:
            for i in range(cnt + 1, 9):
                subprocess.run(
                    ["qdbus6", "org.kde.KWin", "/VirtualDesktopManager", "createDesktop", str(i - 1), f"Escritorio {i}"],
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=1.0
                )
    except Exception:
        pass

def ensure_serpanplasma_dock():
    """Ensure bottom panel runs stable org.kde.plasma.icontasks"""
    try:
        eval_plasma_script('''
            var p = panels();
            for (var i = 0; i < p.length; i++) {
                if (p[i].location === "bottom" || p[i].id === 82) {
                    var ws = p[i].widgets();
                    var hasIconTasks = false;
                    for (var j = 0; j < ws.length; j++) {
                        if (ws[j].type === "org.kde.plasma.icontasks") {
                            hasIconTasks = true;
                        }
                    }
                    if (!hasIconTasks) {
                        for (var j = 0; j < ws.length; j++) {
                            ws[j].remove();
                        }
                        p[i].height = settings.get("dock_height", 54);
                        p[i].floating = true;
                        p[i].alignment = "center";
                        p[i].lengthMode = "fit";
                        var t = p[i].addWidget("org.kde.plasma.icontasks");
                        t.currentConfigGroup = ["General"];
                        t.writeConfig("launchers", [
                            "applications:org.serpanplasma.spotlight.desktop",
                            "applications:org.kde.dolphin.desktop",
                            "preferred://browser",
                            "applications:org.kde.konsole.desktop",
                            "applications:discord.desktop",
                            "applications:spotify-launcher.desktop",
                            "applications:systemsettings.desktop"
                        ]);
                    }
                }
            }
        ''')
    except Exception:
        pass

def update_weather():
    global last_weather_fetch, cached_weather_raw, state
    now = time.time()
    if now - last_weather_fetch >= 600 or cached_weather_raw is None:
        try:
            import urllib.request
            url = "https://api.open-meteo.com/v1/forecast?latitude=40.4168&longitude=-3.7038&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m,surface_pressure&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=7"
            req = urllib.request.Request(url, headers={'User-Agent': 'Serpanplasma/1.0'})
            with urllib.request.urlopen(req, timeout=4.5) as resp:
                cached_weather_raw = json.loads(resp.read().decode())
                last_weather_fetch = now
        except Exception:
            pass

    if not cached_weather_raw:
        return

    try:
        data = cached_weather_raw
        cur = data.get("current", {})
        daily = data.get("daily", {})
        hourly = data.get("hourly", {})
        temp = cur.get("temperature_2m")
        feels = cur.get("apparent_temperature", temp)
        hum = cur.get("relative_humidity_2m", 50)
        wind = cur.get("wind_speed_10m", 0)
        pressure = round(cur.get("surface_pressure", 1013))
        code = cur.get("weather_code", 0)

        code_map = {
            0: ("󰖙", "Despejado"),
            1: ("󰖙", "Mayormente despejado"),
            2: ("☁", "Parcialmente nublado"),
            3: ("☁", "Nublado"),
            45: ("󰖑", "Niebla"),
            48: ("󰖑", "Niebla con escarcha"),
            51: ("󰖖", "Llovizna ligera"),
            53: ("󰖖", "Llovizna moderada"),
            55: ("󰖖", "Llovizna densa"),
            61: ("󰖖", "Lluvia ligera"),
            63: ("󰖖", "Lluvia moderada"),
            65: ("󰖖", "Lluvia fuerte"),
            71: ("󰼶", "Nevada ligera"),
            73: ("󰼶", "Nevada moderada"),
            75: ("󰼶", "Nevada fuerte"),
            95: ("󰖓", "Tormenta eléctrica")
        }

        icon, desc = code_map.get(code, ("☁", "Variable"))

        # Build 4-day forecast
        forecast = []
        day_names = ["Hoy", "Mañana", "Sábado", "Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes"]
        max_list = daily.get("temperature_2m_max", [])
        min_list = daily.get("temperature_2m_min", [])
        code_list = daily.get("weather_code", [])

        for idx in range(min(4, len(max_list))):
            d_code = code_list[idx] if idx < len(code_list) else 0
            d_icon, _ = code_map.get(d_code, ("☁", ""))
            d_name = day_names[idx] if idx < len(day_names) else f"+{idx}d"
            forecast.append({
                "day": d_name,
                "icon": d_icon,
                "max": f"{round(max_list[idx])}°",
                "min": f"{round(min_list[idx])}°"
            })

        h_times = hourly.get("time", [])
        h_temps = hourly.get("temperature_2m", [])
        h_codes = hourly.get("weather_code", [])
        h_pops = hourly.get("precipitation_probability", [])

        cur_hour = datetime.datetime.now().hour

        # Next upcoming 24 hours starting from cur_hour (for desktop widget 5 pills)
        next_24h = []
        for i in range(cur_hour, min(cur_hour + 24, len(h_times))):
            raw_t = h_times[i]
            hh = raw_t.split("T")[-1] if "T" in raw_t else raw_t
            h_code = h_codes[i] if i < len(h_codes) else 0
            h_icon, _ = code_map.get(h_code, ("☁", ""))
            h_temp = f"{round(h_temps[i])}°" if i < len(h_temps) else ""
            h_pop = f"{h_pops[i]}%" if i < len(h_pops) else "0%"
            next_24h.append({
                "time": hh,
                "temp": h_temp,
                "icon": h_icon,
                "pop": h_pop
            })

        # Group hourly forecast by day
        # Day 0 ("Hoy"): starts at current hour up to end of today (24:00)
        # Other days ("Mañana", +2d, +3d): start at 00:00 (full 24h)
        hourly_by_day = {}
        for day_idx in range(4):
            day_hours = []
            if day_idx == 0:
                start_h = cur_hour
                end_h = 24
            else:
                start_h = day_idx * 24
                end_h = start_h + 24

            for i in range(start_h, min(end_h, len(h_times))):
                raw_t = h_times[i]
                hh = raw_t.split("T")[-1] if "T" in raw_t else raw_t
                h_code = h_codes[i] if i < len(h_codes) else 0
                h_icon, _ = code_map.get(h_code, ("☁", ""))
                h_temp = f"{round(h_temps[i])}°" if i < len(h_temps) else ""
                h_pop = f"{h_pops[i]}%" if i < len(h_pops) else "0%"
                day_hours.append({
                    "time": hh,
                    "temp": h_temp,
                    "icon": h_icon,
                    "pop": h_pop
                })
            hourly_by_day[str(day_idx)] = day_hours

        with lock:
            if temp is not None:
                state["temp"] = f"{temp:.1f}°C"
                state["weather_feels_like"] = f"{feels:.1f}°C"
                state["weather_humidity"] = hum
                state["weather_wind"] = f"{wind:.1f} km/h"
                state["weather_pressure"] = f"{pressure} hPa"
                state["weather_icon"] = icon
                state["weather_desc"] = desc
                state["weather_forecast"] = forecast
                state["weather_hourly"] = next_24h
                state["weather_hourly_by_day"] = hourly_by_day
    except Exception:
        pass

def update_media():
    global state
    m_status = run_cmd(["playerctl", "status"])
    if m_status in ("Playing", "Paused"):
        info = run_cmd(["playerctl", "metadata", "--format", "{{title}}:::{{artist}}"])
        parts = info.split(":::", 1)
        title = parts[0] if len(parts) > 0 and parts[0] else "Unknown Track"
        artist = parts[1] if len(parts) > 1 and parts[1] else ""
        with lock:
            state["media_playing"] = (m_status == "Playing")
            state["media_status"] = m_status
            state["media_title"] = title
            state["media_artist"] = artist
    else:
        with lock:
            state["media_playing"] = False
            state["media_status"] = "Stopped"
            state["media_title"] = "No hay nada reprc"
            state["media_artist"] = ""

def update_battery():
    global state
    bat_dirs = [d for d in os.listdir("/sys/class/power_supply") if d.startswith("BAT")] if os.path.exists("/sys/class/power_supply") else []
    if bat_dirs:
        b_dir = os.path.join("/sys/class/power_supply", bat_dirs[0])
        try:
            with open(os.path.join(b_dir, "capacity"), "r") as f:
                cap = int(f.read().strip())
            with open(os.path.join(b_dir, "status"), "r") as f:
                b_stat = f.read().strip()
            charging = (b_stat == "Charging")
            icons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
            idx = min(max(int(cap / 10) - 1, 0), 9)
            icon = "󰂄" if charging else icons[idx]
            with lock:
                state["battery"] = cap
                state["battery_str"] = f"{cap}%"
                state["battery_charging"] = charging
                state["battery_icon"] = icon
        except Exception:
            pass

def update_network():
    global state
    ssid = run_cmd(["bash", "-c", "nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -n 1"])
    ip = run_cmd(["bash", "-c", "ip -4 addr show scope global 2>/dev/null | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n 1"])
    if not ip:
        ip = "127.0.0.1"

    if not ssid:
        eth = run_cmd(["bash", "-c", "cat /sys/class/net/e*/operstate 2>/dev/null | grep up | head -n 1"])
        if eth:
            with lock:
                state["network"] = "Connected"
                state["network_ssid"] = "Ethernet"
                state["network_icon"] = "󰈀"
                state["local_ip"] = ip
            return
        gw = run_cmd(["bash", "-c", "ip route show default 2>/dev/null | head -n 1"])
        if gw:
            with lock:
                state["network"] = "Connected"
                state["network_ssid"] = "Connected"
                state["network_icon"] = "󰤨"
                state["local_ip"] = ip
        else:
            with lock:
                state["network"] = "Disconnected"
                state["network_ssid"] = "Disconnected"
                state["network_icon"] = "󰤭"
                state["local_ip"] = ip
    else:
        with lock:
            state["network"] = "Connected"
            state["network_ssid"] = ssid if ssid else "Connected"
            state["network_icon"] = "󰤨"
            state["local_ip"] = ip

def update_workspaces():
    global state
    cur = run_cmd(["qdbus6", "org.kde.KWin", "/KWin", "org.kde.KWin.currentDesktop"])
    try:
        cur_int = int(cur) if cur else 1
    except ValueError:
        cur_int = 1
    with lock:
        state["desktop"] = cur_int
        state["desktops_count"] = 8

def update_volume():
    global state
    wp = run_cmd(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"])
    if wp:
        parts = wp.split()
        if len(parts) >= 2:
            try:
                vol = int(float(parts[1]) * 100)
                muted = "[MUTED]" in wp
                icon = "󰝟" if muted else ("󰕾" if vol > 50 else ("󰖀" if vol > 0 else "󰕿"))
                with lock:
                    state["volume"] = vol
                    state["volume_muted"] = muted
                    state["volume_icon"] = icon
            except Exception:
                pass

def update_system_metrics():
    global state, prev_cpu_total, prev_cpu_idle
    # CPU
    try:
        with open("/proc/stat") as f:
            cpu_line = f.readline().split()[1:]
            vals = [float(x) for x in cpu_line]
            idle = vals[3] + vals[4]
            total = sum(vals)
            diff_idle = idle - prev_cpu_idle
            diff_total = total - prev_cpu_total
            prev_cpu_idle = idle
            prev_cpu_total = total
            cpu_pct = int(100.0 * (1.0 - (diff_idle / diff_total))) if diff_total > 0 else 5
            cpu_pct = max(0, min(100, cpu_pct))
    except Exception:
        cpu_pct = 5

    # RAM
    try:
        with open("/proc/meminfo") as f:
            lines = dict(l.split(":") for l in f.readlines())
        total_kb = int(lines["MemTotal"].split()[0])
        avail_kb = int(lines["MemAvailable"].split()[0])
        used_kb = total_kb - avail_kb
        ram_pct = int((used_kb / total_kb) * 100)
        ram_used = round(used_kb / (1024 * 1024), 1)
        ram_total = round(total_kb / (1024 * 1024), 1)
    except Exception:
        ram_pct, ram_used, ram_total = 30, 4.0, 16.0

    # Disk
    try:
        du = shutil.disk_usage("/")
        disk_pct = int((du.used / du.total) * 100)
        disk_free = round(du.free / (1024**3), 1)
    except Exception:
        disk_pct, disk_free = 10, 400.0

    # Uptime
    try:
        with open("/proc/uptime") as f:
            up_secs = int(float(f.readline().split()[0]))
            hours = up_secs // 3600
            mins = (up_secs % 3600) // 60
            uptime_str = f"{hours}h {mins}m"
    except Exception:
        uptime_str = "1h"

    # Power profile
    prof = run_cmd(["powerprofilesctl", "get"])
    if not prof:
        prof = settings.get("power_profile", "performance")

    with lock:
        state["cpu_pct"] = cpu_pct
        state["ram_pct"] = ram_pct
        state["ram_used_gb"] = ram_used
        state["ram_total_gb"] = ram_total
        state["disk_pct"] = disk_pct
        state["disk_free_gb"] = disk_free
        state["uptime"] = uptime_str
        state["power_profile"] = prof

prev_net_rx = 0
prev_net_tx = 0
prev_net_time = 0

def update_network_stats():
    global prev_net_rx, prev_net_tx, prev_net_time, state
    now = time.time()
    try:
        rx_total = 0
        tx_total = 0
        with open("/proc/net/dev", "r") as f:
            lines = f.readlines()[2:]
            for line in lines:
                parts = line.split()
                if len(parts) >= 10:
                    iface = parts[0].strip(":")
                    if iface != "lo":
                        rx_total += int(parts[1])
                        tx_total += int(parts[9])
        if prev_net_time > 0:
            dt = max(0.1, now - prev_net_time)
            rx_speed = (rx_total - prev_net_rx) / dt
            tx_speed = (tx_total - prev_net_tx) / dt

            def fmt_speed(bps):
                if bps < 1024:
                    return f"{int(bps)} B/s"
                elif bps < 1024 * 1024:
                    return f"{bps / 1024:.1f} KB/s"
                else:
                    return f"{bps / (1024 * 1024):.1f} MB/s"

            with lock:
                state["net_rx_rate"] = fmt_speed(max(0, rx_speed))
                state["net_tx_rate"] = fmt_speed(max(0, tx_speed))
        prev_net_rx = rx_total
        prev_net_tx = tx_total
        prev_net_time = now
    except Exception:
        pass

last_public_ip_fetch = 0

def update_public_ip():
    global last_public_ip_fetch, state
    now = time.time()
    if now - last_public_ip_fetch < 300 and last_public_ip_fetch != 0:
        return
    last_public_ip_fetch = now
    try:
        req = urllib.request.Request("https://api.ipify.org", headers={"User-Agent": "Serpanplasma"})
        with urllib.request.urlopen(req, timeout=2.5) as resp:
            ip = resp.read().decode("utf-8").strip()
            if ip:
                with lock:
                    state["public_ip"] = ip
    except Exception:
        pass

def update_audio_devices():
    global state
    try:
        default_sink = run_cmd(["pactl", "get-default-sink"])
        res = subprocess.run(["pactl", "-f", "json", "list", "sinks"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=1.5)
        if res.stdout:
            sinks = json.loads(res.stdout)
            devices = []
            for s in sinks:
                name = s.get("name", "")
                desc = s.get("properties", {}).get("device.description") or s.get("description", "")
                if not desc or desc == "(null)":
                    desc = s.get("properties", {}).get("node.nick") or name
                if "Headset" in desc or "G733" in desc or "Headphone" in desc or "headset" in name.lower():
                    icon = "󰋋"
                    if "G733" in desc:
                        desc = "Logitech G733 Gaming Headset"
                elif "Speaker" in desc or "Speaker" in name:
                    icon = "󰓃"
                    desc = "Altavoces Internos (HP Victus)"
                elif "HDMI" in name:
                    icon = "󰍹"
                    desc = "Monitor LG UltraGear (HDMI)" if "LG" in desc else "Salida Digital HDMI"
                else:
                    icon = "󰕾"
                is_active = (name == default_sink)
                devices.append({
                    "name": name,
                    "desc": desc,
                    "icon": icon,
                    "active": is_active
                })
            with lock:
                state["audio_devices"] = devices
                state["default_sink"] = default_sink
    except Exception:
        pass

def update_lang():
    global state
    try:
        res = subprocess.run(["qdbus6", "org.kde.keyboard", "/Layouts", "org.kde.KeyboardLayouts.getLayout"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=0.5)
        out = res.stdout.strip()
        if out.isdigit():
            idx = int(out)
            with lock:
                state["lang"] = "ES" if idx == 0 else "US"
            return
    except Exception:
        pass
    with lock:
        if not state.get("lang"):
            state["lang"] = "ES"

def ensure_kwin_widget_rules():
    """Ensure KWin rules exist to hide Serpanplasma desktop widgets from taskbar, alt-tab switcher and pager"""
    try:
        home = os.path.expanduser("~")
        kwinrules_path = os.path.join(home, ".config/kwinrulesrc")
        rule_content = """[General]
count=1
rules=SerpanplasmaWidgets

[SerpanplasmaWidgets]
description=Serpanplasma Desktop Widgets
wmclass=qml6
wmclasscomplete=false
wmclassmatch=1
title=Serpanplasma
titlematch=2
skiptaskbar=true
skiptaskbarrule=2
skippager=true
skippagerrule=2
skipswitcher=true
skipswitcherrule=2
below=true
belowrule=2
acceptfocus=false
acceptfocusrule=2
"""
        with open(kwinrules_path, "w") as f:
            f.write(rule_content)
        subprocess.run(["qdbus6", "org.kde.KWin", "/KWin", "reconfigure"], env=get_gui_env(), timeout=2.0)
    except Exception:
        pass

def hide_widgets_from_taskbar():
    """Apply skip_taskbar, skip_pager, skip_switcher, below and desktop window type to Serpanplasma widget windows"""
    try:
        env = get_gui_env()
        widgets = [
            "Serpanplasma Hardware Widget",
            "Serpanplasma Clock Widget",
            "Serpanplasma Weather Widget",
            "Serpanplasma Music Widget"
        ]
        for w in widgets:
            subprocess.run(["xprop", "-name", w, "-f", "_NET_WM_WINDOW_TYPE", "32a", "-set", "_NET_WM_WINDOW_TYPE", "_NET_WM_WINDOW_TYPE_DESKTOP"], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=0.5)
            subprocess.run(["xprop", "-name", w, "-f", "_NET_WM_STATE", "32a", "-set", "_NET_WM_STATE", "_NET_WM_STATE_BELOW, _NET_WM_STATE_SKIP_TASKBAR, _NET_WM_STATE_SKIP_PAGER"], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=0.5)
            subprocess.run(["wmctrl", "-r", w, "-b", "add,skip_taskbar,skip_pager"], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=0.5)
            subprocess.run(["wmctrl", "-r", w, "-b", "add,below"], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=0.5)
    except Exception:
        pass

def spawn_desktop_widgets():
    """Start desktop widgets with environment and ensure hidden from taskbar"""
    home = os.path.expanduser("~")
    w_path = os.path.join(home, ".local/share/serpanplasma/widgets/DesktopWidgets.qml")
    if not os.path.exists(w_path):
        return
    ensure_kwin_widget_rules()
    w_env = get_gui_env()
    w_env["QT_QPA_PLATFORM"] = "xcb"
    subprocess.Popen(["qml6", w_path], env=w_env)
    def _delayed_hide():
        for delay in [0.2, 0.4, 0.8, 1.5, 3.0]:
            time.sleep(delay)
            hide_widgets_from_taskbar()
    threading.Thread(target=_delayed_hide, daemon=True).start()

def background_poller():
    ensure_virtual_desktops()
    ensure_serpanplasma_dock()
    ensure_kwin_widget_rules()
    try:
        subprocess.run(["kwriteconfig6", "--file", "kxkbrc", "--group", "Layout", "--key", "LayoutList", "es,us", "--notify"], timeout=1.0)
    except Exception:
        pass

    loop_count = 0
    while True:
        try:
            loop_count += 1
            if loop_count % 6 == 0:
                if settings.get("desktop_widgets", False):
                    check = subprocess.run(["pgrep", "-f", "[D]esktopWidgets.qml"], stdout=subprocess.PIPE, text=True)
                    if not check.stdout.strip():
                        spawn_desktop_widgets()
            if loop_count % 4 == 0 and settings.get("desktop_widgets", False):
                hide_widgets_from_taskbar()
            update_weather()
            update_media()
            update_battery()
            update_network()
            update_network_stats()
            update_public_ip()
            update_audio_devices()
            update_workspaces()
            update_volume()
            update_system_metrics()
            update_lang()
        except Exception:
            pass
        time.sleep(0.5)

class HTTPRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        params = urllib.parse.parse_qs(parsed.query)

        if path == "/status" or path == "/":
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            with lock:
                combined = dict(state)
                combined.update(settings)
                active_theme = settings.get("color_scheme", "Serpanplasma-Obsidian")
                pal = THEME_PALETTES.get(active_theme, THEME_PALETTES["Serpanplasma-Obsidian"])
                combined["theme_name"] = pal["name"]
                combined["theme_bg"] = pal["bg"]
                combined["theme_card"] = pal["card"]
                combined["theme_accent"] = pal["accent"]
                combined["theme_fg"] = pal["fg"]
                combined["theme_muted"] = pal["muted"]
                combined["theme_border"] = pal["border"]
                combined["is_light"] = pal["is_light"]
                if "widgets" not in combined:
                    combined["widgets"] = DEFAULT_SETTINGS["widgets"]
                payload = json.dumps(combined).encode("utf-8")
            self.wfile.write(payload)

        elif path == "/apps":
            apps = get_installed_applications()
            query = params.get("q", [""])[0].strip().lower()
            if query:
                filtered = [a for a in apps if query in a["name"].lower() or query in a.get("comment", "").lower() or query in a.get("exec", "").lower()]
            else:
                filtered = apps
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(json.dumps(filtered[:40]).encode("utf-8"))

        elif path == "/cmd":
            action = params.get("action", [""])[0]
            val = params.get("val", [""])[0]
            mod = params.get("mod", [""])[0]
            home = os.path.expanduser("~")

            # --- System Controls ---
            if action == "settings":
                qml_path = os.path.join(home, ".local/share/serpanplasma/guide/SettingsWindow.qml")
                check = subprocess.run(["pgrep", "-f", "[S]ettingsWindow.qml"], stdout=subprocess.PIPE, text=True)
                if check.stdout.strip():
                    subprocess.run(["pkill", "-f", "[S]ettingsWindow.qml"])
                    time.sleep(0.15)
                subprocess.Popen(["qml6", qml_path], env=get_gui_env())

            elif action == "toggle_spotlight":
                spot_path = os.path.join(home, ".local/share/serpanplasma/launcher/SpotlightLauncher.qml")
                check = subprocess.run(["pgrep", "-f", "[S]potlightLauncher.qml"], stdout=subprocess.PIPE, text=True)
                if check.stdout.strip():
                    subprocess.run(["pkill", "-f", "[S]potlightLauncher.qml"])
                else:
                    subprocess.Popen(["qml6", spot_path], env=get_gui_env())

            elif action == "launch_app" and val:
                subprocess.Popen(val, shell=True, env=get_gui_env())

            elif action == "ensure_dock":
                ensure_serpanplasma_dock()

            elif action == "play-pause":
                subprocess.Popen(["playerctl", "play-pause"])
            elif action == "previous":
                subprocess.Popen(["playerctl", "previous"])
            elif action == "next":
                subprocess.Popen(["playerctl", "next"])
            elif action == "desktop" and val:
                try:
                    d_int = int(val)
                    with lock:
                        state["desktop"] = d_int
                    subprocess.Popen(["qdbus6", "org.kde.KWin", "/KWin", "org.kde.KWin.setCurrentDesktop", str(d_int)])
                except Exception:
                    pass
            elif action == "ensure_desktops":
                ensure_virtual_desktops()
            elif action == "launcher":
                subprocess.Popen(["qdbus6", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.activateApplicationMenu"])
            elif action == "power":
                subprocess.Popen(["qdbus6", "org.kde.LogoutPrompt", "/LogoutPrompt", "promptShutDown"])
            elif action == "vol_up":
                subprocess.Popen(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"])
            elif action == "vol_down":
                subprocess.Popen(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
            elif action == "vol_set" and val:
                try:
                    pct = float(val) / 100.0
                    subprocess.Popen(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", f"{pct:.2f}"])
                except Exception:
                    pass
            elif action == "vol_mute":
                subprocess.Popen(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])

            # --- POWER PROFILE ---
            elif action == "set_power_profile" and val:
                subprocess.run(["powerprofilesctl", "set", val])
                save_setting("power_profile", val)
                with lock:
                    state["power_profile"] = val

            # --- DOCK CONTROLS ---
            elif action == "set_dock_floating":
                is_float = (val.lower() in ("true", "1", "yes"))
                js_val = "true" if is_float else "false"
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 82 || p[i].location === "bottom" || p[i].location === "left" || p[i].location === "right" || (p[i].height > 45 && p[i].location !== "top")) {{
                            p[i].floating = {js_val};
                        }}
                    }}
                ''')
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "82", "--key", "floating", "--type", "bool", js_val])
                save_setting("dock_floating", is_float)

            elif action == "set_dock_enabled":
                is_en = (val.lower() in ("true", "1", "yes"))
                hiding_val = settings.get("dock_visibility", "dodgewindows") if is_en else "autohide"
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 82 || p[i].location === "bottom" || (p[i].height > 45 && p[i].location !== "top")) {{
                            p[i].hiding = "{hiding_val}";
                        }}
                    }}
                ''')
                save_setting("dock_enabled", is_en)

            elif action == "set_dock_position" and val:
                loc = val.lower()
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 82 || p[i].location === "bottom" || p[i].location === "left" || p[i].location === "right") {{
                            if (p[i].location !== "top") {{
                                p[i].location = "{loc}";
                            }}
                        }}
                    }}
                ''')
                loc_id = "4" if loc == "bottom" else ("1" if loc == "left" else "2")
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "82", "--key", "location", loc_id])
                save_setting("dock_position", loc)

            elif action == "set_dock_visibility" and val:
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 82 || p[i].location === "bottom" || (p[i].height > 45 && p[i].location !== "top")) {{
                            p[i].hiding = "{val}";
                        }}
                    }}
                ''')
                p_vis = 2 if val == "dodgewindows" else (1 if val == "autohide" else (3 if val == "windowscover" else 0))
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "82", "--key", "panelVisibility", str(p_vis)])
                save_setting("dock_visibility", val)

            elif action == "set_dock_layer":
                is_top = (val.lower() in ("true", "1", "yes"))
                hiding_val = "none" if is_top else settings.get("dock_visibility", "dodgewindows")
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 82 || p[i].location === "bottom" || (p[i].height > 45 && p[i].location !== "top")) {{
                            p[i].hiding = "{hiding_val}";
                        }}
                    }}
                ''')
                p_vis = 0 if is_top else (2 if settings.get("dock_visibility", "dodgewindows") == "dodgewindows" else 1)
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "82", "--key", "panelVisibility", str(p_vis)])
                save_setting("dock_layer_top", is_top)

            elif action == "set_dock_exclusive":
                is_excl = (val.lower() in ("true", "1", "yes"))
                save_setting("dock_exclusive", is_excl)

            elif action == "set_dock_height" and val:
                try:
                    h = int(val)
                    eval_plasma_script(f'''
                        var p = panels();
                        for (var i = 0; i < p.length; i++) {{
                            if (p[i].id === 82 || p[i].location === "bottom" || (p[i].height > 45 && p[i].location !== "top")) {{
                                p[i].height = {h};
                            }}
                        }}
                    ''')
                    subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "82", "--key", "height", str(h)])
                    save_setting("dock_height", h)
                except Exception:
                    pass

            elif action == "set_dock_opacity" and val:
                try:
                    save_setting("dock_opacity", int(val))
                except Exception:
                    pass

            elif action == "set_hover_scale" and val:
                try:
                    save_setting("hover_scale", int(val))
                except Exception:
                    pass

            elif action == "set_cascade_scale":
                save_setting("cascade_scale", val.lower() in ("true", "1", "yes"))

            elif action == "set_scrolling":
                save_setting("scrolling", val.lower() in ("true", "1", "yes"))

            elif action == "set_visible_elements" and val:
                try:
                    save_setting("visible_elements", int(val))
                except Exception:
                    pass

            elif action == "set_dock_smart_focus":
                save_setting("smart_focus", val.lower() in ("true", "1", "yes"))

            elif action == "set_dock_indicators":
                save_setting("running_indicators", val.lower() in ("true", "1", "yes"))

            elif action == "set_dock_tasks":
                save_setting("show_all_tasks", val.lower() in ("true", "1", "yes"))

            elif action == "set_dock_scope" and val:
                save_setting("active_scope", val)
                show_only = "true" if val == "current" else "false"
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "82", "--group", "Applets", "--group", "83", "--group", "Configuration", "--group", "General", "--key", "showOnlyCurrentDesktop", "--type", "bool", show_only])

            # --- TOP BAR CONTROLS ---
            elif action == "set_bar_floating":
                is_float = (val.lower() in ("true", "1", "yes"))
                js_val = "true" if is_float else "false"
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 55 || p[i].location === "top" || p[i].height <= 45) {{
                            p[i].floating = {js_val};
                            if (!{js_val}) {{
                                p[i].lengthMode = "fill";
                            }}
                        }}
                    }}
                ''')
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "55", "--key", "floating", "--type", "bool", js_val])
                save_setting("bar_floating", is_float)

            elif action == "set_distinct_pills":
                is_pills = (val.lower() in ("true", "1", "yes"))
                # When distinct pills is false (unified), set top panel lengthMode="fill" and floating=false so it spans 100% of the display edge-to-edge!
                if not is_pills:
                    eval_plasma_script('''
                        var p = panels();
                        for (var i = 0; i < p.length; i++) {
                            if (p[i].id === 55 || p[i].location === "top" || p[i].height <= 45) {
                                p[i].floating = false;
                                p[i].lengthMode = "fill";
                            }
                        }
                    ''')
                    subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "55", "--key", "floating", "--type", "bool", "false"])
                else:
                    eval_plasma_script('''
                        var p = panels();
                        for (var i = 0; i < p.length; i++) {
                            if (p[i].id === 55 || p[i].location === "top" || p[i].height <= 45) {
                                p[i].floating = true;
                            }
                        }
                    ''')
                    subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "55", "--key", "floating", "--type", "bool", "true"])
                save_setting("bar_distinct_pills", is_pills)

            elif action == "set_bar_height" and val:
                try:
                    h = int(val)
                    eval_plasma_script(f'''
                        var p = panels();
                        for (var i = 0; i < p.length; i++) {{
                            if (p[i].id === 55 || p[i].location === "top" || p[i].height <= 45) {{
                                p[i].height = {h};
                            }}
                        }}
                    ''')
                    subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "55", "--key", "height", str(h)])
                    save_setting("bar_height", h)
                except Exception:
                    pass

            elif action == "set_bar_opacity" and val:
                try:
                    save_setting("bar_opacity", int(val))
                except Exception:
                    pass

            elif action == "set_bar_module" and mod:
                is_on = (val.lower() in ("true", "1", "yes"))
                save_setting(f"bar_mod_{mod}", is_on)

            # --- WALLPAPERS & THEMES ---
            elif action == "set_wallpaper_slideshow":
                is_slide = (val.lower() in ("true", "1", "yes"))
                plugin = "org.kde.slideshow" if is_slide else "org.kde.image"
                eval_plasma_script(f'''
                    var ds = desktops();
                    for (var i = 0; i < ds.length; i++) {{
                        ds[i].wallpaperPlugin = "{plugin}";
                    }}
                ''')
                save_setting("wallpaper_slideshow", is_slide)

            elif action == "freeze_wallpaper":
                eval_plasma_script('''
                    var ds = desktops();
                    for (var i = 0; i < ds.length; i++) {
                        ds[i].wallpaperPlugin = "org.kde.image";
                    }
                ''')
                save_setting("wallpaper_slideshow", False)

            elif action == "next_wallpaper":
                eval_plasma_script('''
                    var ds = desktops();
                    for (var i = 0; i < ds.length; i++) {
                        ds[i].currentConfigGroup = ["Wallpaper", "org.kde.slideshow", "General"];
                        var paths = ds[i].readConfig("SlidePaths");
                        ds[i].writeConfig("SlidePaths", paths);
                    }
                ''')

            elif action == "open_wallpapers":
                wp_dir = os.path.join(home, "Imágenes", "Wallpapers")
                subprocess.Popen(["xdg-open", wp_dir])

            elif action == "set_wallpaper_interval" and val:
                try:
                    sec = int(val)
                    save_setting("wallpaper_interval", sec)
                    eval_plasma_script(f'''
                        var ds = desktops();
                        for (var i = 0; i < ds.length; i++) {{
                            ds[i].currentConfigGroup = ["Wallpaper", "org.kde.slideshow", "General"];
                            ds[i].writeConfig("SlideInterval", {sec});
                        }}
                    ''')
                except Exception:
                    pass

            elif action == "apply_colorscheme" and val:
                subprocess.run(["plasma-apply-colorscheme", val])
                save_setting("color_scheme", val)
                if val in THEME_PALETTES:
                    pal = THEME_PALETTES[val]
                    with lock:
                        state["theme_bg"] = pal["bg"]
                        state["theme_card"] = pal["card"]
                        state["theme_accent"] = pal["accent"]
                        state["theme_fg"] = pal["fg"]
                        state["theme_muted"] = pal["muted"]
                        state["theme_border"] = pal["border"]
                        state["is_light"] = pal["is_light"]

            # --- POWER ACTIONS ---
            elif action == "power_action" and val:
                if val == "shutdown":
                    subprocess.Popen(["qdbus6", "org.kde.Shutdown", "/Shutdown", "logoutAndShutdown"])
                elif val == "reboot":
                    subprocess.Popen(["qdbus6", "org.kde.Shutdown", "/Shutdown", "logoutAndReboot"])
                elif val == "logout":
                    subprocess.Popen(["qdbus6", "org.kde.Shutdown", "/Shutdown", "logout"])
                elif val == "lock":
                    subprocess.Popen(["loginctl", "lock-session"])
                elif val == "suspend":
                    subprocess.Popen(["systemctl", "suspend"])

            # --- AUDIO DEVICE SWITCHER ---
            elif action == "set_audio_device" and val:
                subprocess.run(["pactl", "set-default-sink", val])
                update_audio_devices()

            # --- KEYBOARD LAYOUT TOGGLE ---
            elif action == "toggle_layout":
                cur = state.get("lang", "ES")
                nxt = "US" if cur == "ES" else "ES"
                nxt_idx = "1" if cur == "ES" else "0"
                with lock:
                    state["lang"] = nxt
                save_setting("lang", nxt)
                subprocess.run(["kwriteconfig6", "--file", "kxkbrc", "--group", "Layout", "--key", "LayoutList", "es,us", "--notify"], timeout=1.0)
                subprocess.run(["qdbus6", "org.kde.keyboard", "/Layouts", "org.kde.KeyboardLayouts.setLayout", nxt_idx], timeout=1.0)
                subprocess.Popen(["setxkbmap", "-layout", nxt.lower()])

            # --- INDIVIDUAL DESKTOP WIDGETS ---
            elif action == "set_widget_enabled":
                w_name = mod if mod else params.get("widget", ["hw"])[0]
                is_en = (val.lower() == "true")
                widgets = settings.get("widgets", dict(DEFAULT_SETTINGS["widgets"]))
                if w_name in widgets:
                    widgets[w_name]["enabled"] = is_en
                else:
                    widgets[w_name] = {"enabled": is_en, "x": 100, "y": 100}
                save_setting("widgets", widgets)

            elif action == "set_widget_pos":
                w_name = mod if mod else params.get("widget", ["hw"])[0]
                try:
                    if val and "," in val:
                        parts = val.split(",")
                        x_pos = int(float(parts[0]))
                        y_pos = int(float(parts[1]))
                    else:
                        x_pos = int(params.get("x", [100])[0])
                        y_pos = int(params.get("y", [100])[0])
                    widgets = settings.get("widgets", dict(DEFAULT_SETTINGS["widgets"]))
                    if w_name in widgets:
                        widgets[w_name]["x"] = x_pos
                        widgets[w_name]["y"] = y_pos
                    else:
                        widgets[w_name] = {"enabled": True, "x": x_pos, "y": y_pos}
                    save_setting("widgets", widgets)
                except Exception:
                    pass

            elif action == "reset_widget_pos":
                save_setting("widgets", dict(DEFAULT_SETTINGS["widgets"]))
                subprocess.run(["pkill", "-f", "[D]esktopWidgets.qml"])
                time.sleep(0.2)
                if settings.get("desktop_widgets", False):
                    spawn_desktop_widgets()

            # --- DESKTOP WIDGETS RUNNER ---
            elif action == "toggle_desktop_widgets":
                check = subprocess.run(["pgrep", "-f", "[D]esktopWidgets.qml"], stdout=subprocess.PIPE, text=True)
                is_running = bool(check.stdout.strip())
                should_run = (not is_running) if not val else (val.lower() == "true")
                if is_running and not should_run:
                    subprocess.run(["pkill", "-f", "[D]esktopWidgets.qml"])
                    save_setting("desktop_widgets", False)
                elif should_run:
                    if is_running:
                        subprocess.run(["pkill", "-f", "[D]esktopWidgets.qml"])
                        time.sleep(0.2)
                    spawn_desktop_widgets()
                    save_setting("desktop_widgets", True)

            elif action == "restart_kwin":
                subprocess.run(["qdbus6", "org.kde.KWin", "/KWin", "reconfigure"])

            elif action == "restart_plasma":
                subprocess.run(["systemctl", "--user", "restart", "plasma-plasmashell.service"])

            elif action == "restart_daemon":
                subprocess.Popen(["systemctl", "--user", "restart", "serpanplasma-daemon.service"])

            elif action == "open_url" and val:
                subprocess.Popen(["xdg-open", val])

            elif action == "set_popup":
                with lock:
                    state["active_popup"] = val

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(b'{"status":"ok"}')

        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, *args):
        pass

def main():
    ensure_virtual_desktops()
    poller = threading.Thread(target=background_poller, daemon=True)
    poller.start()

    server = http.server.ThreadingHTTPServer(("127.0.0.1", PORT), HTTPRequestHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()

if __name__ == "__main__":
    main()
