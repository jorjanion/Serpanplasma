import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

QtObject {
    id: root

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
    property string weatherPressure: "1013 hPa"
    property string weatherIcon: "󰖙"
    property string weatherDesc: "Despejado"
    property var weatherHourly: []
    property string mediaTitle: "No hay nada reprc"
    property string mediaArtist: ""
    property bool mediaPlaying: false
    property string currentTime: "22:00"
    property string currentDate: "jueves, 15 de octubre"

    property bool initialLoaded: false

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

    property var timeTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateTime()
    }

    function fetchMetrics() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/status");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    if (d.desktop_widgets !== undefined) root.desktopWidgetsEnabled = d.desktop_widgets;

                    if (d.widgets !== undefined) {
                        if (d.widgets.hw !== undefined) {
                            if (d.widgets.hw.enabled !== undefined) root.wgtHwEnabled = d.widgets.hw.enabled;
                            if (!root.initialLoaded) {
                                if (d.widgets.hw.x !== undefined) { root.wgtHwX = d.widgets.hw.x; hwWin.x = d.widgets.hw.x; }
                                if (d.widgets.hw.y !== undefined) { root.wgtHwY = d.widgets.hw.y; hwWin.y = d.widgets.hw.y; }
                            }
                        }
                        if (d.widgets.clock !== undefined) {
                            if (d.widgets.clock.enabled !== undefined) root.wgtClockEnabled = d.widgets.clock.enabled;
                            if (!root.initialLoaded) {
                                if (d.widgets.clock.x !== undefined) { root.wgtClockX = d.widgets.clock.x; clockWin.x = d.widgets.clock.x; }
                                if (d.widgets.clock.y !== undefined) { root.wgtClockY = d.widgets.clock.y; clockWin.y = d.widgets.clock.y; }
                            }
                        }
                        if (d.widgets.weather !== undefined) {
                            if (d.widgets.weather.enabled !== undefined) root.wgtWeatherEnabled = d.widgets.weather.enabled;
                            if (!root.initialLoaded) {
                                if (d.widgets.weather.x !== undefined) { root.wgtWeatherX = d.widgets.weather.x; weatherWin.x = d.widgets.weather.x; }
                                if (d.widgets.weather.y !== undefined) { root.wgtWeatherY = d.widgets.weather.y; weatherWin.y = d.widgets.weather.y; }
                            }
                        }
                        if (d.widgets.music !== undefined) {
                            if (d.widgets.music.enabled !== undefined) root.wgtMusicEnabled = d.widgets.music.enabled;
                            if (!root.initialLoaded) {
                                if (d.widgets.music.x !== undefined) { root.wgtMusicX = d.widgets.music.x; musicWin.x = d.widgets.music.x; }
                                if (d.widgets.music.y !== undefined) { root.wgtMusicY = d.widgets.music.y; musicWin.y = d.widgets.music.y; }
                            }
                        }
                        root.initialLoaded = true;
                    }

                    if (d.cpu_pct !== undefined) root.cpuPct = d.cpu_pct;
                    if (d.ram_pct !== undefined) root.ramPct = d.ram_pct;
                    if (d.ram_used_gb !== undefined) root.ramUsed = String(d.ram_used_gb);
                    if (d.ram_total_gb !== undefined) root.ramTotal = String(d.ram_total_gb);
                    if (d.disk_pct !== undefined) root.diskPct = d.disk_pct;
                    if (d.disk_free_gb !== undefined) root.diskFree = String(d.disk_free_gb);
                    if (d.uptime !== undefined) root.uptimeStr = d.uptime;
                    if (d.temp !== undefined) root.temp = d.temp;
                    if (d.weather_feels_like !== undefined) root.weatherFeels = d.weather_feels_like;
                    if (d.weather_humidity !== undefined) root.weatherHum = d.weather_humidity;
                    if (d.weather_wind !== undefined) root.weatherWind = d.weather_wind;
                    if (d.weather_pressure !== undefined) root.weatherPressure = d.weather_pressure;
                    if (d.weather_icon !== undefined) root.weatherIcon = d.weather_icon;
                    if (d.weather_desc !== undefined) root.weatherDesc = d.weather_desc;
                    if (d.weather_hourly !== undefined) root.weatherHourly = d.weather_hourly;
                    if (d.media_title !== undefined) root.mediaTitle = d.media_title;
                    if (d.media_artist !== undefined) root.mediaArtist = d.media_artist;
                    if (d.media_playing !== undefined) root.mediaPlaying = d.media_playing;

                    if (d.theme_bg !== undefined) root.themeBg = d.theme_bg;
                    if (d.theme_card !== undefined) root.themeCard = d.theme_card;
                    if (d.theme_accent !== undefined) root.themeAccent = d.theme_accent;
                    if (d.theme_fg !== undefined) root.themeFg = d.theme_fg;
                    if (d.theme_muted !== undefined) root.themeMuted = d.theme_muted;
                    if (d.theme_border !== undefined) root.themeBorder = d.theme_border;
                    if (d.is_light !== undefined) root.isLightTheme = d.is_light;
                } catch(e) {}
            }
        };
        xhr.send();
    }

    property var metricsTimer: Timer {
        interval: 800
        running: true
        repeat: true
        onTriggered: root.fetchMetrics()
    }

    Component.onCompleted: {
        updateTime();
        fetchMetrics();
    }

    // =========================================================================
    // 1. HARDWARE USAGE WIDGET WINDOW (MODULAR, DRAGGABLE, STAYS ON DESKTOP)
    // =========================================================================
    property var hwWin: Window {
        id: hwWin
        visible: root.desktopWidgetsEnabled && root.wgtHwEnabled
        x: root.wgtHwX
        y: root.wgtHwY
        width: 360
        height: 200
        color: "transparent"
        flags: Qt.FramelessWindowHint | Qt.WindowStaysBelowHint | Qt.SubWindow
        title: "Serpanplasma Hardware Widget"

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: root.themeBg
            opacity: 0.94
            border.color: root.themeBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                property point clickPos: "0,0"
                onPressed: (mouse) => { clickPos = Qt.point(mouse.x, mouse.y) }
                onPositionChanged: (mouse) => {
                    if (pressed) {
                        hwWin.x += (mouse.x - clickPos.x)
                        hwWin.y += (mouse.y - clickPos.y)
                    }
                }
                onReleased: {
                    root.sendCmd("set_widget_pos", Math.round(hwWin.x) + "," + Math.round(hwWin.y), "hw")
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                RowLayout {
                    spacing: 8
                    Text { text: "󰍛"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 15; color: root.themeAccent }
                    Text { text: "Monitor del Sistema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: root.themeFg }
                    Item { Layout.fillWidth: true }
                    Text { text: "󰅐 " + root.uptimeStr; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeMuted }
                }

                // CPU
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "󰻠 CPU (AMD Ryzen)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: root.cpuPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: root.themeAccent }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 5; radius: 3; color: root.themeCard
                        Rectangle {
                            width: Math.max(4, parent.width * (root.cpuPct / 100.0))
                            height: parent.height; radius: 3
                            color: (root.cpuPct > 80) ? "#ef4444" : root.themeAccent
                            Behavior on width { NumberAnimation { duration: 250 } }
                        }
                    }
                }

                // RAM
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "󰘚 RAM (" + root.ramUsed + " / " + root.ramTotal + " GB)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: root.ramPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: root.themeAccent }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 5; radius: 3; color: root.themeCard
                        Rectangle {
                            width: Math.max(4, parent.width * (root.ramPct / 100.0))
                            height: parent.height; radius: 3
                            color: (root.ramPct > 85) ? "#ef4444" : root.themeAccent
                            Behavior on width { NumberAnimation { duration: 250 } }
                        }
                    }
                }

                // Disk
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "󰋊 Almacenamiento (Libre: " + root.diskFree + " GB)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeMuted }
                        Item { Layout.fillWidth: true }
                        Text { text: root.diskPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: root.themeAccent }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 5; radius: 3; color: root.themeCard
                        Rectangle {
                            width: Math.max(4, parent.width * (root.diskPct / 100.0))
                            height: parent.height; radius: 3
                            color: root.themeAccent
                            Behavior on width { NumberAnimation { duration: 250 } }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 2. CLOCK & DATE WIDGET WINDOW (MODULAR, DRAGGABLE, STAYS ON DESKTOP)
    // =========================================================================
    property var clockWin: Window {
        id: clockWin
        visible: root.desktopWidgetsEnabled && root.wgtClockEnabled
        x: root.wgtClockX
        y: root.wgtClockY
        width: 360
        height: 125
        color: "transparent"
        flags: Qt.FramelessWindowHint | Qt.WindowStaysBelowHint | Qt.SubWindow
        title: "Serpanplasma Clock Widget"

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: root.themeBg
            opacity: 0.94
            border.color: root.themeBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                property point clickPos: "0,0"
                onPressed: (mouse) => { clickPos = Qt.point(mouse.x, mouse.y) }
                onPositionChanged: (mouse) => {
                    if (pressed) {
                        clockWin.x += (mouse.x - clickPos.x)
                        clockWin.y += (mouse.y - clickPos.y)
                    }
                }
                onReleased: {
                    root.sendCmd("set_widget_pos", Math.round(clockWin.x) + "," + Math.round(clockWin.y), "clock")
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    text: root.currentTime
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 42
                    font.weight: Font.Black
                    color: root.themeFg
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: root.currentDate
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: root.themeAccent
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    // =========================================================================
    // 3. WEATHER WIDGET WINDOW (MODULAR, DRAGGABLE, STAYS ON DESKTOP)
    // =========================================================================
    property var weatherWin: Window {
        id: weatherWin
        visible: root.desktopWidgetsEnabled && root.wgtWeatherEnabled
        x: root.wgtWeatherX
        y: root.wgtWeatherY
        width: 380
        height: 220
        color: "transparent"
        flags: Qt.FramelessWindowHint | Qt.WindowStaysBelowHint | Qt.SubWindow
        title: "Serpanplasma Weather Widget"

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: root.themeBg
            opacity: 0.94
            border.color: root.themeBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                property point clickPos: "0,0"
                onPressed: (mouse) => { clickPos = Qt.point(mouse.x, mouse.y) }
                onPositionChanged: (mouse) => {
                    if (pressed) {
                        weatherWin.x += (mouse.x - clickPos.x)
                        weatherWin.y += (mouse.y - clickPos.y)
                    }
                }
                onReleased: {
                    root.sendCmd("set_widget_pos", Math.round(weatherWin.x) + "," + Math.round(weatherWin.y), "weather")
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                // Top Info Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        width: 44
                        height: 44
                        radius: 10
                        color: root.themeCard
                        border.color: root.themeAccent
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: root.weatherIcon
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 24
                            color: root.themeAccent
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        RowLayout {
                            Text { text: root.temp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 20; font.weight: Font.Black; color: root.themeFg }
                            Item { Layout.fillWidth: true }
                            Text { text: "Madrid, ES"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: root.themeAccent }
                        }
                        Text { text: root.weatherDesc + " • Sensación " + root.weatherFeels; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeMuted }
                    }
                }

                // Metrics Badges
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Rectangle {
                        Layout.fillWidth: true; height: 26; radius: 6; color: root.themeCard; border.color: root.themeBorder; border.width: 1
                        RowLayout {
                            anchors.centerIn: parent; spacing: 4
                            Text { text: "󰈤"; font.pixelSize: 10; color: root.themeAccent }
                            Text { text: root.weatherHum + "% Hum"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeFg }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 26; radius: 6; color: root.themeCard; border.color: root.themeBorder; border.width: 1
                        RowLayout {
                            anchors.centerIn: parent; spacing: 4
                            Text { text: "󰖝"; font.pixelSize: 10; color: root.themeAccent }
                            Text { text: root.weatherWind; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeFg }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 26; radius: 6; color: root.themeCard; border.color: root.themeBorder; border.width: 1
                        RowLayout {
                            anchors.centerIn: parent; spacing: 4
                            Text { text: "󰖐"; font.pixelSize: 10; color: root.themeAccent }
                            Text { text: root.weatherPressure; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: root.themeFg }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: root.themeBorder }

                // Hourly Forecast Pills Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Repeater {
                        model: (Array.isArray(root.weatherHourly) ? root.weatherHourly.slice(0, 5) : [])
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            height: 62
                            radius: 7
                            color: root.themeCard
                            border.color: root.themeBorder
                            border.width: 1

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 2
                                Text { text: modelData.time; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 8; font.weight: Font.Bold; color: root.themeMuted; Layout.alignment: Qt.AlignHCenter }
                                Text { text: modelData.icon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 13; color: root.themeAccent; Layout.alignment: Qt.AlignHCenter }
                                Text { text: modelData.temp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: root.themeFg; Layout.alignment: Qt.AlignHCenter }
                                Text { text: "󰖗 " + modelData.pop; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 7; color: (modelData.pop !== "0%") ? "#38bdf8" : "#64748b"; Layout.alignment: Qt.AlignHCenter }
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 4. MUSIC NOW-PLAYING WIDGET WINDOW (MODULAR, DRAGGABLE, STAYS ON DESKTOP)
    // =========================================================================
    property var musicWin: Window {
        id: musicWin
        visible: root.desktopWidgetsEnabled && root.wgtMusicEnabled
        x: root.wgtMusicX
        y: root.wgtMusicY
        width: 360
        height: 88
        color: "transparent"
        flags: Qt.FramelessWindowHint | Qt.WindowStaysBelowHint | Qt.SubWindow
        title: "Serpanplasma Music Widget"

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: root.themeBg
            opacity: 0.94
            border.color: root.themeBorder
            border.width: 1

            MouseArea {
                anchors.fill: parent
                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                property point clickPos: "0,0"
                onPressed: (mouse) => { clickPos = Qt.point(mouse.x, mouse.y) }
                onPositionChanged: (mouse) => {
                    if (pressed) {
                        musicWin.x += (mouse.x - clickPos.x)
                        musicWin.y += (mouse.y - clickPos.y)
                    }
                }
                onReleased: {
                    root.sendCmd("set_widget_pos", Math.round(musicWin.x) + "," + Math.round(musicWin.y), "music")
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
                    color: root.themeCard
                    border.color: root.themeAccent
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰎈"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: root.themeAccent
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: root.mediaTitle
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: root.themeFg
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        Layout.fillWidth: true
                    }
                    Text {
                        text: root.mediaArtist !== "" ? root.mediaArtist : "Reproductor MPRIS"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 9
                        color: root.themeMuted
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                // Controls with independent MouseAreas (z: 2 ensures clicks register)
                RowLayout {
                    z: 2
                    spacing: 6
                    Rectangle {
                        width: 28; height: 28; radius: 7; color: root.themeCard; border.color: root.themeBorder; border.width: 1
                        Text { anchors.centerIn: parent; text: "󰒮"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: root.themeFg }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: root.sendCmd("previous")
                        }
                    }
                    Rectangle {
                        width: 32; height: 32; radius: 8; color: root.themeAccent
                        Text { anchors.centerIn: parent; text: root.mediaPlaying ? "󰏤" : "󰐊"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: root.isLightTheme ? "#ffffff" : "#0f172a" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: root.sendCmd("play-pause")
                        }
                    }
                    Rectangle {
                        width: 28; height: 28; radius: 7; color: root.themeCard; border.color: root.themeBorder; border.width: 1
                        Text { anchors.centerIn: parent; text: "󰒭"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: root.themeFg }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: root.sendCmd("next")
                        }
                    }
                }
            }
        }
    }
}
