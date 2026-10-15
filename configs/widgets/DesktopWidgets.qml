import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: desktopWindow
    visible: true
    width: 360
    height: 720
    x: Screen.width - width - 36
    y: 64
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysBelowHint | Qt.Tool
    title: "Serpanplasma Desktop Widgets"

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

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // 1. CLOCK & DATE DESKTOP WIDGET
        Rectangle {
            Layout.fillWidth: true
            height: 125
            radius: 16
            color: "#0f172a"
            opacity: 0.92
            border.color: "#1e293b"
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    text: desktopWindow.currentTime
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 42
                    font.weight: Font.Black
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: desktopWindow.currentDate
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: "#38bdf8"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // 2. HARDWARE USAGE (CPU, RAM, DISK, UPTIME)
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: usageCol.implicitHeight + 32
            radius: 16
            color: "#0f172a"
            opacity: 0.92
            border.color: "#1e293b"
            border.width: 1

            ColumnLayout {
                id: usageCol
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 8
                    Text { text: "󰍛"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 16; color: "#38bdf8" }
                    Text { text: "Monitor del Sistema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                    Item { Layout.fillWidth: true }
                    Text { text: "󰅐 " + desktopWindow.uptimeStr; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#64748b" }
                }

                // CPU
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "󰻠 CPU (AMD Ryzen)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                        Item { Layout.fillWidth: true }
                        Text { text: desktopWindow.cpuPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 6; radius: 3; color: "#1e293b"
                        Rectangle {
                            width: Math.max(4, parent.width * (desktopWindow.cpuPct / 100.0))
                            height: parent.height; radius: 3
                            color: (desktopWindow.cpuPct > 80) ? "#ef4444" : "#38bdf8"
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
                        Text { text: "󰘚 RAM (" + desktopWindow.ramUsed + " / " + desktopWindow.ramTotal + " GB)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                        Item { Layout.fillWidth: true }
                        Text { text: desktopWindow.ramPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 6; radius: 3; color: "#1e293b"
                        Rectangle {
                            width: Math.max(4, parent.width * (desktopWindow.ramPct / 100.0))
                            height: parent.height; radius: 3
                            color: (desktopWindow.ramPct > 85) ? "#ef4444" : "#38bdf8"
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
                        Text { text: "󰋊 Almacenamiento (Libre: " + desktopWindow.diskFree + " GB)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                        Item { Layout.fillWidth: true }
                        Text { text: desktopWindow.diskPct + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 6; radius: 3; color: "#1e293b"
                        Rectangle {
                            width: Math.max(4, parent.width * (desktopWindow.diskPct / 100.0))
                            height: parent.height; radius: 3
                            color: "#38bdf8"
                            Behavior on width { NumberAnimation { duration: 250 } }
                        }
                    }
                }
            }
        }

        // 3. WEATHER DESKTOP WIDGET
        Rectangle {
            Layout.fillWidth: true
            height: 110
            radius: 16
            color: "#0f172a"
            opacity: 0.92
            border.color: "#1e293b"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 14

                Text {
                    text: desktopWindow.weatherIcon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 38
                    color: "#ffffff"
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    RowLayout {
                        Text { text: desktopWindow.temp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 22; font.weight: Font.Black; color: "#f8fafc" }
                        Item { Layout.fillWidth: true }
                        Text { text: "Madrid, ES"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                    }
                    Text { text: desktopWindow.weatherDesc; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#94a3b8" }
                    RowLayout {
                        spacing: 8
                        Text { text: "Sensación: " + desktopWindow.weatherFeels; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#64748b" }
                        Text { text: "•"; color: "#334155" }
                        Text { text: "Humedad: " + desktopWindow.weatherHum + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#64748b" }
                    }
                }
            }
        }

        // 4. MUSIC NOW-PLAYING WIDGET
        Rectangle {
            Layout.fillWidth: true
            height: 84
            radius: 16
            color: "#0f172a"
            opacity: 0.92
            border.color: "#1e293b"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                Rectangle {
                    width: 44
                    height: 44
                    radius: 10
                    color: "#1e293b"
                    border.color: "#38bdf8"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰎈"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: "#38bdf8"
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
                        color: "#f8fafc"
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        Layout.fillWidth: true
                    }
                    Text {
                        text: desktopWindow.mediaArtist !== "" ? desktopWindow.mediaArtist : "Reproductor MPRIS"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 9
                        color: "#94a3b8"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                // Controls
                RowLayout {
                    spacing: 6
                    Rectangle {
                        width: 28; height: 28; radius: 7; color: "#1e293b"
                        Text { anchors.centerIn: parent; text: "󰒮"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: { var xhr = new XMLHttpRequest(); xhr.open("GET", "http://127.0.0.1:19842/cmd?action=previous"); xhr.send(); }
                        }
                    }
                    Rectangle {
                        width: 32; height: 32; radius: 8; color: "#38bdf8"
                        Text { anchors.centerIn: parent; text: desktopWindow.mediaPlaying ? "󰏤" : "󰐊"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#0f172a" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: { var xhr = new XMLHttpRequest(); xhr.open("GET", "http://127.0.0.1:19842/cmd?action=play-pause"); xhr.send(); }
                        }
                    }
                    Rectangle {
                        width: 28; height: 28; radius: 7; color: "#1e293b"
                        Text { anchors.centerIn: parent; text: "󰒭"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#cbd5e1" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: { var xhr = new XMLHttpRequest(); xhr.open("GET", "http://127.0.0.1:19842/cmd?action=next"); xhr.send(); }
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
