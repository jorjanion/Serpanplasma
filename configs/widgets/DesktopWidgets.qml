import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: desktopWindow
    visible: true
    x: 0
    y: 0
    width: Screen.width
    height: Screen.height
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysBelowHint | Qt.Tool
    title: "Serpanplasma Desktop Widgets"

    // Master enabled state
    property bool desktopWidgetsEnabled: true

    // Individual Widget States & Coordinates
    property bool wgtHwEnabled: true
    property int wgtHwX: 60
    property int wgtHwY: 80

    property bool wgtClockEnabled: true
    property int wgtClockX: 480
    property int wgtClockY: 80

    property bool wgtWeatherEnabled: true
    property int wgtWeatherX: 920
    property int wgtWeatherY: 80

    property bool wgtMusicEnabled: true
    property int wgtMusicX: 920
    property int wgtMusicY: 420

    // Theme Palettes
    property string themeBg: "#0f172a"
    property string themeCard: "#1e293b"
    property string themeAccent: "#38bdf8"
    property string themeFg: "#f8fafc"
    property string themeMuted: "#94a3b8"
    property string themeBorder: "#334155"
    property bool isLightTheme: false

    // Live Metrics from status daemon
    property int cpuPct: 10
    property int ramPct: 40
    property string ramUsed: "6.0"
    property string ramTotal: "15.0"
    property int diskPct: 10
    property string diskFree: "440.0"
    property string uptimeStr: "1h 0m"
    property string temp: "22.1°C"
    property string weatherFeels: "21.0°C"
    property int weatherHum: 55
    property string weatherWind: "4.0 km/h"
    property string weatherIcon: "󰖙"
    property string weatherDesc: "Despejado"
    property string mediaTitle: "No hay nada reprc"
    property string mediaArtist: ""
    property bool mediaPlaying: false
    property string currentTime: "22:00"
    property string currentDate: "jueves, 15 de octubre"

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

    function updateTime() {
        var now = new Date();
        var h = String(now.getHours()).padStart(2, '0');
        var m = String(now.getMinutes()).padStart(2, '0');
        currentTime = h + ":" + m;
        var days = ["domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"];
        var months = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
        currentDate = days[now.getDay()] + ", " + now.getDate() + " de " + months[now.getMonth()];
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: desktopWindow.updateTime()
    }

    function fetchMetrics() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/status");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    if (d.desktop_widgets !== undefined) desktopWindow.desktopWidgetsEnabled = d.desktop_widgets;

                    if (d.widgets !== undefined) {
                        if (d.widgets.hw !== undefined) {
                            if (d.widgets.hw.enabled !== undefined) desktopWindow.wgtHwEnabled = d.widgets.hw.enabled;
                            if (d.widgets.hw.x !== undefined && !hwMouseArea.drag.active) desktopWindow.wgtHwX = d.widgets.hw.x;
                            if (d.widgets.hw.y !== undefined && !hwMouseArea.drag.active) desktopWindow.wgtHwY = d.widgets.hw.y;
                        }
                        if (d.widgets.clock !== undefined) {
                            if (d.widgets.clock.enabled !== undefined) desktopWindow.wgtClockEnabled = d.widgets.clock.enabled;
                            if (d.widgets.clock.x !== undefined && !clockMouseArea.drag.active) desktopWindow.wgtClockX = d.widgets.clock.x;
                            if (d.widgets.clock.y !== undefined && !clockMouseArea.drag.active) desktopWindow.wgtClockY = d.widgets.clock.y;
                        }
                        if (d.widgets.weather !== undefined) {
                            if (d.widgets.weather.enabled !== undefined) desktopWindow.wgtWeatherEnabled = d.widgets.weather.enabled;
                            if (d.widgets.weather.x !== undefined && !weatherMouseArea.drag.active) desktopWindow.wgtWeatherX = d.widgets.weather.x;
                            if (d.widgets.weather.y !== undefined && !weatherMouseArea.drag.active) desktopWindow.wgtWeatherY = d.widgets.weather.y;
                        }
                        if (d.widgets.music !== undefined) {
                            if (d.widgets.music.enabled !== undefined) desktopWindow.wgtMusicEnabled = d.widgets.music.enabled;
                            if (d.widgets.music.x !== undefined && !musicMouseArea.drag.active) desktopWindow.wgtMusicX = d.widgets.music.x;
                            if (d.widgets.music.y !== undefined && !musicMouseArea.drag.active) desktopWindow.wgtMusicY = d.widgets.music.y;
                        }
                    }

                    if (d.cpu_pct !== undefined) desktopWindow.cpuPct = d.cpu_pct;
                    if (d.ram_pct !== undefined) desktopWindow.ramPct = d.ram_pct;
                    if (d.ram_used_gb !== undefined) desktopWindow.ramUsed = String(d.ram_used_gb);
                    if (d.ram_total_gb !== undefined) desktopWindow.ramTotal = String(d.ram_total_gb);
                    if (d.disk_pct !== undefined) desktopWindow.diskPct = d.disk_pct;
                    if (d.disk_free_gb !== undefined) desktopWindow.diskFree = String(d.disk_free_gb);
                    if (d.uptime !== undefined) desktopWindow.uptimeStr = d.uptime;
                    if (d.temp !== undefined) desktopWindow.temp = d.temp;
                    if (d.weather_feels_like !== undefined) desktopWindow.weatherFeels = d.weather_feels_like;
                    if (d.weather_humidity !== undefined) desktopWindow.weatherHum = d.weather_humidity;
                    if (d.weather_wind !== undefined) desktopWindow.weatherWind = d.weather_wind;
                    if (d.weather_icon !== undefined) desktopWindow.weatherIcon = d.weather_icon;
                    if (d.weather_desc !== undefined) desktopWindow.weatherDesc = d.weather_desc;
                    if (d.media_title !== undefined) desktopWindow.mediaTitle = d.media_title;
                    if (d.media_artist !== undefined) desktopWindow.mediaArtist = d.media_artist;
                    if (d.media_playing !== undefined) desktopWindow.mediaPlaying = d.media_playing;

                    if (d.theme_bg !== undefined) desktopWindow.themeBg = d.theme_bg;
                    if (d.theme_card !== undefined) desktopWindow.themeCard = d.theme_card;
                    if (d.theme_accent !== undefined) desktopWindow.themeAccent = d.theme_accent;
                    if (d.theme_fg !== undefined) desktopWindow.themeFg = d.theme_fg;
                    if (d.theme_muted !== undefined) desktopWindow.themeMuted = d.theme_muted;
                    if (d.theme_border !== undefined) desktopWindow.themeBorder = d.theme_border;
                    if (d.is_light !== undefined) desktopWindow.isLightTheme = d.is_light;
                } catch(e) {}
            }
        };
        xhr.send();
    }

    Timer {
        interval: 800
        running: true
        repeat: true
        onTriggered: desktopWindow.fetchMetrics()
    }

    Component.onCompleted: {
        updateTime();
        fetchMetrics();
    }

    // =========================================================================
    // 1. HARDWARE USAGE WIDGET (DRAGGABLE & TOGGLEABLE)
    // =========================================================================
    Rectangle {
        id: hwWidget
        visible: desktopWindow.desktopWidgetsEnabled && desktopWindow.wgtHwEnabled
        x: desktopWindow.wgtHwX
        y: desktopWindow.wgtHwY
        width: 360
        implicitHeight: usageCol.implicitHeight + 32
        radius: 16
        color: desktopWindow.themeBg
        opacity: 0.94
        border.color: desktopWindow.themeBorder
        border.width: 1

        MouseArea {
            id: hwMouseArea
            anchors.fill: parent
            cursorShape: Qt.OpenHandCursor
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 10
            drag.maximumX: desktopWindow.width - parent.width - 10
            drag.minimumY: 45
            drag.maximumY: desktopWindow.height - parent.height - 10
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: {
                cursorShape = Qt.OpenHandCursor;
                desktopWindow.wgtHwX = Math.round(parent.x);
                desktopWindow.wgtHwY = Math.round(parent.y);
                desktopWindow.sendCmd("set_widget_pos", Math.round(parent.x) + "," + Math.round(parent.y), "hw");
            }
        }

        ColumnLayout {
            id: usageCol
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            RowLayout {
                spacing: 8
                Text { text: "󰍛"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 16; color: desktopWindow.themeAccent }
                Text { text: "Monitor del Sistema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: desktopWindow.themeFg }
                Item { Layout.fillWidth: true }
                Text { text: "󰅐 " + desktopWindow.uptimeStr; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: desktopWindow.themeMuted }
            }

            // CPU
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "󰻠 CPU (AMD Ryzen)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: desktopWindow.themeMuted }
                    Item { Layout.fillWidth: true }
                    Text { text: desktopWindow.cpuPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: desktopWindow.themeAccent }
                }
                Rectangle {
                    Layout.fillWidth: true; height: 6; radius: 3; color: desktopWindow.themeCard
                    Rectangle {
                        width: Math.max(4, parent.width * (desktopWindow.cpuPct / 100.0))
                        height: parent.height; radius: 3
                        color: (desktopWindow.cpuPct > 80) ? "#ef4444" : desktopWindow.themeAccent
                        Behavior on width { NumberAnimation { duration: 250 } }
                    }
                }
            }

            // RAM
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "󰘚 RAM (" + desktopWindow.ramUsed + " / " + desktopWindow.ramTotal + " GB)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: desktopWindow.themeMuted }
                    Item { Layout.fillWidth: true }
                    Text { text: desktopWindow.ramPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: desktopWindow.themeAccent }
                }
                Rectangle {
                    Layout.fillWidth: true; height: 6; radius: 3; color: desktopWindow.themeCard
                    Rectangle {
                        width: Math.max(4, parent.width * (desktopWindow.ramPct / 100.0))
                        height: parent.height; radius: 3
                        color: (desktopWindow.ramPct > 85) ? "#ef4444" : desktopWindow.themeAccent
                        Behavior on width { NumberAnimation { duration: 250 } }
                    }
                }
            }

            // Disk
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "󰋊 Almacenamiento (Libre: " + desktopWindow.diskFree + " GB)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: desktopWindow.themeMuted }
                    Item { Layout.fillWidth: true }
                    Text { text: desktopWindow.diskPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: desktopWindow.themeAccent }
                }
                Rectangle {
                    Layout.fillWidth: true; height: 6; radius: 3; color: desktopWindow.themeCard
                    Rectangle {
                        width: Math.max(4, parent.width * (desktopWindow.diskPct / 100.0))
                        height: parent.height; radius: 3
                        color: desktopWindow.themeAccent
                        Behavior on width { NumberAnimation { duration: 250 } }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 2. CLOCK & DATE DESKTOP WIDGET (DRAGGABLE & TOGGLEABLE)
    // =========================================================================
    Rectangle {
        id: clockWidget
        visible: desktopWindow.desktopWidgetsEnabled && desktopWindow.wgtClockEnabled
        x: desktopWindow.wgtClockX
        y: desktopWindow.wgtClockY
        width: 360
        height: 125
        radius: 16
        color: desktopWindow.themeBg
        opacity: 0.94
        border.color: desktopWindow.themeBorder
        border.width: 1

        MouseArea {
            id: clockMouseArea
            anchors.fill: parent
            cursorShape: Qt.OpenHandCursor
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 10
            drag.maximumX: desktopWindow.width - parent.width - 10
            drag.minimumY: 45
            drag.maximumY: desktopWindow.height - parent.height - 10
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: {
                cursorShape = Qt.OpenHandCursor;
                desktopWindow.wgtClockX = Math.round(parent.x);
                desktopWindow.wgtClockY = Math.round(parent.y);
                desktopWindow.sendCmd("set_widget_pos", Math.round(parent.x) + "," + Math.round(parent.y), "clock");
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2
            Text {
                text: desktopWindow.currentTime
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 42
                font.weight: Font.Black
                color: desktopWindow.themeFg
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: desktopWindow.currentDate
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: desktopWindow.themeAccent
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // =========================================================================
    // 3. WEATHER DESKTOP WIDGET (DRAGGABLE & TOGGLEABLE)
    // =========================================================================
    Rectangle {
        id: weatherWidget
        visible: desktopWindow.desktopWidgetsEnabled && desktopWindow.wgtWeatherEnabled
        x: desktopWindow.wgtWeatherX
        y: desktopWindow.wgtWeatherY
        width: 360
        height: 115
        radius: 16
        color: desktopWindow.themeBg
        opacity: 0.94
        border.color: desktopWindow.themeBorder
        border.width: 1

        MouseArea {
            id: weatherMouseArea
            anchors.fill: parent
            cursorShape: Qt.OpenHandCursor
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 10
            drag.maximumX: desktopWindow.width - parent.width - 10
            drag.minimumY: 45
            drag.maximumY: desktopWindow.height - parent.height - 10
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: {
                cursorShape = Qt.OpenHandCursor;
                desktopWindow.wgtWeatherX = Math.round(parent.x);
                desktopWindow.wgtWeatherY = Math.round(parent.y);
                desktopWindow.sendCmd("set_widget_pos", Math.round(parent.x) + "," + Math.round(parent.y), "weather");
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            Text {
                text: desktopWindow.weatherIcon
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 38
                color: desktopWindow.themeAccent
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                RowLayout {
                    Text { text: desktopWindow.temp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 22; font.weight: Font.Black; color: desktopWindow.themeFg }
                    Item { Layout.fillWidth: true }
                    Text { text: "Madrid, ES"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: desktopWindow.themeAccent }
                }
                Text { text: desktopWindow.weatherDesc; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: desktopWindow.themeMuted }
                RowLayout {
                    spacing: 8
                    Text { text: "Sensación: " + desktopWindow.weatherFeels; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: desktopWindow.themeMuted }
                    Text { text: "•"; color: desktopWindow.themeBorder }
                    Text { text: "Humedad: " + desktopWindow.weatherHum + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: desktopWindow.themeMuted }
                }
            }
        }
    }

    // =========================================================================
    // 4. MUSIC NOW-PLAYING WIDGET (DRAGGABLE & TOGGLEABLE)
    // =========================================================================
    Rectangle {
        id: musicWidget
        visible: desktopWindow.desktopWidgetsEnabled && desktopWindow.wgtMusicEnabled
        x: desktopWindow.wgtMusicX
        y: desktopWindow.wgtMusicY
        width: 360
        height: 88
        radius: 16
        color: desktopWindow.themeBg
        opacity: 0.94
        border.color: desktopWindow.themeBorder
        border.width: 1

        MouseArea {
            id: musicMouseArea
            anchors.fill: parent
            cursorShape: Qt.OpenHandCursor
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 10
            drag.maximumX: desktopWindow.width - parent.width - 10
            drag.minimumY: 45
            drag.maximumY: desktopWindow.height - parent.height - 10
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: {
                cursorShape = Qt.OpenHandCursor;
                desktopWindow.wgtMusicX = Math.round(parent.x);
                desktopWindow.wgtMusicY = Math.round(parent.y);
                desktopWindow.sendCmd("set_widget_pos", Math.round(parent.x) + "," + Math.round(parent.y), "music");
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            Rectangle {
                width: 44
                height: 44
                radius: 10
                color: desktopWindow.themeCard
                border.color: desktopWindow.themeAccent
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "󰎈"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    color: desktopWindow.themeAccent
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    text: desktopWindow.mediaTitle
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    color: desktopWindow.themeFg
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    Layout.fillWidth: true
                }
                Text {
                    text: desktopWindow.mediaArtist !== "" ? desktopWindow.mediaArtist : "Reproductor MPRIS"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 9
                    color: desktopWindow.themeMuted
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            // Controls with independent MouseAreas
            RowLayout {
                spacing: 6
                Rectangle {
                    width: 28; height: 28; radius: 7; color: desktopWindow.themeCard; border.color: desktopWindow.themeBorder; border.width: 1
                    Text { anchors.centerIn: parent; text: "󰒮"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: desktopWindow.themeFg }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: desktopWindow.sendCmd("previous")
                    }
                }
                Rectangle {
                    width: 32; height: 32; radius: 8; color: desktopWindow.themeAccent
                    Text { anchors.centerIn: parent; text: desktopWindow.mediaPlaying ? "󰏤" : "󰐊"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: desktopWindow.isLightTheme ? "#ffffff" : "#0f172a" }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: desktopWindow.sendCmd("play-pause")
                    }
                }
                Rectangle {
                    width: 28; height: 28; radius: 7; color: desktopWindow.themeCard; border.color: desktopWindow.themeBorder; border.width: 1
                    Text { anchors.centerIn: parent; text: "󰒭"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: desktopWindow.themeFg }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: desktopWindow.sendCmd("next")
                    }
                }
            }
        }
    }
}
