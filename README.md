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
- ✅ **Dock de Aplicaciones Flotante Inferior:** Dock centrado con los iconos de tareas de tus aplicaciones favoritas y zoom al pasar el ratón.
- ✅ **Menús Desplegables Nativos (Wayland Dialogs):** Haz clic en las píldoras de la barra para abrir paneles emergentes detallados:
  - 󰖙 **Clima:** Pronóstico meteorológico a 4 días con selector de día interactivo, sensación térmica, humedad y viento.
  - 󰃮 **Calendario:** Vista interactiva de mes completo con navegación de mes animada suavemente y fecha en vivo.
  - 󰁹 **Batería & Rendimiento:** Vista sin recortes con perfiles de energía (`Rendimiento 144Hz`, `Equilibrado`, `Ahorro de Batería`).
  - 󰤨 **Red & Tráfico:** SSID actual, IP Local, IP Pública y velocidad en tiempo real de bajada y subida.
  - 󰕾 **Control de Audio:** Deslizador de volumen maestro, selector de dispositivos de salida de sonido (auriculares, altavoces, HDMI) y presets rápidos.
  - 󰌌 **Distribución de Teclado:** Píldora interactiva para alternar entre `ES` y `US` con 1 solo clic.
  - ⏻ **Menú de Energía:** Menú emergente completo para Apagar, Reiniciar, Cerrar Sesión, Bloquear Pantalla y Suspender.
  - 󰏘 **Selector Rápido de Tema:** Conmutación instantánea y reactiva entre 8 temas oscuros y claros.
- ✅ **8 Esquemas de Color (Oscuros y Claros):**
  - **Oscuros:** `Obsidian` (Oficial Serpantinum), `Catppuccin Mocha`, `Cyber Emerald`, `Deep Amethyst`, `Neon Ruby`.
  - **Claros:** `Porcelain White`, `Catppuccin Latte`, `Nord Snow Polar`.
- ✅ **Control Total de Fondos:** Activa o desactiva la rotación de fondos (slideshow) y congela cualquier fondo como estático con 1 clic.
- ✅ **Widgets de Escritorio Modulares y Arrastrables:** 4 tarjetas flotantes independientes (Monitor de Hardware, Reloj Gigante, Clima y MPRIS) que puedes mover libremente con el ratón por la pantalla y activar o desactivar por separado.
- ✅ **Compatibilidad Universal:** Diseñado para funcionar en cualquier distribución Linux con KDE Plasma 6 (CachyOS, Arch Linux, Fedora, openSUSE, etc.) y en hardware híbrido (AMD + NVIDIA a 144Hz).

---

## 💎 Anatomía del Diseño (Copia Fiel de Serpantinum)

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ [⚙] [ ━ ] ● ● ● ● ● ● ● [ ♫ Title ⏮ ▶ ⏭ ]   [15 oct.] [ 17:32:27 ] [󰖙 22°C]   [󰏘] [󰕾] [EN] [󰤨 Red] [󰁹 100%] [⏻] │
└────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 1. Barra Superior Flotante (`org.serpanplasma.bar`)
- **Extremo Izquierdo:**
  - `[ ⚙ ]`: Botón para abrir el panel de configuración y guía Serpanplasma.
  - `[ ━ ] ● ● ● ● ● ● ●`: Píldora interactiva de 8 escritorios virtuales de KWin.
  - `[ ♪ Titulo - Artista ⏮ ▶ ⏭ ]`: Cápsula multimedia interactiva MPRIS.
- **Centro (Trío Simétrico Centrado):**
  - `[ 15 de oct. ]`: Píldora de fecha que despliega el calendario mensual interactivo.
  - `[ 17:32:27 ]`: **Reloj digital matemáticamente centrado** en la pantalla con tipografía JetBrains Mono Black.
  - `[ 󰖙 22.1°C ]`: Píldora de clima que despliega la tarjeta de pronóstico a 4 días.
- **Extremo Derecho:**
  - `[ 󰏘 ]`: Selector rápido de tema para alternar entre las 8 paletas oscuras y claras.
  - `[ 󰕾 ]`: Píldora de volumen con deslizador, preajustes y mute.
  - `[ EN / ES ]`: Indicador de teclado.
  - `[ 󰤨 Red ]`: Píldora blanca sólida con diálogo de red e IP local.
  - `[ 󰁹 100% ]`: Píldora blanca sólida de batería con selector de perfiles de energía.
  - `[ ⏻ ]`: Diálogo de apagado del sistema.

### 2. Dock de Aplicaciones Inferior
- Panel flotante centrado desacoplado del borde inferior de la pantalla.
- Iconos directos para Terminal (`kitty`/`konsole`), Explorador (`dolphin`), Navegador web, `Discord`, `Spotify` y Ajustes del Sistema.
- Indicadores discretos de aplicaciones en ejecución y soporte para arrastrar y fijar nuevos lanzadores.

### 3. Paletas de Color y Tipografía
- **Obsidian:** Fondo pizarra `#0f172a`, acentos `#38bdf8`, texto `#f8fafc`.
- **Porcelain Light:** Fondo `#f8fafc`, acentos `#0284c7`, texto `#0f172a`.
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
