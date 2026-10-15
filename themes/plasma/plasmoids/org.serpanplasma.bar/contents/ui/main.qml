import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    Layout.fillWidth: true
    Layout.fillHeight: true

    fullRepresentation: Item {
        id: barContainer
        anchors.fill: parent

        // State properties
        property string currentTime: "22:00:00"
        property string currentDate: "jueves, 15 de octubre"
        property string currentDateShort: "jue, 15 de oct"
        property string mediaTitle: "No hay nada reprc"
        property string mediaArtist: ""
        property bool mediaPlaying: false
        property int currentDesktop: 1
        property int totalDesktops: 8
        property string temp: "22.1°C"
        property string weatherFeelsLike: "21.0°C"
        property int weatherHumidity: 55
        property string weatherWind: "4.0 km/h"
        property string weatherIcon: "󰖙"
        property string weatherDesc: "Despejado"
        property var weatherForecast: []
        property string batteryStr: "100%"
        property int batteryPct: 100
        property bool batteryCharging: false
        property string batteryIcon: "󰁹"
        property string networkSsid: "Connected"
        property string networkIcon: "󰤨"
        property string localIp: "127.0.0.1"
        property int volume: 75
        property string volumeIcon: "󰕾"
        property bool volumeMuted: false
        property string lang: "ES"
        property string powerProfile: "performance"

        // Module visibility & Style properties
        property bool barDistinctPills: true
        property bool modSettings: true
        property bool modWorkspaces: true
        property bool modMedia: true
        property bool modClock: true
        property bool modWeather: true
        property bool modVolume: true
        property bool modNetwork: true
        property bool modBattery: true
        property bool modPower: true

        // Calendar navigation state
        property int calYear: 2026
        property int calMonth: 9 // 0-indexed (9 = October)
        property int todayDay: 15
        property int todayMonth: 9
        property int todayYear: 2026

        function updateDateTime() {
            var now = new Date();
            var h = String(now.getHours()).padStart(2, '0');
            var m = String(now.getMinutes()).padStart(2, '0');
            var s = String(now.getSeconds()).padStart(2, '0');
            currentTime = h + ":" + m + ":" + s;

            var days = ["domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"];
            var daysShort = ["dom", "lun", "mar", "mié", "jue", "vie", "sáb"];
            var months = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
            var monthsShort = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"];

            currentDate = days[now.getDay()] + ", " + now.getDate() + " de " + months[now.getMonth()];
            currentDateShort = daysShort[now.getDay()] + ", " + now.getDate() + " de " + monthsShort[now.getMonth()];

            barContainer.todayDay = now.getDate();
            barContainer.todayMonth = now.getMonth();
            barContainer.todayYear = now.getFullYear();
        }

        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: barContainer.updateDateTime()
        }

        function fetchStatus() {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "http://127.0.0.1:19842/status");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        if (data.media_title !== undefined) barContainer.mediaTitle = data.media_title;
                        if (data.media_artist !== undefined) barContainer.mediaArtist = data.media_artist;
                        if (data.media_playing !== undefined) barContainer.mediaPlaying = data.media_playing;
                        if (data.desktop !== undefined) barContainer.currentDesktop = data.desktop;
                        if (data.temp !== undefined) barContainer.temp = data.temp;
                        if (data.weather_feels_like !== undefined) barContainer.weatherFeelsLike = data.weather_feels_like;
                        if (data.weather_humidity !== undefined) barContainer.weatherHumidity = data.weather_humidity;
                        if (data.weather_wind !== undefined) barContainer.weatherWind = data.weather_wind;
                        if (data.weather_icon !== undefined) barContainer.weatherIcon = data.weather_icon;
                        if (data.weather_desc !== undefined) barContainer.weatherDesc = data.weather_desc;
                        if (data.weather_forecast !== undefined) barContainer.weatherForecast = data.weather_forecast;
                        if (data.battery !== undefined) barContainer.batteryPct = data.battery;
                        if (data.battery_str !== undefined) barContainer.batteryStr = data.battery_str;
                        if (data.battery_charging !== undefined) barContainer.batteryCharging = data.battery_charging;
                        if (data.battery_icon !== undefined) barContainer.batteryIcon = data.battery_icon;
                        if (data.network_ssid !== undefined) barContainer.networkSsid = data.network_ssid;
                        if (data.network_icon !== undefined) barContainer.networkIcon = data.network_icon;
                        if (data.local_ip !== undefined) barContainer.localIp = data.local_ip;
                        if (data.volume !== undefined) barContainer.volume = data.volume;
                        if (data.volume_icon !== undefined) barContainer.volumeIcon = data.volume_icon;
                        if (data.volume_muted !== undefined) barContainer.volumeMuted = data.volume_muted;
                        if (data.lang !== undefined) barContainer.lang = data.lang;
                        if (data.power_profile !== undefined) barContainer.powerProfile = data.power_profile;
                        if (data.bar_distinct_pills !== undefined) barContainer.barDistinctPills = data.bar_distinct_pills;
                        if (data.bar_mod_settings !== undefined) barContainer.modSettings = data.bar_mod_settings;
                        if (data.bar_mod_workspaces !== undefined) barContainer.modWorkspaces = data.bar_mod_workspaces;
                        if (data.bar_mod_media !== undefined) barContainer.modMedia = data.bar_mod_media;
                        if (data.bar_mod_clock !== undefined) barContainer.modClock = data.bar_mod_clock;
                        if (data.bar_mod_weather !== undefined) barContainer.modWeather = data.bar_mod_weather;
                        if (data.bar_mod_volume !== undefined) barContainer.modVolume = data.bar_mod_volume;
                        if (data.bar_mod_network !== undefined) barContainer.modNetwork = data.bar_mod_network;
                        if (data.bar_mod_battery !== undefined) barContainer.modBattery = data.bar_mod_battery;
                        if (data.bar_mod_power !== undefined) barContainer.modPower = data.bar_mod_power;
                    } catch (e) {}
                }
            };
            xhr.send();
        }

        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: barContainer.fetchStatus()
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
            setTimeout(fetchStatus, 80);
        }

        Component.onCompleted: {
            updateDateTime();
            barContainer.calMonth = barContainer.todayMonth;
            barContainer.calYear = barContainer.todayYear;
            fetchStatus();
        }

        // ==================== UNIFIED BAR BACKGROUND ====================
        // When not in distinct pills mode, this unified dark translucent bar spans edge-to-edge across the screen!
        Rectangle {
            anchors.fill: parent
            visible: !barContainer.barDistinctPills
            color: "#0f172a"
            opacity: 0.92
            border.color: "#1e293b"
            border.width: 1
        }

        // --- BAR CONTENT WRAPPER ---
        Item {
            id: barInner
            anchors.fill: parent
            anchors.leftMargin: barContainer.barDistinctPills ? 6 : 14
            anchors.rightMargin: barContainer.barDistinctPills ? 6 : 14
            anchors.topMargin: 3
            anchors.bottomMargin: 3

            // ==================== LEFT GROUP ====================
            Row {
                id: leftGroup
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // Settings / Launcher Button
                Rectangle {
                    id: gearBtn
                    visible: barContainer.modSettings
                    width: 30
                    height: 30
                    radius: 9
                    color: gearMouse.pressed ? "#475569" : (gearMouse.containsMouse ? "#334155" : "#1e293b")
                    border.color: barContainer.barDistinctPills ? "#334155" : "transparent"
                    border.width: barContainer.barDistinctPills ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    scale: gearMouse.pressed ? 0.92 : (gearMouse.containsMouse ? 1.05 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "󰒓"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 15
                        color: "#f8fafc"
                    }

                    MouseArea {
                        id: gearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: barContainer.sendCmd("settings")
                    }
                }

                // Workspaces (Active pill + 7 dots)
                Rectangle {
                    id: wsContainer
                    visible: barContainer.modWorkspaces
                    height: 30
                    radius: 10
                    color: barContainer.barDistinctPills ? "#1e293b" : "#141e33"
                    border.color: barContainer.barDistinctPills ? "#334155" : "transparent"
                    border.width: barContainer.barDistinctPills ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: wsRow.implicitWidth + 16

                    Row {
                        id: wsRow
                        anchors.centerIn: parent
                        spacing: 7

                        Repeater {
                            model: 8
                            delegate: Rectangle {
                                id: wsDot
                                required property int index
                                property bool isActive: (index + 1) === barContainer.currentDesktop

                                height: 16
                                width: isActive ? 34 : 14
                                radius: 8
                                color: isActive ? "#38bdf8" : (wsMouse.containsMouse ? "#64748b" : "#334155")
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
                                Behavior on color { ColorAnimation { duration: 200 } }
                                scale: wsMouse.pressed ? 0.9 : 1.0
                                Behavior on scale { NumberAnimation { duration: 150 } }

                                MouseArea {
                                    id: wsMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        barContainer.currentDesktop = index + 1;
                                        barContainer.sendCmd("desktop", index + 1);
                                    }
                                }
                            }
                        }
                    }
                }

                // Media Player Capsule
                Rectangle {
                    id: mediaPill
                    visible: barContainer.modMedia
                    height: 30
                    radius: 10
                    color: barContainer.barDistinctPills ? "#1e293b" : "#141e33"
                    border.color: barContainer.barDistinctPills ? "#334155" : "transparent"
                    border.width: barContainer.barDistinctPills ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: mediaContentRow.implicitWidth + 20

                    Row {
                        id: mediaContentRow
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "󰎈"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            color: "#38bdf8"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: barContainer.mediaTitle
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#f8fafc"
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            width: Math.min(implicitWidth, 140)
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // Prev
                        Text {
                            text: "󰒮"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: prevMouse.containsMouse ? "#ffffff" : "#94a3b8"
                            anchors.verticalCenter: parent.verticalCenter
                            scale: prevMouse.pressed ? 0.88 : 1.0
                            Behavior on color { ColorAnimation { duration: 150 } }

                            MouseArea {
                                id: prevMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.sendCmd("previous")
                            }
                        }

                        // Play/Pause
                        Text {
                            text: barContainer.mediaPlaying ? "󰏤" : "󰐊"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            color: playMouse.containsMouse ? "#ffffff" : "#f8fafc"
                            anchors.verticalCenter: parent.verticalCenter
                            scale: playMouse.pressed ? 0.88 : 1.0
                            Behavior on color { ColorAnimation { duration: 150 } }

                            MouseArea {
                                id: playMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.sendCmd("play-pause")
                            }
                        }

                        // Next
                        Text {
                            text: "󰒭"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: nextMouse.containsMouse ? "#ffffff" : "#94a3b8"
                            anchors.verticalCenter: parent.verticalCenter
                            scale: nextMouse.pressed ? 0.88 : 1.0
                            Behavior on color { ColorAnimation { duration: 150 } }

                            MouseArea {
                                id: nextMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.sendCmd("next")
                            }
                        }
                    }
                }
            }

            // ==================== CENTER GROUP (STRICTLY CENTERED TIME + SYMMETRICAL TRIO) ====================
            // Center Time Pill: Anchored directly to parent.horizontalCenter ensuring the TIME is mathematically centered!
            Rectangle {
                id: timePill
                visible: barContainer.modClock
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                radius: 10
                color: timeMouse.containsMouse ? "#334155" : (barContainer.barDistinctPills ? "#1e293b" : "#141e33")
                border.color: (timeMouse.containsMouse || calendarDialog.visible) ? "#38bdf8" : (barContainer.barDistinctPills ? "#334155" : "transparent")
                border.width: 1
                implicitWidth: timeText.implicitWidth + 24
                scale: timeMouse.pressed ? 0.94 : 1.0
                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    id: timeText
                    anchors.centerIn: parent
                    text: barContainer.currentTime
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    font.weight: Font.Black
                    color: "#ffffff"
                }

                MouseArea {
                    id: timeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        calendarDialog.visible = !calendarDialog.visible;
                    }
                }
            }

            // Left Date Pill (Anchored to the left of the centered time)
            Rectangle {
                id: datePill
                visible: barContainer.modClock
                anchors.right: timePill.left
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                radius: 10
                color: dateMouse.containsMouse ? "#334155" : (barContainer.barDistinctPills ? "#1e293b" : "#141e33")
                border.color: (dateMouse.containsMouse || calendarDialog.visible) ? "#38bdf8" : (barContainer.barDistinctPills ? "#334155" : "transparent")
                border.width: 1
                implicitWidth: dateRow.implicitWidth + 20
                scale: dateMouse.pressed ? 0.94 : 1.0
                Behavior on color { ColorAnimation { duration: 150 } }

                Row {
                    id: dateRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "󰸗"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: "#38bdf8"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: barContainer.currentDateShort
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        color: "#cbd5e1"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: dateMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        calendarDialog.visible = !calendarDialog.visible;
                    }
                }
            }

            // Right Weather Pill (Anchored to the right of the centered time)
            Rectangle {
                id: weatherPill
                visible: barContainer.modWeather
                anchors.left: timePill.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                height: 30
                radius: 10
                color: weatherMouse.containsMouse ? "#334155" : (barContainer.barDistinctPills ? "#1e293b" : "#141e33")
                border.color: (weatherMouse.containsMouse || weatherDialog.visible) ? "#38bdf8" : (barContainer.barDistinctPills ? "#334155" : "transparent")
                border.width: 1
                implicitWidth: weatherRow.implicitWidth + 20
                scale: weatherMouse.pressed ? 0.94 : 1.0
                Behavior on color { ColorAnimation { duration: 150 } }

                Row {
                    id: weatherRow
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: barContainer.weatherIcon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: barContainer.temp
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.Black
                        color: "#f8fafc"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: weatherMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        weatherDialog.visible = !weatherDialog.visible;
                    }
                }
            }

            // ==================== RIGHT GROUP ====================
            Row {
                id: rightGroup
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // Quick Theme Switcher Button
                Rectangle {
                    id: themeBtn
                    width: 32
                    height: 28
                    radius: 8
                    color: themeMouse.containsMouse ? "#334155" : (barContainer.barDistinctPills ? "#1e293b" : "#141e33")
                    border.color: (themeMouse.containsMouse || themeDialog.visible) ? "#38bdf8" : (barContainer.barDistinctPills ? "#334155" : "transparent")
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    scale: themeMouse.pressed ? 0.92 : 1.0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "󰏘"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: "#38bdf8"
                    }

                    MouseArea {
                        id: themeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            themeDialog.visible = !themeDialog.visible;
                        }
                    }
                }

                // Volume Button
                Rectangle {
                    id: volBtn
                    visible: barContainer.modVolume
                    width: 32
                    height: 28
                    radius: 8
                    color: volMouse.containsMouse ? "#334155" : (barContainer.barDistinctPills ? "#1e293b" : "#141e33")
                    border.color: (volMouse.containsMouse || volumeDialog.visible) ? "#38bdf8" : (barContainer.barDistinctPills ? "#334155" : "transparent")
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    scale: volMouse.pressed ? 0.92 : 1.0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: barContainer.volumeIcon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: barContainer.volumeMuted ? "#ef4444" : "#f8fafc"
                    }

                    MouseArea {
                        id: volMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            volumeDialog.visible = !volumeDialog.visible;
                        }
                        onWheel: function(wheel) {
                            if (wheel.angleDelta.y > 0) {
                                barContainer.sendCmd("vol_up");
                            } else {
                                barContainer.sendCmd("vol_down");
                            }
                        }
                    }
                }

                // Language
                Rectangle {
                    width: 34
                    height: 28
                    radius: 8
                    color: barContainer.barDistinctPills ? "#1e293b" : "#141e33"
                    border.color: barContainer.barDistinctPills ? "#334155" : "transparent"
                    border.width: barContainer.barDistinctPills ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: barContainer.lang
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: "#f8fafc"
                    }
                }

                // Network (SOLID WHITE CAPSULE)
                Rectangle {
                    id: netPill
                    visible: barContainer.modNetwork
                    height: 28
                    radius: 10
                    color: netMouse.containsMouse ? "#e2e8f0" : "#f8fafc"
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: netRow.implicitWidth + 20
                    scale: netMouse.pressed ? 0.94 : 1.0

                    Row {
                        id: netRow
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: barContainer.networkIcon
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            color: "#0f172a"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: barContainer.networkSsid
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: "#0f172a"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: netMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            networkDialog.visible = !networkDialog.visible;
                        }
                    }
                }

                // Battery (SOLID WHITE CAPSULE)
                Rectangle {
                    id: batPill
                    visible: barContainer.modBattery
                    height: 28
                    radius: 10
                    color: batMouse.containsMouse ? "#e2e8f0" : "#f8fafc"
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: batRow.implicitWidth + 20
                    scale: batMouse.pressed ? 0.94 : 1.0

                    Row {
                        id: batRow
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: barContainer.batteryIcon
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: "#0f172a"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: barContainer.batteryStr
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: "#0f172a"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: batMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            batteryDialog.visible = !batteryDialog.visible;
                        }
                    }
                }

                // Power button
                Rectangle {
                    id: powerBtn
                    visible: barContainer.modPower
                    width: 28
                    height: 28
                    radius: 14
                    color: powerMouse.containsMouse ? "#ef4444" : (barContainer.barDistinctPills ? "#1e293b" : "#141e33")
                    border.color: barContainer.barDistinctPills ? "#334155" : "transparent"
                    border.width: barContainer.barDistinctPills ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    scale: powerMouse.pressed ? 0.9 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "⏻"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        color: "#f8fafc"
                    }

                    MouseArea {
                        id: powerMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: barContainer.sendCmd("power")
                    }
                }
            }
        }

        // =========================================================================
        // ==================== DROPDOWN POPUP DIALOGS (WAYLAND NATIVE) ============
        // =========================================================================

        // 1. WEATHER DROPDOWN DIALOG
        PlasmaCore.Dialog {
            id: weatherDialog
            visualParent: weatherPill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            visible: false

            mainItem: Rectangle {
                width: 320
                implicitHeight: weatherCol.implicitHeight + 28
                color: "#0f172a"
                radius: 14
                border.color: "#38bdf8"
                border.width: 1

                ColumnLayout {
                    id: weatherCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "☁ El Tiempo • Madrid"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#38bdf8"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "󰑐"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: "#94a3b8"
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.fetchStatus()
                            }
                        }
                    }

                    RowLayout {
                        spacing: 14
                        Text {
                            text: barContainer.weatherIcon
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 36
                            color: "#ffffff"
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: barContainer.temp
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 24
                                font.weight: Font.Black
                                color: "#f8fafc"
                            }
                            Text {
                                text: barContainer.weatherDesc
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: "#94a3b8"
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: "Sensación"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#64748b" }
                            Text { text: barContainer.weatherFeelsLike; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#cbd5e1" }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: "Humedad"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#64748b" }
                            Text { text: barContainer.weatherHumidity + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#cbd5e1" }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: "Viento"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#64748b" }
                            Text { text: barContainer.weatherWind; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#cbd5e1" }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

                    Text { text: "Pronóstico Próximos Días"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#94a3b8" }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Repeater {
                            model: barContainer.weatherForecast
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: 60
                                radius: 8
                                color: "#1e293b"
                                border.color: "#334155"
                                border.width: 1

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 2
                                    Text { text: modelData.day; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#94a3b8"; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: modelData.icon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: "#38bdf8"; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: modelData.max + " / " + modelData.min; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: "#f8fafc"; Layout.alignment: Qt.AlignHCenter }
                                }
                            }
                        }
                    }
                }
            }
        }

        // 2. CALENDAR DROPDOWN DIALOG
        PlasmaCore.Dialog {
            id: calendarDialog
            visualParent: timePill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            visible: false

            mainItem: Rectangle {
                width: 310
                implicitHeight: calCol.implicitHeight + 28
                color: "#0f172a"
                radius: 14
                border.color: "#38bdf8"
                border.width: 1

                ColumnLayout {
                    id: calCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    // Live digital time & full date header
                    Rectangle {
                        Layout.fillWidth: true
                        height: 52
                        radius: 10
                        color: "#1e293b"
                        border.color: "#334155"
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 0
                            Text {
                                text: barContainer.currentTime
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 16
                                font.weight: Font.Black
                                color: "#38bdf8"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: barContainer.currentDate
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                color: "#94a3b8"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // Month navigator
                    RowLayout {
                        Layout.fillWidth: true
                        Rectangle {
                            width: 26; height: 26; radius: 6; color: "#1e293b"; border.color: "#334155"; border.width: 1
                            Text { anchors.centerIn: parent; text: "◀"; font.pixelSize: 10; color: "#cbd5e1" }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (barContainer.calMonth === 0) {
                                        barContainer.calMonth = 11;
                                        barContainer.calYear -= 1;
                                    } else {
                                        barContainer.calMonth -= 1;
                                    }
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: {
                                var monthNames = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
                                return monthNames[barContainer.calMonth] + " " + barContainer.calYear;
                            }
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            color: "#f8fafc"
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            width: 26; height: 26; radius: 6; color: "#1e293b"; border.color: "#334155"; border.width: 1
                            Text { anchors.centerIn: parent; text: "▶"; font.pixelSize: 10; color: "#cbd5e1" }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (barContainer.calMonth === 11) {
                                        barContainer.calMonth = 0;
                                        barContainer.calYear += 1;
                                    } else {
                                        barContainer.calMonth += 1;
                                    }
                                }
                            }
                        }
                    }

                    // Days of week header
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Repeater {
                            model: ["L", "M", "X", "J", "V", "S", "D"]
                            delegate: Item {
                                Layout.fillWidth: true
                                height: 20
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    font.weight: Font.Bold
                                    color: (index >= 5) ? "#38bdf8" : "#64748b"
                                }
                            }
                        }
                    }

                    // Interactive Calendar Days Grid (42 cells: 7 columns x 6 rows)
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 7
                        rowSpacing: 4
                        columnSpacing: 4

                        Repeater {
                            model: 42
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: 28
                                radius: 7

                                readonly property int firstDayWeekday: {
                                    var f = new Date(barContainer.calYear, barContainer.calMonth, 1).getDay();
                                    return (f === 0) ? 6 : f - 1; // 0 = Mon, 6 = Sun
                                }
                                readonly property int daysInMonth: new Date(barContainer.calYear, barContainer.calMonth + 1, 0).getDate()
                                readonly property int dayNum: index - firstDayWeekday + 1
                                readonly property bool isCurrentMonth: dayNum >= 1 && dayNum <= daysInMonth
                                readonly property bool isToday: isCurrentMonth && dayNum === barContainer.todayDay && barContainer.calMonth === barContainer.todayMonth && barContainer.calYear === barContainer.todayYear

                                color: isToday ? "#38bdf8" : (isCurrentMonth && dayMouse.containsMouse ? "#1e293b" : "transparent")
                                border.color: isToday ? "#38bdf8" : (isCurrentMonth && dayMouse.containsMouse ? "#334155" : "transparent")
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: isCurrentMonth ? String(dayNum) : ""
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    font.weight: isToday ? Font.Black : Font.Normal
                                    color: isToday ? "#0f172a" : (isCurrentMonth ? "#f8fafc" : "transparent")
                                }

                                MouseArea {
                                    id: dayMouse
                                    anchors.fill: parent
                                    enabled: isCurrentMonth
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }
            }
        }

        // 3. BATTERY & POWER PROFILES DROPDOWN DIALOG
        PlasmaCore.Dialog {
            id: batteryDialog
            visualParent: batPill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            visible: false

            mainItem: Rectangle {
                width: 290
                implicitHeight: batCol.implicitHeight + 28
                color: "#0f172a"
                radius: 14
                border.color: "#38bdf8"
                border.width: 1

                ColumnLayout {
                    id: batCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: barContainer.batteryIcon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" }
                        Text { text: "Batería y Rendimiento"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                    }

                    // Battery percentage & progress bar
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: barContainer.batteryCharging ? "Cargando (Conectado)" : "Descargando"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: "#94a3b8" }
                            Item { Layout.fillWidth: true }
                            Text { text: barContainer.batteryStr; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; font.weight: Font.Black; color: "#38bdf8" }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: "#1e293b"
                            Rectangle {
                                width: Math.max(6, parent.width * (barContainer.batteryPct / 100.0))
                                height: parent.height
                                radius: 4
                                color: (barContainer.batteryPct <= 20) ? "#ef4444" : ((barContainer.batteryPct <= 45) ? "#f59e0b" : "#38bdf8")
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

                    Text { text: "Perfil de Energía (Power Profile)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#94a3b8" }

                    // Power Profiles (Performance, Balanced, Power-saver)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 8
                            color: (barContainer.powerProfile === "performance") ? "#38bdf8" : "#1e293b"
                            border.color: (barContainer.powerProfile === "performance") ? "#38bdf8" : "#334155"
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: "󰓅"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 13; color: (barContainer.powerProfile === "performance") ? "#0f172a" : "#f8fafc" }
                                Text { text: "Rendimiento (Performance 144Hz)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (barContainer.powerProfile === "performance") ? "#0f172a" : "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.powerProfile = "performance";
                                    barContainer.sendCmd("set_power_profile", "performance");
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 8
                            color: (barContainer.powerProfile === "balanced") ? "#38bdf8" : "#1e293b"
                            border.color: (barContainer.powerProfile === "balanced") ? "#38bdf8" : "#334155"
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: "󰾆"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 13; color: (barContainer.powerProfile === "balanced") ? "#0f172a" : "#f8fafc" }
                                Text { text: "Equilibrado (Balanced)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (barContainer.powerProfile === "balanced") ? "#0f172a" : "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.powerProfile = "balanced";
                                    barContainer.sendCmd("set_power_profile", "balanced");
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 32
                            radius: 8
                            color: (barContainer.powerProfile === "power-saver") ? "#38bdf8" : "#1e293b"
                            border.color: (barContainer.powerProfile === "power-saver") ? "#38bdf8" : "#334155"
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: "󰾆"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 13; color: (barContainer.powerProfile === "power-saver") ? "#0f172a" : "#f8fafc" }
                                Text { text: "Ahorro de Batería (Power Saver)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (barContainer.powerProfile === "power-saver") ? "#0f172a" : "#f8fafc" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.powerProfile = "power-saver";
                                    barContainer.sendCmd("set_power_profile", "power-saver");
                                }
                            }
                        }
                    }
                }
            }
        }

        // 4. NETWORK DROPDOWN DIALOG
        PlasmaCore.Dialog {
            id: networkDialog
            visualParent: netPill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            visible: false

            mainItem: Rectangle {
                width: 280
                implicitHeight: netCol.implicitHeight + 28
                color: "#0f172a"
                radius: 14
                border.color: "#38bdf8"
                border.width: 1

                ColumnLayout {
                    id: netCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: "󰤨"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" }
                        Text { text: "Conexión de Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 60
                        radius: 8
                        color: "#1e293b"
                        border.color: "#334155"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 2
                            RowLayout {
                                Text { text: "Red Actual:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                Text { text: barContainer.networkSsid; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: "#38bdf8" }
                            }
                            RowLayout {
                                Text { text: "IP Local:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                                Text { text: barContainer.localIp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#f8fafc" }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 32
                        radius: 8
                        color: "#1e293b"
                        border.color: "#38bdf8"
                        border.width: 1
                        Text { anchors.centerIn: parent; text: "󰤨 Configuración de Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                networkDialog.visible = false;
                                barContainer.sendCmd("open_url", "kcmshell6 kcm_networkmanagement");
                            }
                        }
                    }
                }
            }
        }

        // 5. VOLUME DROPDOWN DIALOG
        PlasmaCore.Dialog {
            id: volumeDialog
            visualParent: volBtn
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            visible: false

            mainItem: Rectangle {
                width: 270
                implicitHeight: volCol.implicitHeight + 28
                color: "#0f172a"
                radius: 14
                border.color: "#38bdf8"
                border.width: 1

                ColumnLayout {
                    id: volCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: barContainer.volumeIcon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" }
                        Text { text: "Control de Audio"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                        Item { Layout.fillWidth: true }
                        Rectangle {
                            width: 54; height: 22; radius: 5
                            color: barContainer.volumeMuted ? "#ef4444" : "#1e293b"
                            border.color: barContainer.volumeMuted ? "#ef4444" : "#334155"
                            border.width: 1
                            Text { anchors.centerIn: parent; text: barContainer.volumeMuted ? "Muted" : "Mute"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: "#ffffff" }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.sendCmd("vol_mute")
                            }
                        }
                    }

                    // Volume slider
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Volumen Master"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: "#94a3b8" }
                            Item { Layout.fillWidth: true }
                            Text { text: Math.round(volSlider.value) + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#38bdf8" }
                        }
                        Slider {
                            id: volSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: barContainer.volume
                            stepSize: 1
                            onMoved: barContainer.sendCmd("vol_set", Math.round(value))
                        }
                    }

                    // Quick presets
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Repeater {
                            model: [25, 50, 75, 100]
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: 24
                                radius: 6
                                color: (barContainer.volume === modelData) ? "#38bdf8" : "#1e293b"
                                border.color: (barContainer.volume === modelData) ? "#38bdf8" : "#334155"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: modelData + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: (barContainer.volume === modelData) ? "#0f172a" : "#cbd5e1" }
                                MouseArea {
                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                    onClicked: barContainer.sendCmd("vol_set", modelData)
                                }
                            }
                        }
                    }
                }
            }
        }

        // 6. QUICK THEME SWITCHER DROPDOWN DIALOG (DARK & LIGHT THEMES)
        PlasmaCore.Dialog {
            id: themeDialog
            visualParent: themeBtn
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            visible: false

            mainItem: Rectangle {
                width: 320
                implicitHeight: themeCol.implicitHeight + 28
                color: "#0f172a"
                radius: 14
                border.color: "#38bdf8"
                border.width: 1

                ColumnLayout {
                    id: themeCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: "󰏘"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: "#38bdf8" }
                        Text { text: "Cambiador Rápido de Tema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: "#f8fafc" }
                    }

                    Text { text: "Modo Oscuro (Dark Palettes)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#94a3b8" }

                    // Dark Themes Grid
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 6
                        columnSpacing: 6

                        // Obsidian
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#1e293b"; border.color: "#38bdf8"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#0f172a"; border.color: "#38bdf8"; border.width: 1 }
                                Text { text: "Obsidian"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Obsidian");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Mocha
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#1e1e2e"; border.color: "#89b4fa"; border.width: 1 }
                                Text { text: "Mocha"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#89b4fa" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Mocha");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Emerald
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#064e3b"; border.color: "#34d399"; border.width: 1 }
                                Text { text: "Emerald"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#34d399" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Emerald");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Amethyst
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#1e293b"; border.color: "#334155"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#1e1b4b"; border.color: "#a855f7"; border.width: 1 }
                                Text { text: "Amethyst"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#a855f7" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Amethyst");
                                    themeDialog.visible = false;
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

                    Text { text: "Modo Claro (Light Palettes)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#94a3b8" }

                    // Light Themes Grid
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 6
                        columnSpacing: 6

                        // Porcelain Light
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#f8fafc"; border.color: "#0284c7"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#f1f5f9"; border.color: "#0284c7"; border.width: 1 }
                                Text { text: "Porcelain"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#0f172a" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Porcelain");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Latte Light
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#eff1f5"; border.color: "#1e66f5"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#e6e9ef"; border.color: "#1e66f5"; border.width: 1 }
                                Text { text: "Latte Light"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#4c4f69" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Latte");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Nord Snow Light
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#eceff4"; border.color: "#5e81ac"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#e5e9f0"; border.color: "#5e81ac"; border.width: 1 }
                                Text { text: "Nord Snow"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#2e3440" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-NordSnow");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Ruby Red Dark
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#1e293b"; border.color: "#f43f5e"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#450a0a"; border.color: "#f43f5e"; border.width: 1 }
                                Text { text: "Ruby Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#f43f5e" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.sendCmd("apply_colorscheme", "Serpanplasma-Ruby");
                                    themeDialog.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
