#!/usr/bin/env bash
# ==============================================================================
# Serpanplasma - Installer for KDE Plasma 6 (Wayland)
# Clones the minimalist aesthetic of Serpantinum (ilyamiro) for KDE Plasma 6
# with traditional Windows-style floating window management.
# ==============================================================================

set -euo pipefail

# ANSI Color codes
BOLD="\033[1m"
GREEN="\033[38;2;52;211;153m"
CYAN="\033[38;2;56;189;248m"
YELLOW="\033[38;2;251;191;36m"
RED="\033[38;2;248;113;113m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.config/serpanplasma-backup"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/backup-$TIMESTAMP"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
  ____                               _                               
 / ___|  ___ _ __ _ __   __ _ _ __  | | __ _ ___ _ __ ___   __ _    
 \___ \ / _ \ '__| '_ \ / _` | '_ \ | |/ _` / __| '_ ` _ \ / _` |   
  ___) |  __/ |  | |_) | (_| | | | || | (_| \__ \ | | | | | (_| |   
 |____/ \___|_|  | .__/ \__,_|_| |_||_|\__,_|___/_| |_| |_|\__,_|   
                 |_|                                                 
  Serpantinum Minimalist Aesthetics for KDE Plasma 6 (Floating Mode)
EOF
echo -e "${RESET}"

# 1. Validation
echo -e "${CYAN}==>${RESET} Verificando entorno del sistema..."
if ! command -v plasmashell &>/dev/null && ! command -v kinfo &>/dev/null; then
    echo -e "${RED}[ERROR]${RESET} KDE Plasma no parece estar instalado en este sistema."
    exit 1
fi

PLASMA_VER="$(plasmashell --version 2>/dev/null || echo 'Plasma 6')"
echo -e "    Detectado: ${GREEN}$PLASMA_VER${RESET} sobre Wayland"

# 2. Backup
echo -e "${CYAN}==>${RESET} Creando copia de seguridad en ${BOLD}$BACKUP_DIR${RESET}..."
mkdir -p "$BACKUP_DIR"

CONFIG_FILES=(
    "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
    "$HOME/.config/kdeglobals"
    "$HOME/.config/kwinrc"
    "$HOME/.config/kglobalshortcutsrc"
    "$HOME/.config/plasmarc"
    "$HOME/.config/breezerc"
)

for cfg in "${CONFIG_FILES[@]}"; do
    if [ -f "$cfg" ]; then
        cp -a "$cfg" "$BACKUP_DIR/"
    fi
done
echo -e "    ${GREEN}✓${RESET} Copia de seguridad completada con éxito."

# 3. Fonts Installation (JetBrains Mono Nerd Font)
echo -e "${CYAN}==>${RESET} Instalando tipografía JetBrains Mono Nerd Font SemiBold..."
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"
mkdir -p "$FONT_DIR"
if [ -d "$SCRIPT_DIR/fonts" ] && [ "$(ls -A "$SCRIPT_DIR/fonts" 2>/dev/null)" ]; then
    cp -r "$SCRIPT_DIR/fonts"/* "$FONT_DIR/"
fi
if command -v fc-cache &>/dev/null; then
    fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi
echo -e "    ${GREEN}✓${RESET} Fuentes instaladas y registradas en fontconfig."

# 4. Color Scheme Installation
echo -e "${CYAN}==>${RESET} Instalando esquema de colores Serpanplasma Obsidian..."
COLOR_SCHEME_DIR="$HOME/.local/share/color-schemes"
mkdir -p "$COLOR_SCHEME_DIR"
cp "$SCRIPT_DIR/themes/color-schemes/Serpanplasma-Obsidian.colors" "$COLOR_SCHEME_DIR/"

if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme Serpanplasma-Obsidian >/dev/null 2>&1 || true
fi
echo -e "    ${GREEN}✓${RESET} Esquema Obsidian aplicado (#0f172a / #1e293b / #38bdf8)."

# 5. Plasma Desktop Theme Installation
echo -e "${CYAN}==>${RESET} Instalando tema de escritorio de Plasma (Floating Blur Top Bar)..."
THEME_DIR="$HOME/.local/share/plasma/desktoptheme/Serpanplasma"
mkdir -p "$THEME_DIR"
cp -r "$SCRIPT_DIR/themes/plasma/desktoptheme/Serpanplasma"/* "$THEME_DIR/"

if command -v plasma-apply-desktoptheme &>/dev/null; then
    plasma-apply-desktoptheme Serpanplasma >/dev/null 2>&1 || true
fi
echo -e "    ${GREEN}✓${RESET} Tema de escritorio Serpanplasma activado."

# 6. Icons & Launcher Branding
echo -e "${CYAN}==>${RESET} Instalando icono minimalista para el lanzador..."
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"
mkdir -p "$ICON_DIR"
if [ -f "$SCRIPT_DIR/assets/icons/serpanplasma-launcher.svg" ]; then
    cp "$SCRIPT_DIR/assets/icons/serpanplasma-launcher.svg" "$ICON_DIR/"
fi

# 7. Window Decorations (Breeze Config)
echo -e "${CYAN}==>${RESET} Configurando decoraciones de ventana (Esquinas redondeadas, sombras sutiles, _, □, X)..."
cp "$SCRIPT_DIR/themes/window-decorations/breezerc" "$HOME/.config/breezerc"

# 8. KWin Settings (Floating, Centered, Click-to-raise, 144Hz & Blur)
echo -e "${CYAN}==>${RESET} Configurando gestor de ventanas KWin..."
kwriteconfig6 --file kwinrc --group Windows --key Placement "Centered"
kwriteconfig6 --file kwinrc --group Windows --key ClickRaise "true"
kwriteconfig6 --file kwinrc --group Windows --key AutoRaise "false"
kwriteconfig6 --file kwinrc --group Windows --key FocusPolicy "ClickToFocus"
kwriteconfig6 --file kwinrc --group Windows --key NextFocusPrefersMouse "false"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.breeze"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "Breeze"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ""
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key contrastEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key glideEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key scaleEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key slidingpopupsEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key translucencyEnabled "true"
kwriteconfig6 --file kwinrc --group Compositing --key MaxFPS "144"
kwriteconfig6 --file kwinrc --group Compositing --key LatencyPolicy "Low"
kwriteconfig6 --file kwinrc --group Compositing --key GLCore "true"
kwriteconfig6 --file kwinrc --group Compositing --key WindowsBlockCompositing "false"

if command -v qdbus6 &>/dev/null; then
    qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

# 9. Shortcuts Configuration (Alt+F4, Alt+Tab, Win+Up, Win+Down, Win+E)
echo -e "${CYAN}==>${RESET} Configurando atajos estándar de Windows..."
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Close" "Alt+F4,Alt+F4,Cerrar la ventana"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Walk Through Windows" "Alt+Tab\tMeta+Tab,Alt+Tab\tMeta+Tab,Recorrer las ventanas"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Walk Through Windows (Reverse)" "Alt+Shift+Tab\tMeta+Shift+Tab,Alt+Shift+Tab\tMeta+Shift+Tab,Recorrer las ventanas (hacia atrás)"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+Up,Meta+Up,Maximizar la ventana"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+Down,Meta+Down,Minimizar la ventana"
kwriteconfig6 --file kglobalshortcutsrc --group "services" --group "org.kde.dolphin.desktop" --key "_launch" "Meta+E,Meta+E,Dolphin"

# 10. System Fonts Setup
echo -e "${CYAN}==>${RESET} Configurando tipografía JetBrains Mono SemiBold en el sistema..."
kwriteconfig6 --file kdeglobals --group General --key font "JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key fixed "JetBrainsMono Nerd Font Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key smallestReadableFont "JetBrainsMono Nerd Font,8,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key menuFont "JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group WM --key activeFont "JetBrainsMono Nerd Font SemiBold,10,-1,5,63,0,0,0,0,0"

# 11. Environment Configuration for Qt Theme Integration
echo -e "${CYAN}==>${RESET} Configurando integración de temas Qt/KDE..."
mkdir -p "$HOME/.config/environment.d"
echo "QT_QPA_PLATFORMTHEME=kde" > "$HOME/.config/environment.d/plasma-theme.conf"
rm -f "$HOME/.config/environment.d/serpantinum-qt.conf" 2>/dev/null || true

# 12. Terminal Configuration (Konsole, Kitty, Alacritty) & Fastfetch
echo -e "${CYAN}==>${RESET} Configurando perfiles de terminal (Konsole, Kitty, Alacritty, Fastfetch)..."
mkdir -p "$HOME/.local/share/konsole"
cp "$SCRIPT_DIR/configs/terminal/konsole"/* "$HOME/.local/share/konsole/" 2>/dev/null || true

mkdir -p "$HOME/.config/kitty"
if [ ! -f "$HOME/.config/kitty/kitty.conf" ]; then
    cp "$SCRIPT_DIR/configs/terminal/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
fi

mkdir -p "$HOME/.config/alacritty"
if [ ! -f "$HOME/.config/alacritty/alacritty.toml" ]; then
    cp "$SCRIPT_DIR/configs/terminal/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

mkdir -p "$HOME/.config/fastfetch"
cp "$SCRIPT_DIR/configs/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true

# 13. Install Custom Plasmoid (org.serpanplasma.bar)
echo -e "${CYAN}==>${RESET} Instalando plasmoide nativo Serpanplasma Bar..."
PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids/org.serpanplasma.bar"
mkdir -p "$PLASMOID_DIR"
cp -r "$SCRIPT_DIR/themes/plasma/plasmoids/org.serpanplasma.bar"/* "$PLASMOID_DIR/"

# 14. Install and Start Status Daemon (Systemd service & autostart)
echo -e "${CYAN}==>${RESET} Configurando demonio de estado en segundo plano..."
DAEMON_DIR="$HOME/.local/share/serpanplasma/scripts"
mkdir -p "$DAEMON_DIR" "$HOME/.config/systemd/user" "$HOME/.config/autostart"
cp "$SCRIPT_DIR/scripts/status-daemon.py" "$DAEMON_DIR/"
chmod +x "$DAEMON_DIR/status-daemon.py"

cp "$SCRIPT_DIR/configs/systemd/serpanplasma-daemon.service" "$HOME/.config/systemd/user/"
cp "$SCRIPT_DIR/configs/autostart/serpanplasma-daemon.desktop" "$HOME/.config/autostart/"

if command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload >/dev/null 2>&1 || true
    systemctl --user enable --now serpanplasma-daemon.service >/dev/null 2>&1 || true
fi

# 14.1. Install Settings & Guide Dashboard Window
echo -e "${CYAN}==>${RESET} Instalando ventana de Guía y Configuración (Settings Dashboard)..."
mkdir -p "$HOME/.local/share/serpanplasma/guide" "$HOME/.local/bin" "$HOME/.local/share/applications"
cp "$SCRIPT_DIR/configs/guide/SettingsWindow.qml" "$HOME/.local/share/serpanplasma/guide/"
cp "$SCRIPT_DIR/configs/bin/serpanplasma-settings" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/serpanplasma-settings"
cp "$SCRIPT_DIR/configs/applications/serpanplasma-settings.desktop" "$HOME/.local/share/applications/"
update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true


# 15. Wallpaper Slideshow & Clean Desktop Containment Setup
echo -e "${CYAN}==>${RESET} Configurando fondos de pantalla y superficie de escritorio limpia..."
sed -i 's/plugin=org.kde.plasma.folder/plugin=org.kde.desktopcontainment/g' "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" 2>/dev/null || true
if command -v qdbus6 &>/dev/null && [ -f "$SCRIPT_DIR/scripts/setup-wallpapers.js" ]; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$SCRIPT_DIR/scripts/setup-wallpapers.js")" >/dev/null 2>&1 || true
fi

# 16. Top Floating Bar Layout & Bottom Floating Dock Setup
echo -e "${CYAN}==>${RESET} Configurando barra superior flotante y dock de aplicaciones..."
if command -v qdbus6 &>/dev/null && [ -f "$SCRIPT_DIR/scripts/setup-panel.js" ]; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$SCRIPT_DIR/scripts/setup-panel.js")" >/dev/null 2>&1 || true
fi

# 17. Reload PlasmaShell to apply all visual components
echo -e "${CYAN}==>${RESET} Recargando entorno de escritorio Plasma..."
if systemctl --user is-active --quiet plasma-plasmashell.service; then
    systemctl --user restart plasma-plasmashell.service >/dev/null 2>&1 || true
fi

echo -e "\n${GREEN}${BOLD}¡Instalación de Serpanplasma completada con éxito!${RESET}"
echo -e "${CYAN}─────────────────────────────────────────────────────────────────${RESET}"
echo -e "  • ${BOLD}Barra Superior Flotante:${RESET}   Panel flotante con píldoras de Serpantinum."
echo -e "  • ${BOLD}Widgets de la Barra:${RESET}       Ajustes/Lanzador, Espacios de trabajo (Pills), Reproductor multimedia,"
echo -e "                             Reloj apilado en español, Clima en vivo, Volumen, Idioma, Red y Batería (Píldoras blancas) y Botón de apagado."
echo -e "  • ${BOLD}Dock de Aplicaciones:${RESET}      Panel flotante inferior centrado con iconos de tareas."
echo -e "  • ${BOLD}Gestión de Ventanas:${RESET}       Ventanas flotantes, centradas, click-to-raise,"
echo -e "                             atajos Windows (Alt+F4, Alt+Tab, Win+Up, Win+Down, Win+E)."
echo -e "  • ${BOLD}Esquema de Colores:${RESET}        Obsidian Palette (#0f172a / #1e293b / #38bdf8)."
echo -e "  • ${BOLD}Tipografía:${RESET}                JetBrains Mono SemiBold."
echo -e "  • ${BOLD}Copia de seguridad:${RESET}        Guardada en $BACKUP_DIR"
echo -e "  • ${BOLD}Desinstalación:${RESET}            Ejecuta ./restore.sh para revertir los cambios."
echo -e "${CYAN}─────────────────────────────────────────────────────────────────${RESET}\n"
