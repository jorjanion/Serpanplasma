#!/usr/bin/env bash
# ==============================================================================
# Serpanplasma - Restore & Uninstall Script
# Reverts KDE Plasma 6 configuration to the state prior to installing Serpanplasma
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[38;2;52;211;153m"
CYAN="\033[38;2;56;189;248m"
YELLOW="\033[38;2;251;191;36m"
RED="\033[38;2;248;113;113m"
RESET="\033[0m"

BACKUP_ROOT="$HOME/.config/serpanplasma-backup"

echo -e "${YELLOW}${BOLD}"
cat << "EOF"
  ____                               _                               
 |  _ \ ___  ___| |_ ___  _ __ ___  | | __ _ ___ _ __ ___   __ _    
 | |_) / _ \/ __| __/ _ \| '__/ _ \ | |/ _` / __| '_ ` _ \ / _` |   
 |  _ <  __/\__ \ || (_) | | |  __/ | | (_| \__ \ | | | | | (_| |   
 |_| \_\___||___/\__\___/|_|  \___| |_|\__,_|___/_| |_| |_|\__,_|   
                                                                     
  Deshacer cambios y restaurar configuración previa de KDE Plasma 6
EOF
echo -e "${RESET}"

# 1. Stop and disable background service
echo -e "${CYAN}==>${RESET} Deteniendo servicio de estado de Serpanplasma..."
if systemctl --user is-active --quiet serpanplasma-daemon.service; then
    systemctl --user stop serpanplasma-daemon.service 2>/dev/null || true
    systemctl --user disable serpanplasma-daemon.service 2>/dev/null || true
fi
pkill -f "status-daemon.py" 2>/dev/null || true
rm -f "$HOME/.config/systemd/user/serpanplasma-daemon.service" 2>/dev/null || true
rm -f "$HOME/.config/autostart/serpanplasma-daemon.desktop" 2>/dev/null || true
systemctl --user daemon-reload 2>/dev/null || true

# 2. Check backups
if [ ! -d "$BACKUP_ROOT" ] || [ -z "$(ls -A "$BACKUP_ROOT" 2>/dev/null)" ]; then
    echo -e "${RED}[ERROR]${RESET} No se encontró ninguna copia de seguridad en $BACKUP_ROOT."
    exit 1
fi

# Find the latest backup directory
LATEST_BACKUP="$(ls -td "$BACKUP_ROOT"/backup-* "$BACKUP_ROOT"/pre-install-* 2>/dev/null | head -n 1)"

if [ -z "$LATEST_BACKUP" ] || [ ! -d "$LATEST_BACKUP" ]; then
    echo -e "${RED}[ERROR]${RESET} No se pudo localizar la última carpeta de copia de seguridad."
    exit 1
fi

echo -e "${CYAN}==>${RESET} Restaurando desde la copia de seguridad: ${BOLD}$LATEST_BACKUP${RESET}"

for f in "$LATEST_BACKUP"/*; do
    if [ -f "$f" ]; then
        fname="$(basename "$f")"
        echo -e "    Restaurando ~/.config/$fname..."
        cp -a "$f" "$HOME/.config/$fname"
    fi
done

# 3. Remove custom plasmoid and themes
rm -rf "$HOME/.local/share/plasma/plasmoids/org.serpanplasma.bar" 2>/dev/null || true
rm -rf "$HOME/.local/share/plasma/desktoptheme/Serpanplasma" 2>/dev/null || true
rm -rf "$HOME/.local/share/serpanplasma" 2>/dev/null || true

# 4. Revert color scheme and desktop theme to defaults
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 || true
fi

if command -v plasma-apply-desktoptheme &>/dev/null; then
    plasma-apply-desktoptheme default >/dev/null 2>&1 || true
fi

# 5. Reconfigure KWin and restart PlasmaShell
echo -e "${CYAN}==>${RESET} Reiniciando componentes de KDE Plasma..."
if command -v qdbus6 &>/dev/null; then
    qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
fi

if systemctl --user is-active --quiet plasma-plasmashell.service; then
    systemctl --user restart plasma-plasmashell.service
fi

echo -e "\n${GREEN}${BOLD}¡Restauración completada con éxito!${RESET}"
echo -e "Se ha restablecido la configuración previa del escritorio KDE Plasma.\n"
