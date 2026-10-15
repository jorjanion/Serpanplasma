<div align="center">

# 🐍 Serpanplasma

**Exact visual and functional clone of *Serpantinum* adapted 100% for KDE Plasma 6 (Wayland) with traditional floating window management.**

[🇪🇸 Español](README.md) | [🇬🇧 English](README_EN.md)

[![KDE Plasma 6](https://img.shields.io/badge/KDE_Plasma-6.0%2B-38bdf8?style=for-the-badge&logo=kde&logoColor=white)](https://kde.org/plasma-desktop/)
[![Wayland](https://img.shields.io/badge/Display-Wayland-0284c7?style=for-the-badge&logo=wayland&logoColor=white)](https://wayland.freedesktop.org/)
[![CachyOS / Arch](https://img.shields.io/badge/Tested_on-CachyOS_Arch_Linux-10b981?style=for-the-badge&logo=archlinux&logoColor=white)](https://cachyos.org/)
[![Hardware](https://img.shields.io/badge/Hardware-AMD_%2B_NVIDIA_Hybrid_144Hz-fbbf24?style=for-the-badge)](https://github.com/jorjanion/Serpanplasma)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-f87171?style=for-the-badge)](LICENSE)

<br/>

![Serpanplasma Preview](assets/preview.png)

</div>

---

## 📖 Overview

**Serpanplasma** is a pixel-perfect recreation of the clean, minimalist visual experience of **[Serpantinum](https://github.com/ilyamiro/serpantinum)** (ilyamiro's Quickshell desktop shell), engineered natively for **KDE Plasma 6 over Wayland**.

It delivers Serpantinum's aesthetics without tiling window managers (like Hyprland or Niri), preserving the comfort, stability, and intuitive workflow of traditional Windows floating window management.

---

## 🎯 Key Highlights

- ❌ **No Forced Tiling:** No complex keybinding gymnastics or auto-splitting windows across your screen.
- ✅ **True Floating Windows (Windows Style):** Applications open centered with comfortable default sizing, drag-and-drop freely, overlap naturally, and include classic window buttons (**_**, **□**, **X**).
- ✅ **Standard Windows Shortcuts:**
  - `Alt + F4`: Close active window.
  - `Alt + Tab`: Switch between running applications.
  - `Win + Up Arrow`: Maximize active window.
  - `Win + Down Arrow`: Restore or minimize active window.
  - `Win + E`: Launch Dolphin file manager.
- ✅ **Floating Top Bar with Native Pills:** Translucent floating top panel with rounded corners, native KWin blur, and capsules identical to Serpantinum.
- ✅ **Floating Application Dock:** Centered floating bottom dock with task indicators, hover zoom, and intelligent window dodging.
- ✅ **Native Wayland Dropdown Dialogs:** Clicking top bar pills opens interactive popup cards anchored directly below:
  - 󰖙 **Weather Card:** 4-day forecast with interactive day selector, feels like, humidity, and wind metrics.
  - 󰃮 **Monthly Calendar:** Interactive calendar with smooth animated month transition and live digital clock.
  - 󰁹 **Battery & Power Profiles:** Unclipped battery monitor with 1-click power profiles (`144Hz Performance`, `Balanced`, `Power Saver`).
  - 󰤨 **Network & Traffic Details:** SSID, local IP, public IP, and real-time upload/download speeds.
  - 󰕾 **Audio Controls:** Master volume slider, output audio device switcher (headset, speakers, HDMI), mute toggle, and quick presets.
  - 󰌌 **Keyboard Layout Pill:** Clickable capsule to toggle between `ES` and `US` layout with 1 click.
  - ⏻ **Power Menu:** Native popup menu for Shut Down, Reboot, Log Out, Lock Screen, and Suspend.
  - 󰏘 **Quick Theme Switcher:** Instant, reactive color switching across top bar, pills, and popups.
- ✅ **8 Dark & Light Color Palettes:**
  - **Dark:** `Obsidian` (Serpantinum Official), `Catppuccin Mocha`, `Cyber Emerald`, `Deep Amethyst`, `Neon Ruby`.
  - **Light:** `Porcelain White`, `Catppuccin Latte`, `Nord Snow Polar`.
- ✅ **Wallpaper Controls:** Automatic rotation toggle (slideshow) and 1-click button to freeze current wallpaper as static.
- ✅ **Modular & Draggable Desktop Widgets:** 4 independent floating cards (Hardware Monitor, Giant Clock, Weather Card, and MPRIS Player) that can be freely dragged anywhere across the desktop and enabled/disabled individually.
- ✅ **Interactive 1:1 Settings & Guide Dashboard:** Standalone Qt6/QML guide with 9 specialized tabs, welcome banner, and real-time reactive toggles.
- ✅ **Universal Compatibility:** Tailored for any Linux distribution running KDE Plasma 6 (CachyOS, Arch Linux, Fedora, openSUSE, Debian, etc.) and fully verified on hybrid graphics (AMD + NVIDIA 144Hz).

---

## 💎 Design Anatomy (1:1 Serpantinum Replica)

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ [⚙] [ ━ ] ● ● ● ● ● ● ● [ ♫ Title ⏮ ▶ ⏭ ]   [15 Oct.] [ 17:32:27 ] [󰖙 22°C]   [󰏘] [󰕾] [EN] [󰤨 Net] [󰁹 100%] [⏻] │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 1. Floating Top Bar (`org.serpanplasma.bar`)
- **Left Section:**
  - `[ ⚙ ]`: Rounded square button that toggles the **Serpanplasma Settings & Guide** window.
  - `[ ━ ] ● ● ● ● ● ● ●`: Interactive 8 virtual desktops module with active lavender pill (`#d0d0d0`) and circular dots (`#1e293b`).
  - `[ ♪ Title - Artist ⏮ ▶ ⏭ ]`: Media capsule with MPRIS controls (previous, play/pause, next).
- **Center Section (Symmetrical Trio):**
  - `[ 15 Oct. ]`: Short date pill opening interactive monthly calendar.
  - `[ 17:32:27 ]`: **Mathematically centered digital clock** in JetBrains Mono Black.
  - `[ 󰖙 22.1°C ]`: Weather pill opening 4-day forecast dialog.
- **Right Section:**
  - `[ 󰏘 ]`: Quick theme switcher dialog.
  - `[ 󰕾 ]`: Interactive volume pill with slider popup.
  - `[ US / ES ]`: Keyboard layout indicator.
  - `[ 󰤨 Net ]`: Solid white capsule opening network dialog.
  - `[ 󰁹 100% ]`: Solid white capsule opening battery & power profiles dialog.
  - `[ ⏻ ]`: Power button triggering Plasma logout/shutdown.

### 2. Centered Floating Application Dock
- Floating panel detached from the bottom screen edge.
- Pinned launchers for Terminal (`kitty`/`konsole`), File Manager (`dolphin`), Web Browser, `Discord`, `Spotify`, and System Settings.
- Smart running indicators and drag-and-drop pinning support.

### 3. Settings & Guide Dashboard (`serpanplasma-settings`)
- Exact recreation of Serpantinum's `GuidePopup.qml` & `WelcomeTab.qml`:
  - **Welcome Tab:** Hero banner, version badge `v1.0.0`, feature cards, and quick navigation shortcuts.
  - **Top Bar Tab:** Height sliders, opacity sliders, distinct pills vs edge-to-edge toggle, module visibility.
  - **Dock Tab:** Comprehensive settings (position, size, autohide, dodge windows, hover scale, indicators).
  - **Theme Tab:** 8 color schemes (5 dark, 3 light) with color swatches and 1-click activation.
  - **Windows Tab:** KWin floating rules, click-to-raise, rounded corners, and shortcut overview.
  - **Wallpapers Tab:** Slideshow toggle, static freeze button, intervals, and Dolphin shortcut.
  - **Desktop Widgets Tab:** Toggle and reload controls for hardware monitor, big clock, and live weather.
  - **System & Shortcuts Tab:** Standard Windows shortcuts and daemon restart.
  - **About Tab:** Credits, architecture, and project links.

---

## 🛠️ Architecture

```
Serpanplasma/
├── assets/                          # Visual resources and desktop previews
├── configs/
│   ├── applications/                # Desktop entry for Serpanplasma Settings
│   ├── autostart/                   # Autostart entry for the status daemon
│   ├── bin/                         # CLI launcher (serpanplasma-settings)
│   ├── guide/                       # Standalone Settings & Guide QML application
│   ├── systemd/                     # Systemd user service for background daemon
│   └── terminal/                    # Profiles for Konsole, Kitty, and Alacritty
├── fonts/                           # JetBrains Mono Nerd Font typography
├── scripts/
│   ├── setup-panel.js               # Plasma scripting layout for bar and dock
│   ├── setup-wallpapers.js          # Wallpaper slideshow configuration
│   └── status-daemon.py             # Ultra-lightweight local HTTP status daemon (<1ms)
├── themes/
│   ├── color-schemes/               # Obsidian color scheme for KDE Plasma
│   ├── plasma/
│   │   ├── desktoptheme/            # Serpanplasma desktop theme (Blur, SVGs)
│   │   └── plasmoids/
│   │       └── org.serpanplasma.bar # Native QML top bar plasmoid
│   └── window-decorations/          # Breeze configuration with rounded corners
├── install.sh                       # Automated installer with backups
├── restore.sh                       # Restoration script to revert changes
├── README.md                        # Documentation in Spanish
└── README_EN.md                     # Documentation in English
```

---

## 🚀 Installation

### Prerequisites:
- OS: CachyOS, Arch Linux, or any distribution running **KDE Plasma 6 (Wayland)**.
- Packages: `git`, `python3`, `curl`, `jq`, `playerctl`.

On Arch Linux / CachyOS:
```bash
sudo pacman -S --needed git python jq playerctl
```

### Clone and Install:
```bash
git clone https://github.com/jorjanion/Serpanplasma.git
cd Serpanplasma
chmod +x install.sh restore.sh
./install.sh
```

The installer will:
1. Create a full backup in `~/.config/serpanplasma-backup/`.
2. Install and register **JetBrains Mono Nerd Font**.
3. Apply the **Serpanplasma Obsidian** color palette.
4. Deploy the native **Serpanplasma Bar** plasmoid and floating application dock.
5. Install and enable the background status daemon via `systemd --user`.
6. Deploy the **Settings & Guide** application and link the `[ ⚙ ]` top bar button.
7. Configure KWin for centered floating placement, click-to-raise, and Windows shortcuts.

---

## 🔄 Restoration / Uninstallation

To revert your desktop to its exact previous state:
```bash
cd Serpanplasma
./restore.sh
```
This stops the daemon, removes the custom plasmoid and settings files, and restores your previous KDE configuration files from the backup.

---

## 📄 License

Distributed under the **GPL-3.0-or-later** license. See [LICENSE](LICENSE) for details.
Inspired by the visual design of [Serpantinum](https://github.com/ilyamiro/serpantinum) by ilyamiro.
