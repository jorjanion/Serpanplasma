#!/usr/bin/env python3
"""
Serpanplasma Status & Settings Daemon
Ultra-lightweight background daemon that queries system metrics (workspaces, media, battery, network, volume, weather)
and provides real-time command execution for the Serpanplasma Top Bar, Dock and Settings Dashboard.
"""

import http.server
import json
import os
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
    "wallpaper_interval": 900
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
    "battery": 100,
    "battery_str": "100%",
    "battery_charging": False,
    "battery_icon": "󰁹",
    "network": "Connected",
    "network_icon": "󰤨",
    "network_ssid": "Connected",
    "desktop": 1,
    "desktops_count": 8,
    "temp": "25.4°C",
    "weather_icon": "󰖙",
    "volume": 75,
    "volume_icon": "󰕾",
    "volume_muted": False,
    "lang": "ES"
}

last_weather_fetch = 0

def run_cmd(args):
    try:
        res = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=1.5)
        return res.stdout.strip()
    except Exception:
        return ""

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

def update_weather():
    global last_weather_fetch, state
    now = time.time()
    if now - last_weather_fetch < 900 and last_weather_fetch != 0:
        return
    last_weather_fetch = now
    try:
        import urllib.request
        url = "https://api.open-meteo.com/v1/forecast?latitude=40.4168&longitude=-3.7038&current=temperature_2m,weather_code"
        req = urllib.request.Request(url, headers={'User-Agent': 'Serpanplasma/1.0'})
        with urllib.request.urlopen(req, timeout=3.0) as resp:
            data = json.loads(resp.read().decode())
            temp = data.get("current", {}).get("temperature_2m")
            code = data.get("current", {}).get("weather_code", 0)
            if temp is not None:
                icon = "☁"
                if code in (0, 1):
                    icon = "󰖙"
                elif code in (2, 3):
                    icon = "☁"
                elif code in (45, 48):
                    icon = "󰖑"
                elif code in (51, 53, 55, 61, 63, 65):
                    icon = "󰖖"
                with lock:
                    state["temp"] = f"{temp:.1f}°C"
                    state["weather_icon"] = icon
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
    if not ssid:
        eth = run_cmd(["bash", "-c", "cat /sys/class/net/e*/operstate 2>/dev/null | grep up | head -n 1"])
        if eth:
            with lock:
                state["network"] = "Connected"
                state["network_ssid"] = "Ethernet"
                state["network_icon"] = "󰈀"
            return
        gw = run_cmd(["bash", "-c", "ip route show default 2>/dev/null | head -n 1"])
        if gw:
            with lock:
                state["network"] = "Connected"
                state["network_ssid"] = "Connected"
                state["network_icon"] = "󰤨"
        else:
            with lock:
                state["network"] = "Disconnected"
                state["network_ssid"] = "Disconnected"
                state["network_icon"] = "󰤭"
    else:
        with lock:
            state["network"] = "Connected"
            state["network_ssid"] = ssid if ssid else "Connected"
            state["network_icon"] = "󰤨"

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

def update_lang():
    global state
    layout = run_cmd(["bash", "-c", "setxkbmap -query 2>/dev/null | grep layout | awk '{print $2}'"])
    if layout:
        with lock:
            state["lang"] = layout.upper()[:2]
    else:
        with lock:
            state["lang"] = "ES"

def background_poller():
    while True:
        try:
            update_weather()
            update_media()
            update_battery()
            update_network()
            update_workspaces()
            update_volume()
            update_lang()
        except Exception:
            pass
        time.sleep(0.4)

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
                payload = json.dumps(combined).encode("utf-8")
            self.wfile.write(payload)

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
                else:
                    subprocess.Popen(["qml6", qml_path], env=os.environ.copy())

            elif action == "play-pause":
                subprocess.Popen(["playerctl", "play-pause"])
            elif action == "previous":
                subprocess.Popen(["playerctl", "previous"])
            elif action == "next":
                subprocess.Popen(["playerctl", "next"])
            elif action == "desktop" and val:
                subprocess.Popen(["qdbus6", "org.kde.KWin", "/KWin", "org.kde.KWin.setCurrentDesktop", str(val)])
            elif action == "launcher":
                subprocess.Popen(["qdbus6", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.activateApplicationMenu"])
            elif action == "power":
                subprocess.Popen(["qdbus6", "org.kde.LogoutPrompt", "/LogoutPrompt", "promptShutDown"])
            elif action == "vol_up":
                subprocess.Popen(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"])
            elif action == "vol_down":
                subprocess.Popen(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
            elif action == "vol_mute":
                subprocess.Popen(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])

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
                # Plasma 6 supports: "dodgewindows", "autohide", "none"
                eval_plasma_script(f'''
                    var p = panels();
                    for (var i = 0; i < p.length; i++) {{
                        if (p[i].id === 82 || p[i].location === "bottom" || (p[i].height > 45 && p[i].location !== "top")) {{
                            p[i].hiding = "{val}";
                        }}
                    }}
                ''')
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
                        }}
                    }}
                ''')
                subprocess.run(["kwriteconfig6", "--file", "plasma-org.kde.plasma.desktop-appletsrc", "--group", "Containments", "--group", "55", "--key", "floating", "--type", "bool", js_val])
                save_setting("bar_floating", is_float)

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

            elif action == "set_distinct_pills":
                save_setting("bar_distinct_pills", val.lower() in ("true", "1", "yes"))

            elif action == "set_bar_module" and mod:
                is_on = (val.lower() in ("true", "1", "yes"))
                save_setting(f"bar_mod_{mod}", is_on)

            # --- WALLPAPERS & THEMES ---
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

            elif action == "restart_kwin":
                subprocess.run(["qdbus6", "org.kde.KWin", "/KWin", "reconfigure"])

            elif action == "restart_plasma":
                subprocess.run(["systemctl", "--user", "restart", "plasma-plasmashell.service"])

            elif action == "restart_daemon":
                subprocess.Popen(["systemctl", "--user", "restart", "serpanplasma-daemon.service"])

            elif action == "open_url" and val:
                subprocess.Popen(["xdg-open", val])

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
