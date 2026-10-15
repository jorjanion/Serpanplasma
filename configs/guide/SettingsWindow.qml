import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 960
    height: 640
    minimumWidth: 820
    minimumHeight: 560
    title: "Serpanplasma — Guía y Configuración"
    color: "#0a0f1d"

    property int currentTab: 0
    property string toastMessage: ""

    function showToast(msg) {
        toastMessage = msg;
        toastTimer.restart();
    }

    Timer {
        id: toastTimer
        interval: 3000
        onTriggered: window.toastMessage = ""
    }

    function sendCmd(action, val) {
        var url = "http://127.0.0.1:19842/cmd?action=" + action;
        if (val !== undefined && val !== "") {
            url += "&val=" + encodeURIComponent(val);
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (action === "next_wallpaper") showToast("Fondo de pantalla actualizado");
                else if (action === "apply_colorscheme") showToast("Esquema de color " + val + " aplicado");
                else if (action === "restart_kwin") showToast("Gestor KWin reconfigurado con éxito");
                else if (action === "restart_plasma") showToast("Entorno PlasmaShell recargado");
                else if (action === "set_bar_height") showToast("Altura de barra guardada (" + val + "px)");
                else if (action === "set_dock_height") showToast("Altura de dock guardada (" + val + "px)");
                else showToast("Acción ejecutada correctamente");
            }
        };
        xhr.send();
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==================== SIDEBAR ====================
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 240
            color: "#060913"

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#1e293b"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                // Header Branding
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    spacing: 12

                    Rectangle {
                        width: 36
                        height: 36
                        radius: 10
                        color: "#1e293b"
                        border.color: "#38bdf8"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "🐍"
                            font.pixelSize: 18
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: "Serpanplasma"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 15
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "Guía y Configuración"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                            color: "#94a3b8"
                        }
                    }
                }

                // Divider
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#1e293b"
                    Layout.topMargin: 4
                    Layout.bottomMargin: 8
                }

                // Navigation Tabs
                ListView {
                    id: tabsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4
                    boundsBehavior: Flickable.StopAtBounds

                    model: ListModel {
                        ListElement { title: "Bienvenida"; icon: "󰋜"; sub: "Inicio y resumen" }
                        ListElement { title: "Barra Superior"; icon: "󰹑"; sub: "Píldoras y módulos" }
                        ListElement { title: "Dock de Apps"; icon: "󰮯"; sub: "Lanzadores y estilo" }
                        ListElement { title: "Tema y Colores"; icon: "󰏘"; sub: "Obsidian & fuentes" }
                        ListElement { title: "Ventanas KWin"; icon: "󰈹"; sub: "Modo flotante libre" }
                        ListElement { title: "Wallpapers"; icon: "󰸉"; sub: "146 fondos y rotación" }
                        ListElement { title: "Sistema y Atajos"; icon: "󰒓"; sub: "Servicio y atajos" }
                        ListElement { title: "Acerca de"; icon: "󰋽"; sub: "Créditos y versión" }
                    }

                    delegate: Rectangle {
                        id: tabItem
                        width: tabsList.width
                        height: 44
                        radius: 10
                        color: (window.currentTab === index) ? "#1e293b" : (tabMouse.containsMouse ? "#0f172a" : "transparent")
                        border.color: (window.currentTab === index) ? "#334155" : "transparent"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }

                        // Cyan Active Pill Indicator
                        Rectangle {
                            visible: window.currentTab === index
                            anchors.left: parent.left
                            anchors.leftMargin: 4
                            anchors.verticalCenter: parent.verticalCenter
                            width: 3
                            height: 22
                            radius: 2
                            color: "#38bdf8"
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 10
                            spacing: 10

                            Text {
                                text: model.icon
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 15
                                color: (window.currentTab === index) ? "#38bdf8" : (tabMouse.containsMouse ? "#f8fafc" : "#94a3b8")
                            }

                            Text {
                                text: model.title
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                font.weight: (window.currentTab === index) ? Font.Bold : Font.Normal
                                color: (window.currentTab === index) ? "#f8fafc" : (tabMouse.containsMouse ? "#f8fafc" : "#cbd5e1")
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: tabMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: window.currentTab = index
                        }
                    }
                }

                // Quick links at bottom
                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 10
                    color: repoMouse.containsMouse ? "#1e293b" : "#0f172a"
                    border.color: "#1e293b"
                    border.width: 1

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "󰊤"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: "#38bdf8"
                        }
                        Text {
                            text: "GitHub Repository"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#f8fafc"
                        }
                    }

                    MouseArea {
                        id: repoMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.sendCmd("open_url", "https://github.com/jorjanion/Serpanplasma")
                    }
                }
            }
        }

        // ==================== MAIN CONTENT ====================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            StackLayout {
                id: contentStack
                anchors.fill: parent
                anchors.margins: 28
                currentIndex: window.currentTab

                // ---------------- TAB 0: BIENVENIDA ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        // Hero Banner
                        Rectangle {
                            Layout.fillWidth: true
                            height: 150
                            radius: 14
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 22
                                spacing: 20

                                Rectangle {
                                    width: 76
                                    height: 76
                                    radius: 20
                                    color: "#1e293b"
                                    border.color: "#38bdf8"
                                    border.width: 1.5

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🐍"
                                        font.pixelSize: 36
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    RowLayout {
                                        spacing: 10
                                        Text {
                                            text: "¡Bienvenido a Serpanplasma!"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 20
                                            font.weight: Font.Black
                                            color: "#f8fafc"
                                        }
                                        Rectangle {
                                            width: 48
                                            height: 20
                                            radius: 6
                                            color: "#0284c7"
                                            Text {
                                                anchors.centerIn: parent
                                                text: "v1.0.0"
                                                font.family: "JetBrainsMono Nerd Font"
                                                font.pixelSize: 10
                                                font.weight: Font.Bold
                                                color: "#ffffff"
                                            }
                                        }
                                    }

                                    Text {
                                        text: "La experiencia estética minimalista de Serpantinum (ilyamiro) clonada para KDE Plasma 6 sobre Wayland, con gestión de ventanas tradicional flotante estilo Windows."
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 11
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Feature Grid (4 Cards)
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 14
                            columnSpacing: 14

                            // Card 1: Ventanas
                            Rectangle {
                                Layout.fillWidth: true
                                height: 110
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4

                                    RowLayout {
                                        spacing: 8
                                        Text { text: "🪟"; font.pixelSize: 16 }
                                        Text {
                                            text: "Ventanas Flotantes Libres"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 12
                                            font.weight: Font.Bold
                                            color: "#38bdf8"
                                        }
                                    }
                                    Text {
                                        text: "Sin tiling forzado. Las aplicaciones se abren centradas, superponibles, arrastrables y con atajos clásicos Alt+F4 y Alt+Tab."
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            // Card 2: Barra de Píldoras
                            Rectangle {
                                Layout.fillWidth: true
                                height: 110
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4

                                    RowLayout {
                                        spacing: 8
                                        Text { text: "💊"; font.pixelSize: 16 }
                                        Text {
                                            text: "Barra Superior Flotante"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 12
                                            font.weight: Font.Bold
                                            color: "#38bdf8"
                                        }
                                    }
                                    Text {
                                        text: "Cápsulas dedicadas para workspaces, reproductor multimedia, reloj apilado en español, clima en vivo y píldoras blancas de red y batería."
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            // Card 3: Dock de Aplicaciones
                            Rectangle {
                                Layout.fillWidth: true
                                height: 110
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4

                                    RowLayout {
                                        spacing: 8
                                        Text { text: "⚓"; font.pixelSize: 16 }
                                        Text {
                                            text: "Dock Inferior Centrado"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 12
                                            font.weight: Font.Bold
                                            color: "#38bdf8"
                                        }
                                    }
                                    Text {
                                        text: "Panel flotante inferior desacoplado con tus aplicaciones principales ancladas (Terminal, Dolphin, Navegador, Discord, Spotify)."
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            // Card 4: Tema Obsidian
                            Rectangle {
                                Layout.fillWidth: true
                                height: 110
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 4

                                    RowLayout {
                                        spacing: 8
                                        Text { text: "🎨"; font.pixelSize: 16 }
                                        Text {
                                            text: "Paleta Obsidian"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 12
                                            font.weight: Font.Bold
                                            color: "#38bdf8"
                                        }
                                    }
                                    Text {
                                        text: "Esquema oscuro pizarra profundo (#0f172a), desenfoque translúcido KWin, acentos cian y tipografía JetBrains Mono SemiBold."
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Quick Navigation Actions
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#38bdf8"
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰹑 Configurar Barra"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: window.currentTab = 1
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰮯 Configurar Dock"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: window.currentTab = 2
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰏘 Personalizar Tema"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: window.currentTab = 3
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 1: BARRA SUPERIOR ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: "Configuración de la Barra Superior"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "Ajusta la altura de la barra flotante y personaliza el comportamiento de los módulos y píldoras."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // Altura
                        Rectangle {
                            Layout.fillWidth: true
                            height: 80
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 4

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text {
                                        text: "Altura de la barra flotante"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 12
                                        font.weight: Font.Bold
                                        color: "#f8fafc"
                                    }
                                    Item { Layout.fillWidth: true }
                                    Text {
                                        text: Math.round(barSlider.value) + " px"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 12
                                        font.weight: Font.Bold
                                        color: "#38bdf8"
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider {
                                        id: barSlider
                                        Layout.fillWidth: true
                                        from: 32
                                        to: 48
                                        value: 38
                                        stepSize: 1
                                    }
                                    Rectangle {
                                        width: 80
                                        height: 28
                                        radius: 6
                                        color: "#1e293b"
                                        border.color: "#38bdf8"
                                        border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: "Guardar"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 11
                                            font.weight: Font.Bold
                                            color: "#38bdf8"
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: window.sendCmd("set_bar_height", Math.round(barSlider.value))
                                        }
                                    }
                                }
                            }
                        }

                        // Módulos Visibles
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: modCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: modCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text {
                                    text: "Módulos Integrados de Serpantinum"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }

                                Text { text: "✔  [ ⚙ ] Botón de Ajustes y Guía (Abre este panel)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  [ ━ ] ● ● ● Módulo de Espacios de Trabajo (Píldora expandida + 7 puntos)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  [ ♪ Titulo ⏮ ▶ ⏭ ] Cápsula Multimedia interactiva con MPRIS"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  Reloj Digital Apilado (Hora en negrita + fecha completa en español)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  Cápsula de Clima geolocalizada en tiempo real (Open-Meteo)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  [ 󰕾 ] Control de Volumen (Rueda de ratón para regular y clic para silenciar)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  [ 󰤨 Connected ] Cápsula sólida blanca de conexión de red Wi-Fi / Ethernet"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  [ 󰁹 100% ] Cápsula sólida blanca de nivel de batería y carga"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  [ ⏻ ] Botón circular de apagado y cierre de sesión"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                            }
                        }

                        // Acción
                        Rectangle {
                            Layout.fillWidth: true
                            height: 42
                            radius: 10
                            color: "#1e293b"
                            border.color: "#38bdf8"
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text {
                                    text: "Recargar Barra Superior y PlasmaShell"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: window.sendCmd("restart_plasma")
                            }
                        }
                    }
                }

                // ---------------- TAB 2: DOCK DE APPS ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: "Dock de Aplicaciones Inferior"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "Configura el tamaño, visibilidad y las aplicaciones ancladas en el dock flotante."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // Altura
                        Rectangle {
                            Layout.fillWidth: true
                            height: 80
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 4

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text {
                                        text: "Tamaño / Altura del Dock"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 12
                                        font.weight: Font.Bold
                                        color: "#f8fafc"
                                    }
                                    Item { Layout.fillWidth: true }
                                    Text {
                                        text: Math.round(dockSlider.value) + " px"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 12
                                        font.weight: Font.Bold
                                        color: "#38bdf8"
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider {
                                        id: dockSlider
                                        Layout.fillWidth: true
                                        from: 44
                                        to: 68
                                        value: 54
                                        stepSize: 1
                                    }
                                    Rectangle {
                                        width: 80
                                        height: 28
                                        radius: 6
                                        color: "#1e293b"
                                        border.color: "#38bdf8"
                                        border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: "Guardar"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 11
                                            font.weight: Font.Bold
                                            color: "#38bdf8"
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: window.sendCmd("set_dock_height", Math.round(dockSlider.value))
                                        }
                                    }
                                }
                            }
                        }

                        // Lanzadores actuales
                        Rectangle {
                            Layout.fillWidth: true
                            height: 120
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 10

                                Text {
                                    text: "Lanzadores Anclados por Defecto"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }

                                RowLayout {
                                    spacing: 12
                                    Rectangle { width: 36; height: 36; radius: 8; color: "#1e293b"; Text { anchors.centerIn: parent; text: "󰞷"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 36; height: 36; radius: 8; color: "#1e293b"; Text { anchors.centerIn: parent; text: "󰉋"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 36; height: 36; radius: 8; color: "#1e293b"; Text { anchors.centerIn: parent; text: "󰇧"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 36; height: 36; radius: 8; color: "#1e293b"; Text { anchors.centerIn: parent; text: "󰙯"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 36; height: 36; radius: 8; color: "#1e293b"; Text { anchors.centerIn: parent; text: "󰓇"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 36; height: 36; radius: 8; color: "#1e293b"; Text { anchors.centerIn: parent; text: "󰒓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 3: TEMA Y COLORES ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: "Esquemas de Color & Tipografía"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "Selecciona una paleta de color para el entorno KDE Plasma y las decoraciones de ventana."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // Palette Cards
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 12
                            columnSpacing: 12

                            // Obsidian (Recomendado)
                            Rectangle {
                                Layout.fillWidth: true
                                height: 110
                                radius: 12
                                color: "#0f172a"
                                border.color: "#38bdf8"
                                border.width: 1.5

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 8

                                    RowLayout {
                                        Text { text: "Obsidian (Serpantinum Oficial)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: "#38bdf8"
                                            Text { anchors.centerIn: parent; text: "Activar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#0f172a" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("apply_colorscheme", "Serpanplasma-Obsidian") }
                                        }
                                    }

                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#0f172a"; border.color: "#334155"; border.width: 1 }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#1e293b" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#38bdf8" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#f8fafc" }
                                        Text { text: "#0f172a / #1e293b / #38bdf8"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }

                            // Breeze Dark
                            Rectangle {
                                Layout.fillWidth: true
                                height: 110
                                radius: 12
                                color: "#0f172a"
                                border.color: "#1e293b"
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 8

                                    RowLayout {
                                        Text { text: "Breeze Dark"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                        Item { Layout.fillWidth: true }
                                        Rectangle {
                                            width: 60; height: 22; radius: 6; color: "#1e293b"; border.color: "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: "Activar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("apply_colorscheme", "BreezeDark") }
                                        }
                                    }

                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#232629" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#31363b" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#3daee9" }
                                        Rectangle { width: 22; height: 22; radius: 5; color: "#eff0f1" }
                                        Text { text: "#232629 / #3daee9"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                    }
                                }
                            }
                        }

                        // Tipografía
                        Rectangle {
                            Layout.fillWidth: true
                            height: 90
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 6

                                Text { text: "Tipografía Oficial del Sistema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                Text { text: "JetBrains Mono Nerd Font SemiBold (Instalada en ~/.local/share/fonts/)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#38bdf8" }
                                Text { text: "The quick brown fox jumps over the lazy dog 0123456789"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                            }
                        }
                    }
                }

                // ---------------- TAB 4: VENTANAS KWIN ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: "Gestión de Ventanas Flotante (Windows Style)"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "KWin configurado para ventanas libres que se superponen libremente, sin gestor en mosaico."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: winCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: winCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Text { text: "Reglas de Comportamiento Activas"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                Text { text: "✔  Apertura de Ventanas: Centrada (Placement=Centered)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  Enfoque: Clic para enfocar y traer al frente automáticamente (ClickRaise=true)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  Botones Clásicos: Minimizar (_), Maximizar (□) y Cerrar (X)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  Bordes y Esquinas: Redondeadas con radio de 12px y sombra sutil del 35%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                Text { text: "✔  Compositor: 144Hz a baja latencia con efectos de Desenfoque (Blur) y Escala"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 42
                            radius: 10
                            color: "#1e293b"
                            border.color: "#38bdf8"
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text {
                                    text: "Reconfigurar Gestor de Ventanas KWin"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    color: "#f8fafc"
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: window.sendCmd("restart_kwin")
                            }
                        }
                    }
                }

                // ---------------- TAB 5: WALLPAPERS ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: "Colección de Fondos de Pantalla"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "Diapositivas automáticas configuradas con los 146 fondos descargados en ~/Imágenes/Wallpapers/."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 110
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 10

                                RowLayout {
                                    Text { text: "Carpeta de Fondos:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    Text { text: "~/Imágenes/Wallpapers/ (146 imágenes)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#38bdf8" }
                                }

                                RowLayout {
                                    spacing: 12
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 36
                                        radius: 8
                                        color: "#38bdf8"
                                        Text {
                                            anchors.centerIn: parent
                                            text: "󰒭 Siguiente Fondo de Pantalla"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 11
                                            font.weight: Font.Bold
                                            color: "#0f172a"
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: window.sendCmd("next_wallpaper")
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 36
                                        radius: 8
                                        color: "#1e293b"
                                        border.color: "#334155"
                                        border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: "󰸉 Abrir Carpeta en Dolphin"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 11
                                            font.weight: Font.Bold
                                            color: "#f8fafc"
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: window.sendCmd("open_wallpapers")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 6: SISTEMA Y ATAJOS ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 18

                        Text {
                            text: "Atajos de Teclado y Demonio del Sistema"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            font.weight: Font.Black
                            color: "#f8fafc"
                        }

                        Text {
                            text: "Atajos clásicos de Windows integrados nativamente en KDE Plasma 6."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: keyCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: keyCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                RowLayout {
                                    Text { text: "Alt + F4"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: "Cerrar la ventana activa"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: "Alt + Tab"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: "Alternar entre ventanas abiertas"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: "Win + Arriba"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: "Maximizar la ventana activa"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: "Win + Abajo"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: "Restaurar o minimizar la ventana activa"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                                RowLayout {
                                    Text { text: "Win + E"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8"; Layout.preferredWidth: 120 }
                                    Text { text: "Abrir el explorador de archivos Dolphin"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                }
                            }
                        }
                    }
                }

                // ---------------- TAB 7: ACERCA DE ----------------
                ScrollView {
                    contentWidth: -1
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Rectangle {
                            Layout.fillWidth: true
                            height: 220
                            radius: 14
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 10

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 64
                                    height: 64
                                    radius: 16
                                    color: "#1e293b"
                                    border.color: "#38bdf8"
                                    border.width: 1.5

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🐍"
                                        font.pixelSize: 32
                                    }
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Serpanplasma"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 22
                                    font.weight: Font.Black
                                    color: "#f8fafc"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Versión 1.0.0 (Release Estable)"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 11
                                    color: "#38bdf8"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Inspirado por el entorno Serpantinum de ilyamiro.\nAdaptado para KDE Plasma 6 sobre Wayland por jorjanion."
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    color: "#94a3b8"
                                }
                            }
                        }
                    }
                }
            }

            // Toast feedback message bar
            Rectangle {
                visible: window.toastMessage !== ""
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 14
                height: 36
                radius: 18
                color: "#1e293b"
                border.color: "#38bdf8"
                border.width: 1
                implicitWidth: toastText.implicitWidth + 30

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "✔"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#38bdf8" }
                    Text {
                        id: toastText
                        text: window.toastMessage
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: "#f8fafc"
                    }
                }
            }
        }
    }
}
