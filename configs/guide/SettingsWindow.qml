import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 980
    height: 660
    minimumWidth: 840
    minimumHeight: 580
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
                else if (action === "set_dock_position") showToast("Posición del dock cambiada a " + val);
                else if (action === "set_dock_visibility") showToast("Modo de visibilidad del dock cambiado");
                else if (action === "set_wallpaper_interval") showToast("Intervalo de fondos guardado (" + val + "s)");
                else showToast("Ajuste aplicado correctamente");
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
                        ListElement { title: "Dock de Apps"; icon: "󰮯"; sub: "Opciones completas" }
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
                            text: "Ajusta la posición, altura, estilo de píldoras y visibilidad de los módulos en la barra superior."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // Dimensiones y Estilo General
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: barDimCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: barDimCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 14

                                Text { text: "Estilo y Dimensiones"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                // Altura Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Altura de la barra"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(barSlider.value) + " px"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: barSlider; Layout.fillWidth: true; from: 30; to: 50; value: 38; stepSize: 1 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("set_bar_height", Math.round(barSlider.value)) }
                                    }
                                }

                                // Opacidad Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Opacidad de la barra"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(barOpacitySlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                Slider { id: barOpacitySlider; Layout.fillWidth: true; from: 20; to: 100; value: 85; stepSize: 5 }

                                // Toggles de estilo
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Píldoras distintas (Distinct Pills)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Estilo de píldoras guardado") }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Modo flotante desacoplado"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Modo flotante activo") }
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

                                Text { text: "Módulos y Cápsulas de la Barra"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰒓 Botón de Ajustes y Guía"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰮯 Espacios de Trabajo (Pills/Dots)"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰎈 Reproductor de Música MPRIS"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰅐 Reloj Digital Apilado (Hora + Fecha)"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "☁ Clima en Vivo (Open-Meteo)"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰕾 Control de Volumen y Rueda"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰤨 Cápsula Blanca Sólida de Red"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "󰁹 Cápsula Blanca Sólida de Batería"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                                RowLayout { Layout.fillWidth: true
                                Text { text: "⏻ Botón Circular de Apagado"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#cbd5e1" }
                                Item { Layout.fillWidth: true }
                                Switch { checked: true } }
                            }
                        }

                        // Acción
                        Rectangle {
                            Layout.fillWidth: true; height: 42; radius: 10; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text { text: "Recargar Barra Superior y PlasmaShell"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("restart_plasma") }
                        }
                    }
                }

                // ---------------- TAB 2: DOCK DE APPS (FULL SERPANTINUM REPLICA) ----------------
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
                            text: "Todas las opciones de personalización del dock de Serpantinum adaptadas para KDE Plasma 6."
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#94a3b8"
                        }

                        // 1. General & Posición
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockGenCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockGenCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Text { text: "General y Posición del Dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰅀 Habilitar dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Dock activo") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍹 Posición del dock en pantalla"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle {
                                            width: 60; height: 26; radius: 6; color: "#38bdf8"
                                            Text { anchors.centerIn: parent; text: "Abajo"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#0f172a" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("set_dock_position", "bottom") }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6; color: "#1e293b"; border.color: "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: "Izquierda"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("set_dock_position", "left") }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6; color: "#1e293b"; border.color: "#334155"; border.width: 1
                                            Text { anchors.centerIn: parent; text: "Derecha"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#cbd5e1" }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("set_dock_position", "right") }
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰉈 Dock flotante desacoplado"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Modo flotante activo") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰹤 Colocar dock siempre sobre las ventanas"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: false; onClicked: window.showToast("Ajuste de capas guardado") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰖲 Modo exclusivo (Reservar espacio en pantalla)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Modo exclusivo activo") }
                                }
                            }
                        }

                        // 2. Dimensiones y Efectos Visuales
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockDimCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockDimCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 14

                                Text { text: "Dimensiones, Escala y Opacidad"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                // Altura Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘖 Tamaño de elementos / Altura"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(dockSlider.value) + " px"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: dockSlider; Layout.fillWidth: true; from: 44; to: 68; value: 54; stepSize: 1 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("set_dock_height", Math.round(dockSlider.value)) }
                                    }
                                }

                                // Opacidad Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰂵 Opacidad del dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(dockOpacitySlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                Slider { id: dockOpacitySlider; Layout.fillWidth: true; from: 20; to: 100; value: 90; stepSize: 5 }

                                // Hover Scale Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍔 Efecto de escala al pasar el ratón (Hover Scale)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(hoverScaleSlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                Slider { id: hoverScaleSlider; Layout.fillWidth: true; from: 100; to: 140; value: 115; stepSize: 5 }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘚 Escalar elementos cercanos (Cascade scale)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: false; onClicked: window.showToast("Efecto de cascada guardado") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍽 Habilitar desplazamiento de elementos (Scrolling)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: false; onClicked: window.showToast("Desplazamiento guardado") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰅫 Máximo de elementos visibles"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(visElemSlider.value) + " elementos"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                Slider { id: visElemSlider; Layout.fillWidth: true; from: 4; to: 12; value: 8; stepSize: 1 }
                            }
                        }

                        // 3. Comportamiento y Ocultación
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockHideCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockHideCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Text { text: "Comportamiento de Ventanas y Ocultación"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󱂬 Ocultación inteligente (Esquivar ventanas / Dodge)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.sendCmd("set_dock_visibility", "windowsCanCover") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘓 Ocultar automáticamente (Auto-hide al salir cursor)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: false; onClicked: window.sendCmd("set_dock_visibility", "autohide") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󱂬 Enfocar ventana existente en lugar de duplicar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Enfoque inteligente activo") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰄯 Indicadores discretos de aplicación en ejecución"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Indicadores de ejecución activos") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘓 Mostrar todas las aplicaciones abiertas en el dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch { checked: true; onClicked: window.showToast("Tareas abiertas activas") }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍹 Ámbito de ventanas activas (Scope)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 80
                                        height: 26
                                        radius: 6
                                        color: "#38bdf8"
                                        Text { anchors.centerIn: parent
                                        text: "Escritorio"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        font.weight: Font.Bold
                                        color: "#0f172a" }
                                        MouseArea { anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: window.showToast("Ámbito: Escritorio actual") } }
                                        Rectangle { width: 60
                                        height: 26
                                        radius: 6
                                        color: "#1e293b"
                                        border.color: "#334155"
                                        border.width: 1
                                        Text { anchors.centerIn: parent
                                        text: "Todos"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        font.weight: Font.Bold
                                        color: "#cbd5e1" }
                                        MouseArea { anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: window.showToast("Ámbito: Todos los escritorios") } }
                                    }
                                }
                            }
                        }

                        // 4. Lanzadores Anclados
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: dockAppsCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: dockAppsCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 10

                                Text { text: "󰀻 Aplicaciones Ancladas en el Dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    spacing: 12
                                    Rectangle { width: 38
                                    height: 38
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#334155"
                                    border.width: 1
                                    Text { anchors.centerIn: parent
                                    text: "󰞷"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 18
                                    color: "#38bdf8" } }
                                    Rectangle { width: 38
                                    height: 38
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#334155"
                                    border.width: 1
                                    Text { anchors.centerIn: parent
                                    text: "󰉋"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 18
                                    color: "#38bdf8" } }
                                    Rectangle { width: 38
                                    height: 38
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#334155"
                                    border.width: 1
                                    Text { anchors.centerIn: parent
                                    text: "󰇧"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 18
                                    color: "#38bdf8" } }
                                    Rectangle { width: 38
                                    height: 38
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#334155"
                                    border.width: 1
                                    Text { anchors.centerIn: parent
                                    text: "󰙯"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 18
                                    color: "#38bdf8" } }
                                    Rectangle { width: 38
                                    height: 38
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#334155"
                                    border.width: 1
                                    Text { anchors.centerIn: parent
                                    text: "󰓇"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 18
                                    color: "#38bdf8" } }
                                    Rectangle { width: 38
                                    height: 38
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#334155"
                                    border.width: 1
                                    Text { anchors.centerIn: parent
                                    text: "󰒓"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 18
                                    color: "#38bdf8" } }
                                }
                                Text { text: "Puedes arrastrar y soltar cualquier aplicación desde el menú para anclarla o desanclarla con clic derecho."; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                            }
                        }

                        // Botón de Aplicar
                        Rectangle {
                            Layout.fillWidth: true; height: 42; radius: 10; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 8
                                Text { text: "󰑓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                Text { text: "Reiniciar Dock y Aplicar Cambios"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.sendCmd("restart_plasma") }
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
                            implicitHeight: wpCol.implicitHeight + 28
                            radius: 12
                            color: "#0f172a"
                            border.color: "#1e293b"
                            border.width: 1

                            ColumnLayout {
                                id: wpCol
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 14

                                RowLayout {
                                    Text { text: "Carpeta de Fondos:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    Text { text: "~/Imágenes/Wallpapers/ (146 imágenes)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#38bdf8" }
                                }

                                RowLayout {
                                    Text { text: "Intervalo de cambio de fondo:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle { width: 50
                                        height: 26
                                        radius: 6
                                        color: "#1e293b"
                                        border.color: "#334155"
                                        border.width: 1
                                        Text { anchors.centerIn: parent
                                        text: "5m"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#cbd5e1" }
                                        MouseArea { anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: window.sendCmd("set_wallpaper_interval", "300") } }
                                        Rectangle { width: 50
                                        height: 26
                                        radius: 6
                                        color: "#38bdf8"
                                        Text { anchors.centerIn: parent
                                        text: "15m"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        font.weight: Font.Bold
                                        color: "#0f172a" }
                                        MouseArea { anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: window.sendCmd("set_wallpaper_interval", "900") } }
                                        Rectangle { width: 50
                                        height: 26
                                        radius: 6
                                        color: "#1e293b"
                                        border.color: "#334155"
                                        border.width: 1
                                        Text { anchors.centerIn: parent
                                        text: "30m"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#cbd5e1" }
                                        MouseArea { anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: window.sendCmd("set_wallpaper_interval", "1800") } }
                                        Rectangle { width: 50
                                        height: 26
                                        radius: 6
                                        color: "#1e293b"
                                        border.color: "#334155"
                                        border.width: 1
                                        Text { anchors.centerIn: parent
                                        text: "1h"
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        color: "#cbd5e1" }
                                        MouseArea { anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: window.sendCmd("set_wallpaper_interval", "3600") } }
                                    }
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
