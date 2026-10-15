<div align="center">

# 🐍 Serpanplasma

**Clon estético y funcional exacto de *Serpantinum* adaptado al 100% para KDE Plasma 6 (Wayland) con gestión de ventanas tradicional flotante.**

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

## 📖 Visión General

**Serpanplasma** es una recreación fiel y exacta de la experiencia visual y funcional de **[Serpantinum](https://github.com/ilyamiro/serpantinum)** (el entorno minimalista de ilyamiro basado en Quickshell) construida nativamente para **KDE Plasma 6 sobre Wayland**, sin necesidad de gestores en mosaico (*tiling managers* como Hyprland o Niri) y manteniendo la comodidad inigualable de la gestión de ventanas flotantes estilo Windows.

---

## 🎯 ¿Por qué Serpanplasma?

- ❌ **Sin Tiling forzado:** Olvídate de ventanas que se dividen solas en la pantalla o de tener que memorizar decenas de combinaciones de teclas sólo para abrir un navegador.
- ✅ **Ventanas Flotantes Libres (Estilo Windows):** Todas las aplicaciones se abren en modo flotante, centradas, con un tamaño inicial cómodo, superponibles libremente, arrastrables con el ratón y con sus botones clásicos (**_**, **□**, **X**).
- ✅ **Atajos Estándar:**
  - `Alt + F4`: Cerrar la ventana activa.
  - `Alt + Tab`: Alternar entre ventanas abiertas.
  - `Win + Flecha Arriba`: Maximizar ventana activa.
  - `Win + Flecha Abajo`: Restaurar o minimizar ventana activa.
  - `Win + E`: Abrir el explorador de archivos Dolphin.
- ✅ **Barra Superior Flotante con Píldoras Exactas:** Barra flotante translúcida con esquinas redondeadas, blur nativo de KWin y cápsulas idénticas a Serpantinum.
- ✅ **Dock de Aplicaciones Flotante Inferior:** Dock centrado con los iconos de tareas de tus aplicaciones favoritas.
- ✅ **Compatibilidad Universal:** Diseñado para funcionar en cualquier distribución Linux con KDE Plasma 6 (CachyOS, Arch Linux, Fedora, openSUSE, etc.) y en hardware híbrido (AMD + NVIDIA a 144Hz).

---

## 💎 Anatomía del Diseño (Copia Fiel de Serpantinum)

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│  [⚙]  [ ━ ] ● ● ● ● ● ● ●  [ ♫ Track Title ⏮ ▶ ⏭ ]        17:32:27       󰖙 25.4°C      [󰕾] [EN] [󰤨 Connected] [󰁹 100%] [⏻]  │
│                                                     jueves, 15 de octubre                                     │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 1. Barra Superior Flotante (`org.serpanplasma.bar`)
- **Extremo Izquierdo:**
  - `[ ⚙ ]`: Botón cuadrado redondeado para abrir los ajustes y el menú de aplicaciones.
  - `[ ━ ] ● ● ● ● ● ● ●`: Píldora de espacios de trabajo activa (cápsula expandida en tono malva/lavanda `#d0d0d0`) con 7 puntos circulares (`#1e293b`) para los demás escritorios, con animaciones fluidas y cambio interactivo por clic.
  - `[ ♪ Titulo - Artista ⏮ ▶ ⏭ ]`: Cápsula multimedia que muestra la pista actual o *"No hay nada reprc"*, con controles directos interactivos de pista anterior, reproducción/pausa y pista siguiente.
- **Centro:**
  - **Reloj Digital Apilado:**
    - Fila 1: Hora exacta en formato `HH:mm:ss` con tipografía **JetBrains Mono Nerd Font** en negrita máxima (*Black*).
    - Fila 2: Fecha completa en español (`dddd, d 'de' MMMM`) en tono gris pizarra suave (`#94a3b8`).
  - **Cápsula de Clima:** Icono de condición meteorológica en tiempo real (`☁`, `󰖙`, `󰖖`, etc.) y temperatura en grados Celsius proporcionados por Open-Meteo.
- **Extremo Derecho:**
  - `[ 󰕾 ]`: Control de volumen con soporte de rueda de ratón (subir/bajar) y clic para silenciar.
  - `[ EN / ES ]`: Indicador de distribución de teclado actual.
  - `[ 󰤨 Connected ]`: **Cápsula sólida blanca (#f8fafc)** con icono y texto en contraste oscuro (`#0f172a`), indicando el estado de red o nombre SSID.
  - `[ 󰁹 100% ]`: **Cápsula sólida blanca (#f8fafc)** con icono dinámico de batería/carga y porcentaje.
  - `[ ⏻ ]`: Botón circular de apagado que invoca el diálogo de cierre de sesión y apagado de Plasma.

### 2. Dock de Aplicaciones Inferior
- Panel flotante centrado desacoplado del borde inferior de la pantalla.
- Iconos directos para Terminal (`kitty`/`konsole`), Explorador (`dolphin`), Navegador web, `Discord`, `Spotify` y Ajustes del Sistema.
- Indicadores discretos de aplicaciones en ejecución y soporte para arrastrar y fijar nuevos lanzadores.

### 3. Paleta de Colores "Obsidian" & Tipografía
- **Fondo base:** Pizarra y azul muy oscuro (`#0f172a`, `#1e293b`).
- **Acentos:** Azul cielo brillante (`#38bdf8`) y Malva/Lavanda (`#d0d0d0`).
- **Píldoras de estado:** Blanco puro (`#f8fafc`) con tipografía negra pizarra (`#0f172a`).
- **Tipografía:** `JetBrains Mono Nerd Font` (SemiBold / Bold / Black).

---

## 🛠️ Arquitectura Técnica

Serpanplasma está estructurado de manera modular y limpia:

```
Serpanplasma/
├── assets/                          # Recursos visuales y capturas de vista previa
├── configs/
│   ├── autostart/                   # Entrada de autostart para el demonio
│   ├── systemd/                     # Servicio systemd user para el demonio de estado
│   └── terminal/                    # Perfiles para Konsole, Kitty y Alacritty
├── fonts/                           # Tipografía JetBrains Mono Nerd Font
├── scripts/
│   ├── setup-panel.js               # Script de KDE para configurar barra superior y dock
│   ├── setup-wallpapers.js          # Script para configurar rotación de fondos
│   └── status-daemon.py             # Microdemonio HTTP ultrarrápido (<1ms)
├── themes/
│   ├── color-schemes/               # Esquema de color Obsidian para KDE
│   ├── plasma/
│   │   ├── desktoptheme/            # Tema de escritorio Serpanplasma (Blur, SVGs)
│   │   └── plasmoids/
│   │       └── org.serpanplasma.bar # Plasmoide nativo QML para la barra superior
│   └── window-decorations/          # Configuración de Breeze con esquinas redondeadas
├── install.sh                       # Instalador automático con copias de seguridad
├── restore.sh                       # Script para restaurar la configuración anterior
└── README.md
```

### Microdemonio de Estado (`status-daemon.py`)
Para garantizar un rendimiento de 144Hz sin ralentizar plasmashell, un microdemonio en segundo plano (escrito en Python puro sin dependencias externas) recopila periódicamente las métricas del sistema:
- Consultas MPRIS para reproducción de audio (`playerctl`).
- Detección de batería (`/sys/class/power_supply`).
- Estado de conexión de red (`nmcli` / `/sys/class/net`).
- Niveles de volumen (`wpctl` / `pactl`).
- Espacios de trabajo activos de KWin (`qdbus6 org.kde.KWin`).
- Clima geolocalizado en segundo plano vía Open-Meteo.
- Servidor HTTP local en `127.0.0.1:19842` consultado por el componente QML de forma instantánea.

---

## 🚀 Instalación Rápida

### Requisitos Previos:
- Sistema Operativo: CachyOS, Arch Linux o cualquier distribución con **KDE Plasma 6 (Wayland)**.
- Herramientas básicas: `git`, `python3`, `curl`, `jq`, `playerctl`.

En Arch Linux / CachyOS:
```bash
sudo pacman -S --needed git python jq playerctl
```

### Clonar e Instalar:
```bash
git clone https://github.com/jorjanion/Serpanplasma.git
cd Serpanplasma
chmod +x install.sh restore.sh
./install.sh
```

El instalador:
1. Creará una copia de seguridad automática de tu configuración actual en `~/.config/serpanplasma-backup/`.
2. Instalará y registrará las fuentes **JetBrains Mono Nerd Font**.
3. Aplicará el esquema de colores **Serpanplasma Obsidian**.
4. Instalará el plasmoide nativo `org.serpanplasma.bar`.
5. Levantará y habilitará el servicio systemd del demonio de estado (`serpanplasma-daemon.service`).
6. Configurará KWin en modo flotante centrado a 144Hz y con los atajos estándar de Windows.
7. Construirá la barra superior flotante y el dock inferior.
8. Limpiará los iconos de la superficie del escritorio para un look minimalista impoluto.

---

## 🔄 Restauración / Desinstalación

Si alguna vez deseas volver al estado previo de tu escritorio:
```bash
cd Serpanplasma
./restore.sh
```
El script detendrá el demonio, eliminará el plasmoide y restaurará exactamente los archivos de configuración previos desde la copia de seguridad.

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **GPL-3.0-or-later**. Consulta el archivo [LICENSE](LICENSE) para más detalles.
Inspirado por el diseño visual de [Serpantinum](https://github.com/ilyamiro/serpantinum) de ilyamiro.
