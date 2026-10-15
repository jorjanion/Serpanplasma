<div align="center">

# 🐍 Serpanplasma

**Clon estético exacto de *Serpantinum* adaptado al 100% para KDE Plasma 6 (Wayland) con gestión de ventanas tradicional y flotante.**

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

**Serpanplasma** nace para quienes aman la **estética visual limpia, minimalista y moderna** de [Serpantinum](https://github.com/ilyamiro/serpantinum) (el entorno de ilyamiro basado en Quickshell), pero desean mantener la **comodidad, estabilidad y flujo de trabajo tradicional de Windows** en **KDE Plasma 6 sobre Wayland**.

### ¿Por qué Serpanplasma?
- ❌ **Sin gestores en mosaico forzados (Tiling como Hyprland/Niri):** No necesitas aprender atajos complejos de teclado ni lidiar con ventanas que se dividen solas en la pantalla.
- ✅ **Ventanas flotantes reales y libres:** Las aplicaciones se abren centradas, con un tamaño inicial cómodo, se pueden arrastrar con el ratón, superponer libremente y traen los botones clásicos (**_**, **□**, **X**).
- ✅ **Atajos estándar de Windows:** `Alt + F4`, `Alt + Tab`, `Win + Flecha Arriba`, `Win + Flecha Abajo` y `Win + E` (Dolphin).
- ✅ **Barra superior flotante con píldoras:** Panel superior desacoplado de los bordes con efecto de desenfoque translúcido (*Blur*), esquinas redondeadas y módulos agrupados en cápsulas estéticas.
- ✅ **Compatibilidad universal:** Diseñado para funcionar en cualquier distribución Linux con KDE Plasma 6 (Arch, CachyOS, Fedora, openSUSE, Debian, etc.) y en hardware híbrido (AMD + NVIDIA a 144Hz).

---

## ✨ Características Principales

### 1. Barra Superior Flotante con Píldoras (Top Bar)
- **Modo flotante desacoplado:** Separado de la parte superior y de los bordes laterales con esquinas redondeadas (*Border radius* de 14-16px).
- **Efecto de desenfoque (*Blur*):** Fondo oscuro translúcido en tono pizarra (`#0f172a` al 85% de opacidad) procesado por el compositor de KWin.
- **Distribución de elementos:**
  - **Izquierda:** Lanzador de aplicaciones minimalista con el isotipo de Serpanplasma + Widget reproductor multimedia con controles directos (MPRIS / Spotify / Navegador).
  - **Centro:** Reloj digital con fecha completa en español (`dddd, d 'de' MMMM`) utilizando la tipografía **JetBrains Mono SemiBold**.
  - **Derecha:** Widget del clima (icono + temperatura), cápsula de estado (Batería, Red Wi-Fi/Ethernet, Volumen) y bandeja del sistema minimalista.

### 2. Gestión de Ventanas Flotante (Windows Style)
- Apertura centrada automática de todas las ventanas (`Placement=Centered`).
- Click-to-raise automático: hacer clic sobre cualquier ventana inactiva la enfoca y la trae inmediatamente al frente.
- Decoración de ventanas elegante con sombra ambiental sutil, bordes redondeados y botones claros de minimizar, maximizar y cerrar.
- Soporte completo para pantallas de 144Hz y gráficas híbridas sin *tearing* ni latencia bajo Wayland.

### 3. Paleta de Colores "Obsidian" & Tipografía
- **Fondo principal:** Tonos pizarra y azul profundo oscuro (`#0f172a`, `#1e293b`).
- **Acentos:** Azul cielo / Cian brillante (`#38bdf8`, `#7dd3fc`).
- **Textos:** Blanco nieve de alto contraste (`#f8fafc`) y gris pizarra suave para elementos secundarios (`#94a3b8`).
- **Tipografía del sistema:** **JetBrains Mono SemiBold** para títulos de ventanas, reloj, menús y emuladores de terminal.

### 4. Colección de Fondos de Pantalla
- Configuración automática de diapositivas (*Slideshow*) cada 15 minutos utilizando la carpeta `~/Imágenes/Wallpapers/` (o cualquier directorio con imágenes que tengas en tu equipo).

---

## ⌨️ Atajos de Teclado Configurados

| Atajo | Acción |
| :--- | :--- |
| <kbd>Alt</kbd> + <kbd>F4</kbd> | Cerrar la ventana activa |
| <kbd>Alt</kbd> + <kbd>Tab</kbd> | Alternar entre ventanas abiertas |
| <kbd>Super (Win)</kbd> + <kbd>↑</kbd> | Maximizar ventana |
| <kbd>Super (Win)</kbd> + <kbd>↓</kbd> | Restaurar / Minimizar ventana |
| <kbd>Super (Win)</kbd> + <kbd>E</kbd> | Abrir el explorador de archivos **Dolphin** |
| <kbd>Super (Win)</kbd> | Abrir el menú lanzador de aplicaciones |
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd> | Abrir terminal |

---

## 🚀 Instalación Rápida (1 Comando)

### Prerrequisitos
- KDE Plasma 6 (Wayland)
- Git y cURL instalados

### Instalación Automática
Clona el repositorio y ejecuta el instalador:

```bash
git clone https://github.com/jorjanion/Serpanplasma.git
cd Serpanplasma
chmod +x install.sh restore.sh
./install.sh
```

El instalador se encarga automáticamente de:
1. Crear una **copia de seguridad completa** de tu configuración previa de KDE Plasma en `~/.config/serpanplasma-backup/`.
2. Instalar y registrar la tipografía **JetBrains Mono Nerd Font SemiBold**.
3. Instalar y activar el esquema de colores **Serpanplasma-Obsidian**.
4. Instalar y activar el tema de escritorio de Plasma con efecto *Blur* flotante.
5. Configurar las decoraciones de ventana Breeze y reglas de KWin (modo flotante, centrado, 144Hz).
6. Configurar los atajos de teclado estándar de Windows.
7. Crear la barra superior flotante con el orden y distribución exactos.
8. Configurar perfiles para terminales (Konsole, Kitty, Alacritty) y Fastfetch.
9. Configurar la rotación de fondos de pantalla desde `~/Imágenes/Wallpapers/`.

---

## 🔄 Desinstalación y Restauración

Si en cualquier momento deseas volver a tu configuración anterior exacta de KDE Plasma, ejecuta:

```bash
./restore.sh
```

El script restaurará automáticamente los archivos de configuración desde la copia de seguridad generada previamente y devolverá los temas a sus valores por defecto.

---

## 📂 Estructura del Repositorio

```
Serpanplasma/
├── install.sh                              # Script automatizado de instalación
├── restore.sh                              # Script de restauración de backups
├── README.md                               # Documentación y guía del usuario
├── fonts/                                  # Tipografías JetBrains Mono Nerd Font
├── themes/
│   ├── color-schemes/
│   │   └── Serpanplasma-Obsidian.colors    # Esquema de color (#0f172a, #1e293b, #38bdf8)
│   ├── plasma/desktoptheme/Serpanplasma/   # Tema de Plasma 6 (SVG con blur y esquinas redondeadas)
│   │   ├── metadata.json
│   │   ├── colors
│   │   ├── widgets/
│   │   │   ├── panel-background.svg        # Fondo del panel flotante con máscara de desenfoque
│   │   │   └── ...                         # Botones, tooltips, dialogs, tasks en estilo píldora
│   │   └── icons/                          # Iconos SVG de estado (batería, volumen, red, etc.)
│   └── window-decorations/
│       └── breezerc                        # Configuración de esquinas redondeadas y sombras
├── configs/
│   ├── kwin/kwinrc                         # Configuración KWin (Placement=Centered, 144Hz, Blur)
│   ├── shortcuts/kglobalshortcutsrc        # Atajos de teclado Windows (Alt+F4, Alt+Tab, etc.)
│   ├── terminal/                           # Perfiles para Konsole, Kitty y Alacritty
│   └── fastfetch/config.jsonc              # Fastfetch estilizado con specs y paleta Obsidian
├── scripts/
│   ├── setup-panel.js                      # Script DBus de Plasma para crear la Top Bar flotante
│   └── setup-wallpapers.js                 # Script para configurar rotación de fondos
└── assets/
    ├── icons/serpanplasma-launcher.svg     # Icono minimalista de serpiente para el lanzador
    └── preview.png                         # Captura de pantalla de demostración
```

---

## 🎨 Pantalla de Inicio de Sesión (SDDM)

Para complementar la estética al 100%, se recomienda el tema de SDDM **material-you** (originalmente utilizado en Serpantinum por Darkall44/Qylock):

- Repositorio del tema: [sddm-theme-material-you](https://github.com/Darkall44/sddm-theme-material-you)
- Si estás en Arch Linux / CachyOS, puedes instalarlo directamente o colocar la carpeta en `/usr/share/sddm/themes/`.

---

## 👥 Créditos y Agradecimientos

- **[Illia Miroshnichenko (ilyamiro)](https://github.com/ilyamiro):** Por la inspiración y el diseño original del concepto minimalista en [Serpantinum](https://github.com/ilyamiro/serpantinum).
- **KDE Visual Design Group & CachyOS Team:** Por las herramientas de personalización y base de compositor de KDE Plasma 6.
- **Autor de la adaptación para KDE:** Jorge ([@jorjanion](https://github.com/jorjanion)).

---

<div align="center">
Hecho con ❤️ para la comunidad de KDE Plasma y Linux.
</div>
