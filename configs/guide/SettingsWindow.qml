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

    // Reactive Settings State
    property bool barFloating: true
    property int barHeight: 38
    property int barOpacity: 85
    property bool barDistinctPills: true
    property bool barModSettings: true
    property bool barModWorkspaces: true
    property bool barModMedia: true
    property bool barModClock: true
    property bool barModWeather: true
    property bool barModVolume: true
    property bool barModNetwork: true
    property bool barModBattery: true
    property bool barModPower: true

    property bool dockEnabled: true
    property string dockPosition: "bottom"
    property bool dockFloating: true
    property bool dockLayerTop: false
    property bool dockExclusive: true
    property int dockHeight: 54
    property int dockOpacity: 90
    property int hoverScale: 115
    property bool cascadeScale: false
    property bool scrolling: false
    property int visibleElements: 8
    property string dockVisibility: "dodgewindows"
    property bool smartFocus: true
    property bool runningIndicators: true
    property bool showAllTasks: true
    property string activeScope: "current"
    property int wallpaperInterval: 900

    function showToast(msg) {
        toastMessage = msg;
        toastTimer.restart();
    }

    Timer {
        id: toastTimer
        interval: 3200
        onTriggered: window.toastMessage = ""
    }

    function sendCmd(action, val, mod) {
        var url = "http://127.0.0.1:19842/cmd?action=" + action;
        if (val !== undefined && val !== "") {
            url += "&val=" + encodeURIComponent(val);
        }
        if (mod !== undefined && mod !== "") {
            url += "&mod=" + encodeURIComponent(mod);
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.send();
    }

    function loadSettings() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/status");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    if (d.bar_floating !== undefined) window.barFloating = d.bar_floating;
                    if (d.bar_height !== undefined) window.barHeight = d.bar_height;
                    if (d.bar_opacity !== undefined) window.barOpacity = d.bar_opacity;
                    if (d.bar_distinct_pills !== undefined) window.barDistinctPills = d.bar_distinct_pills;
                    if (d.bar_mod_settings !== undefined) window.barModSettings = d.bar_mod_settings;
                    if (d.bar_mod_workspaces !== undefined) window.barModWorkspaces = d.bar_mod_workspaces;
                    if (d.bar_mod_media !== undefined) window.barModMedia = d.bar_mod_media;
                    if (d.bar_mod_clock !== undefined) window.barModClock = d.bar_mod_clock;
                    if (d.bar_mod_weather !== undefined) window.barModWeather = d.bar_mod_weather;
                    if (d.bar_mod_volume !== undefined) window.barModVolume = d.bar_mod_volume;
                    if (d.bar_mod_network !== undefined) window.barModNetwork = d.bar_mod_network;
                    if (d.bar_mod_battery !== undefined) window.barModBattery = d.bar_mod_battery;
                    if (d.bar_mod_power !== undefined) window.barModPower = d.bar_mod_power;

                    if (d.dock_enabled !== undefined) window.dockEnabled = d.dock_enabled;
                    if (d.dock_position !== undefined) window.dockPosition = d.dock_position;
                    if (d.dock_floating !== undefined) window.dockFloating = d.dock_floating;
                    if (d.dock_layer_top !== undefined) window.dockLayerTop = d.dock_layer_top;
                    if (d.dock_exclusive !== undefined) window.dockExclusive = d.dock_exclusive;
                    if (d.dock_height !== undefined) window.dockHeight = d.dock_height;
                    if (d.dock_opacity !== undefined) window.dockOpacity = d.dock_opacity;
                    if (d.hover_scale !== undefined) window.hoverScale = d.hover_scale;
                    if (d.cascade_scale !== undefined) window.cascadeScale = d.cascade_scale;
                    if (d.scrolling !== undefined) window.scrolling = d.scrolling;
                    if (d.visible_elements !== undefined) window.visibleElements = d.visible_elements;
                    if (d.dock_visibility !== undefined) window.dockVisibility = d.dock_visibility;
                    if (d.smart_focus !== undefined) window.smartFocus = d.smart_focus;
                    if (d.running_indicators !== undefined) window.runningIndicators = d.running_indicators;
                    if (d.show_all_tasks !== undefined) window.showAllTasks = d.show_all_tasks;
                    if (d.active_scope !== undefined) window.activeScope = d.active_scope;
                    if (d.wallpaper_interval !== undefined) window.wallpaperInterval = d.wallpaper_interval;
                } catch(e) {}
            }
        };
        xhr.send();
    }

    Component.onCompleted: {
        loadSettings();
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

                        // Cyan Active Indicator
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

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text {
                                    text: model.title
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 11
                                    font.weight: (window.currentTab === index) ? Font.Bold : Font.Normal
                                    color: (window.currentTab === index) ? "#f8fafc" : (tabMouse.containsMouse ? "#f8fafc" : "#94a3b8")
                                }
                                Text {
                                    text: model.sub
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 8
                                    color: (window.currentTab === index) ? "#38bdf8" : "#64748b"
                                }
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
            }
        }

        // ==================== MAIN CONTENT AREA ====================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            StackLayout {
                id: mainStack
                anchors.fill: parent
                anchors.margins: 24
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
                                anchors.margins: 20
                                spacing: 18

                                Rectangle {
                                    width: 72
                                    height: 72
                                    radius: 18
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
                                        spacing: 8
                                        Text {
                                            text: "Bienvenido a Serpanplasma"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 18
                                            font.weight: Font.Black
                                            color: "#f8fafc"
                                        }
                                        Rectangle {
                                            height: 20
                                            radius: 6
                                            color: "#38bdf8"
                                            implicitWidth: vText.implicitWidth + 12
                                            Text {
                                                id: vText
                                                anchors.centerIn: parent
                                                text: "v1.0.0"
                                                font.family: "JetBrainsMono Nerd Font"
                                                font.pixelSize: 10
                                                font.weight: Font.Bold
                                                color: "#0f172a"
                                            }
                                        }
                                    }

                                    Text {
                                        text: "Réplica visual y funcional exacta 1:1 de Serpantinum adaptada para KDE Plasma 6 sobre Wayland con gestión de ventanas tradicional flotante (Windows-style)."
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 11
                                        color: "#94a3b8"
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Feature Grid
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 12
                            columnSpacing: 12

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
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
                                        Text { text: "󰹑"; font.pixelSize: 16; color: "#38bdf8" }
                                        Text { text: "Barra Superior con Píldoras"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    Text {
                                        text: "Panel flotante superior con reloj apilado en español, reproductor MPRIS, clima en vivo, volumen y cápsulas blancas sólidas."
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
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
                                        Text { text: "󰮯"; font.pixelSize: 16; color: "#38bdf8" }
                                        Text { text: "Dock de Aplicaciones Inferior"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    Text {
                                        text: "Dock flotante centrado con escala al pasar el ratón, esquinas redondeadas, ocultación inteligente y modo desacoplado."
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
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
                                        Text { text: "󰈹"; font.pixelSize: 16; color: "#38bdf8" }
                                        Text { text: "Ventanas Libres (Sin Tiling)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    Text {
                                        text: "Ventanas flotantes centradas, clic para enfocar/traer al frente, botones clásicos (_, □, X) y atajos estándar de Windows."
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 95
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
                                        Text { text: "Paleta Obsidian & 146 Fondos"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8" }
                                    }
                                    Text {
                                        text: "Esquema oscuro pizarra profundo (#0f172a), desenfoque translúcido KWin, acentos cian y rotación de fondos automática."
                                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8"; wrapMode: Text.WordWrap; Layout.fillWidth: true
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
                                Text { anchors.centerIn: parent; text: "󰹑 Configurar Barra"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#0f172a" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 1 }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: "󰮯 Configurar Dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 2 }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: "󰏘 Personalizar Tema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentTab = 3 }
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
                            text: "Ajusta la posición, altura, estilo de píldoras y visibilidad de los módulos en la barra superior en tiempo real."
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
                                    Slider { id: barSlider; Layout.fillWidth: true; from: 30; to: 50; value: window.barHeight; stepSize: 1 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.barHeight = Math.round(barSlider.value);
                                                window.sendCmd("set_bar_height", window.barHeight);
                                                window.showToast("Altura de barra guardada (" + window.barHeight + "px)");
                                            }
                                        }
                                    }
                                }

                                // Opacidad Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Opacidad de la barra"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(barOpacitySlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: barOpacitySlider; Layout.fillWidth: true; from: 20; to: 100; value: window.barOpacity; stepSize: 5 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.barOpacity = Math.round(barOpacitySlider.value);
                                                window.sendCmd("set_bar_opacity", window.barOpacity);
                                                window.showToast("Opacidad de la barra guardada (" + window.barOpacity + "%)");
                                            }
                                        }
                                    }
                                }

                                // Toggles de estilo
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Píldoras distintas (Distinct Pills)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barDistinctPills
                                        onToggled: {
                                            window.barDistinctPills = checked;
                                            window.sendCmd("set_distinct_pills", checked ? "true" : "false");
                                            window.showToast(checked ? "Estilo de píldoras individuales activado" : "Estilo de barra unificada activado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Modo flotante desacoplado"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barFloating
                                        onToggled: {
                                            window.barFloating = checked;
                                            window.sendCmd("set_bar_floating", checked ? "true" : "false");
                                            window.showToast(checked ? "Barra superior en modo flotante (desacoplada)" : "Barra superior acoplada al borde superior");
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

                                Text { text: "Módulos y Cápsulas de la Barra"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰒓 Botón de Ajustes y Guía"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModSettings
                                        onToggled: {
                                            window.barModSettings = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "settings");
                                            window.showToast(checked ? "Botón de ajustes visible" : "Botón de ajustes ocultado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰮯 Espacios de Trabajo (Pills/Dots)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModWorkspaces
                                        onToggled: {
                                            window.barModWorkspaces = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "workspaces");
                                            window.showToast(checked ? "Módulo de escritorios visible" : "Módulo de escritorios ocultado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰎈 Reproductor de Música MPRIS"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModMedia
                                        onToggled: {
                                            window.barModMedia = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "media");
                                            window.showToast(checked ? "Reproductor de música visible" : "Reproductor de música ocultado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰅐 Reloj Digital Apilado (Hora + Fecha)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModClock
                                        onToggled: {
                                            window.barModClock = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "clock");
                                            window.showToast(checked ? "Reloj digital visible" : "Reloj digital ocultado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "☁ Clima en Vivo (Open-Meteo)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModWeather
                                        onToggled: {
                                            window.barModWeather = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "weather");
                                            window.showToast(checked ? "Módulo de clima en vivo activado" : "Módulo de clima ocultado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰕾 Control de Volumen y Rueda"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModVolume
                                        onToggled: {
                                            window.barModVolume = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "volume");
                                            window.showToast(checked ? "Control de volumen visible" : "Control de volumen ocultado");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰤨 Cápsula Blanca Sólida de Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModNetwork
                                        onToggled: {
                                            window.barModNetwork = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "network");
                                            window.showToast(checked ? "Cápsula de red visible" : "Cápsula de red ocultada");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰁹 Cápsula Blanca Sólida de Batería"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModBattery
                                        onToggled: {
                                            window.barModBattery = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "battery");
                                            window.showToast(checked ? "Cápsula de batería visible" : "Cápsula de batería ocultada");
                                        }
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "⏻ Botón Circular de Apagado"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.barModPower
                                        onToggled: {
                                            window.barModPower = checked;
                                            window.sendCmd("set_bar_module", checked ? "true" : "false", "power");
                                            window.showToast(checked ? "Botón de apagado visible" : "Botón de apagado ocultado");
                                        }
                                    }
                                }
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
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_plasma");
                                    window.showToast("Reiniciando PlasmaShell...");
                                }
                            }
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
                                    Switch {
                                        checked: window.dockEnabled
                                        onToggled: {
                                            window.dockEnabled = checked;
                                            window.sendCmd("set_dock_enabled", checked ? "true" : "false");
                                            window.showToast(checked ? "Dock de aplicaciones habilitado" : "Dock de aplicaciones deshabilitado");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍹 Posición del dock en pantalla"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.dockPosition === "bottom") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.dockPosition === "bottom") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "Abajo"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.dockPosition === "bottom") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.dockPosition = "bottom";
                                                    window.sendCmd("set_dock_position", "bottom");
                                                    window.showToast("Posición del dock: Abajo");
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.dockPosition === "left") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.dockPosition === "left") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "Izquierda"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.dockPosition === "left") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.dockPosition = "left";
                                                    window.sendCmd("set_dock_position", "left");
                                                    window.showToast("Posición del dock: Izquierda");
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.dockPosition === "right") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.dockPosition === "right") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "Derecha"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.dockPosition === "right") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.dockPosition = "right";
                                                    window.sendCmd("set_dock_position", "right");
                                                    window.showToast("Posición del dock: Derecha");
                                                }
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰉈 Dock flotante desacoplado"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockFloating
                                        onToggled: {
                                            window.dockFloating = checked;
                                            window.sendCmd("set_dock_floating", checked ? "true" : "false");
                                            window.showToast(checked ? "Dock flotante activado (desacoplado de los bordes)" : "Dock acoplado a los bordes de la pantalla");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰹤 Colocar dock siempre sobre las ventanas"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockLayerTop
                                        onToggled: {
                                            window.dockLayerTop = checked;
                                            window.sendCmd("set_dock_layer", checked ? "true" : "false");
                                            window.showToast(checked ? "Dock siempre encima de las ventanas activas" : "Ventanas pueden superponerse libremente al dock");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰖲 Modo exclusivo (Reservar espacio en pantalla)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockExclusive
                                        onToggled: {
                                            window.dockExclusive = checked;
                                            window.sendCmd("set_dock_exclusive", checked ? "true" : "false");
                                            window.showToast(checked ? "Modo exclusivo activado (reserva espacio para ventanas)" : "Modo exclusivo desactivado (permite flotar sobre el área útil)");
                                        }
                                    }
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
                                    Slider { id: dockSlider; Layout.fillWidth: true; from: 44; to: 68; value: window.dockHeight; stepSize: 1 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.dockHeight = Math.round(dockSlider.value);
                                                window.sendCmd("set_dock_height", window.dockHeight);
                                                window.showToast("Altura de dock guardada (" + window.dockHeight + "px)");
                                            }
                                        }
                                    }
                                }

                                // Opacidad Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰂵 Opacidad del dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(dockOpacitySlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: dockOpacitySlider; Layout.fillWidth: true; from: 20; to: 100; value: window.dockOpacity; stepSize: 5 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.dockOpacity = Math.round(dockOpacitySlider.value);
                                                window.sendCmd("set_dock_opacity", window.dockOpacity);
                                                window.showToast("Opacidad de dock guardada (" + window.dockOpacity + "%)");
                                            }
                                        }
                                    }
                                }

                                // Hover Scale Slider
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍔 Efecto de escala al pasar el ratón (Hover Scale)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(hoverScaleSlider.value) + " %"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: hoverScaleSlider; Layout.fillWidth: true; from: 100; to: 140; value: window.hoverScale; stepSize: 5 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.hoverScale = Math.round(hoverScaleSlider.value);
                                                window.sendCmd("set_hover_scale", window.hoverScale);
                                                window.showToast("Efecto de zoom al pasar el ratón: " + window.hoverScale + "%");
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘚 Escalar elementos cercanos (Cascade scale)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.cascadeScale
                                        onToggled: {
                                            window.cascadeScale = checked;
                                            window.sendCmd("set_cascade_scale", checked ? "true" : "false");
                                            window.showToast(checked ? "Efecto de escala en cascada activado" : "Efecto de cascada desactivado");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍽 Habilitar desplazamiento de elementos (Scrolling)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.scrolling
                                        onToggled: {
                                            window.scrolling = checked;
                                            window.sendCmd("set_scrolling", checked ? "true" : "false");
                                            window.showToast(checked ? "Desplazamiento horizontal de iconos activado" : "Desplazamiento horizontal desactivado");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰅫 Máximo de elementos visibles"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(visElemSlider.value) + " elementos"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Slider { id: visElemSlider; Layout.fillWidth: true; from: 4; to: 12; value: window.visibleElements; stepSize: 1 }
                                    Rectangle {
                                        width: 76; height: 26; radius: 6; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "Guardar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.visibleElements = Math.round(visElemSlider.value);
                                                window.sendCmd("set_visible_elements", window.visibleElements);
                                                window.showToast("Límite de elementos visibles: " + window.visibleElements);
                                            }
                                        }
                                    }
                                }
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
                                    Switch {
                                        checked: window.dockVisibility === "dodgewindows"
                                        onToggled: {
                                            var newVis = checked ? "dodgewindows" : "none";
                                            window.dockVisibility = newVis;
                                            window.sendCmd("set_dock_visibility", newVis);
                                            window.showToast(checked ? "Ocultación inteligente (Dodge) activada" : "Ocultación inteligente desactivada");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘓 Ocultar automáticamente (Auto-hide al salir cursor)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.dockVisibility === "autohide"
                                        onToggled: {
                                            var newVis = checked ? "autohide" : "none";
                                            window.dockVisibility = newVis;
                                            window.sendCmd("set_dock_visibility", newVis);
                                            window.showToast(checked ? "Auto-hide automático activado" : "Auto-hide desactivado");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󱂬 Enfocar ventana existente en lugar de duplicar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.smartFocus
                                        onToggled: {
                                            window.smartFocus = checked;
                                            window.sendCmd("set_dock_smart_focus", checked ? "true" : "false");
                                            window.showToast(checked ? "Enfoque inteligente de ventanas activado" : "Apertura de nuevas instancias activado");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰄯 Indicadores discretos de aplicación en ejecución"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.runningIndicators
                                        onToggled: {
                                            window.runningIndicators = checked;
                                            window.sendCmd("set_dock_indicators", checked ? "true" : "false");
                                            window.showToast(checked ? "Indicadores de ejecución visibles" : "Indicadores de ejecución ocultados");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰘓 Mostrar todas las aplicaciones abiertas en el dock"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: window.showAllTasks
                                        onToggled: {
                                            window.showAllTasks = checked;
                                            window.sendCmd("set_dock_tasks", checked ? "true" : "false");
                                            window.showToast(checked ? "Tareas abiertas visibles en el dock" : "Dock en modo solo iconos anclados");
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "󰍹 Ámbito de ventanas activas (Scope)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                                    Item { Layout.fillWidth: true }
                                    RowLayout {
                                        spacing: 6
                                        Rectangle {
                                            width: 80; height: 26; radius: 6
                                            color: (window.activeScope === "current") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.activeScope === "current") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "Escritorio"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.activeScope === "current") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.activeScope = "current";
                                                    window.sendCmd("set_dock_scope", "current");
                                                    window.showToast("Ámbito: Solo tareas del escritorio actual");
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 60; height: 26; radius: 6
                                            color: (window.activeScope === "all") ? "#38bdf8" : "#1e293b"
                                            border.color: (window.activeScope === "all") ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "Todos"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.activeScope === "all") ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.activeScope = "all";
                                                    window.sendCmd("set_dock_scope", "all");
                                                    window.showToast("Ámbito: Tareas de todos los escritorios");
                                                }
                                            }
                                        }
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
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰞷"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰉋"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰇧"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰙯"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰓇"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
                                    Rectangle { width: 38; height: 38; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1; Text { anchors.centerIn: parent; text: "󰒓"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" } }
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
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_plasma");
                                    window.showToast("Reiniciando Dock y PlasmaShell...");
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
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.sendCmd("apply_colorscheme", "Serpanplasma-Obsidian");
                                                    window.showToast("Esquema Obsidian activado");
                                                }
                                            }
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
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.sendCmd("apply_colorscheme", "BreezeDark");
                                                    window.showToast("Esquema Breeze Dark activado");
                                                }
                                            }
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
                                onClicked: {
                                    window.sendCmd("restart_kwin");
                                    window.showToast("KWin reconfigurado con éxito");
                                }
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
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 300) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 300) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "5m"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 300) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 300;
                                                    window.sendCmd("set_wallpaper_interval", "300");
                                                    window.showToast("Intervalo de cambio: 5 minutos");
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 900) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 900) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "15m"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 900) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 900;
                                                    window.sendCmd("set_wallpaper_interval", "900");
                                                    window.showToast("Intervalo de cambio: 15 minutos");
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 1800) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 1800) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "30m"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 1800) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 1800;
                                                    window.sendCmd("set_wallpaper_interval", "1800");
                                                    window.showToast("Intervalo de cambio: 30 minutos");
                                                }
                                            }
                                        }
                                        Rectangle {
                                            width: 50; height: 26; radius: 6
                                            color: (window.wallpaperInterval === 3600) ? "#38bdf8" : "#1e293b"
                                            border.color: (window.wallpaperInterval === 3600) ? "#38bdf8" : "#334155"
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent; text: "1h"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold
                                                color: (window.wallpaperInterval === 3600) ? "#0f172a" : "#cbd5e1"
                                            }
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    window.wallpaperInterval = 3600;
                                                    window.sendCmd("set_wallpaper_interval", "3600");
                                                    window.showToast("Intervalo de cambio: 1 hora");
                                                }
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    spacing: 12
                                    Rectangle {
                                        Layout.fillWidth: true; height: 36; radius: 8; color: "#38bdf8"
                                        Text { anchors.centerIn: parent; text: "󰒭 Siguiente Fondo de Pantalla"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#0f172a" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.sendCmd("next_wallpaper");
                                                window.showToast("Cambiando fondo de pantalla...");
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true; height: 36; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1
                                        Text { anchors.centerIn: parent; text: "󰸉 Abrir Carpeta en Dolphin"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#f8fafc" }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                window.sendCmd("open_wallpapers");
                                                window.showToast("Abriendo ~/Imágenes/Wallpapers/...");
                                            }
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
                                Text { text: "Reiniciar Servicio Demonio (serpanplasma-daemon)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    window.sendCmd("restart_daemon");
                                    window.showToast("Reiniciando servicio del demonio...");
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
                            height: 240
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

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    height: 32
                                    radius: 8
                                    color: "#1e293b"
                                    border.color: "#38bdf8"
                                    border.width: 1
                                    implicitWidth: gitRow.implicitWidth + 24

                                    RowLayout {
                                        id: gitRow
                                        anchors.centerIn: parent
                                        spacing: 8
                                        Text { text: "󰊤"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8" }
                                        Text { text: "github.com/jorjanion/Serpanplasma"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#f8fafc" }
                                    }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            window.sendCmd("open_url", "https://github.com/jorjanion/Serpanplasma");
                                            window.showToast("Abriendo repositorio de GitHub...");
                                        }
                                    }
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
