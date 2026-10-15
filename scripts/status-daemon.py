#!/usr/bin/env python3
"""
Serpanplasma Status & Settings Daemon
Ultra-lightweight background daemon that queries system metrics (workspaces, media, battery, network, volume, weather)
and provides command execution for the Serpanplasma Top Bar and Guide/Settings Dashboard.
"""

import http.server
import json
import os
import subprocess
import threading
import time
import urllib.parse

PORT = 19842
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
    "lang": "EN",
    "bar_height": 38,
    "dock_height": 54,
    "wallpaper_interval": 900
}

lock = threading.Lock()
last_weather_fetch = 0

def run_cmd(args):
    try:
        res = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=1.5)
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
            state["lang"] = "EN"

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
                payload = json.dumps(state).encode("utf-8")
            self.wfile.write(payload)

        elif path == "/cmd":
            action = params.get("action", [""])[0]
            val = params.get("val", [""])[0]
            home = os.path.expanduser("~")

            if action == "settings":
                # Toggle Settings / Guide window
                qml_path = os.path.join(home, ".local/share/serpanplasma/guide/SettingsWindow.qml")
                check = subprocess.run(["pgrep", "-f", "SettingsWindow.qml"], stdout=subprocess.PIPE, text=True)
                if check.stdout.strip():
                    subprocess.run(["pkill", "-f", "SettingsWindow.qml"])
                else:
                    subprocess.Popen(["qml6", qml_path])

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

            # Settings Window Actions
            elif action == "next_wallpaper":
                script = '''
                    var ds = desktops();
                    for (var i = 0; i < ds.length; i++) {
                        ds[i].currentConfigGroup = ["Wallpaper", "org.kde.slideshow", "General"];
                        var paths = ds[i].readConfig("SlidePaths");
                        ds[i].writeConfig("SlidePaths", paths);
                    }
                '''
                subprocess.run(["qdbus6", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.evaluateScript", script])

            elif action == "open_wallpapers":
                wp_dir = os.path.join(home, "Imágenes", "Wallpapers")
                subprocess.Popen(["xdg-open", wp_dir])

            elif action == "apply_colorscheme" and val:
                subprocess.run(["plasma-apply-colorscheme", val])

            elif action == "restart_kwin":
                subprocess.run(["qdbus6", "org.kde.KWin", "/KWin", "reconfigure"])

            elif action == "restart_plasma":
                subprocess.run(["systemctl", "--user", "restart", "plasma-plasmashell.service"])

            elif action == "open_url" and val:
                subprocess.Popen(["xdg-open", val])

            elif action == "set_bar_height" and val:
                try:
                    h = int(val)
                    with lock:
                        state["bar_height"] = h
                    script = f'''
                        var p = panels();
                        for (var i = 0; i < p.length; i++) {{
                            if (p[i].location === "top") {{
                                p[i].height = {h};
                            }}
                        }}
                    '''
                    subprocess.run(["qdbus6", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.evaluateScript", script])
                except Exception:
                    pass

            elif action == "set_dock_height" and val:
                try:
                    h = int(val)
                    with lock:
                        state["dock_height"] = h
                    script = f'''
                        var p = panels();
                        for (var i = 0; i < p.length; i++) {{
                            if (p[i].location === "bottom") {{
                                p[i].height = {h};
                            }}
                        }}
                    '''
                    subprocess.run(["qdbus6", "org.kde.plasmashell", "/PlasmaShell", "org.kde.PlasmaShell.evaluateScript", script])
                except Exception:
                    pass

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
