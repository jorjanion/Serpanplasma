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
        property string weatherPressure: "1013 hPa"
        property string weatherIcon: "󰖙"
        property string weatherDesc: "Despejado"
        property var weatherForecast: []
        property var weatherHourly: []
        property var weatherHourlyByDay: ({})
        property int selectedForecastIdx: 0
        property string batteryStr: "100%"
        property int batteryPct: 100
        property bool batteryCharging: false
        property string batteryIcon: "󰁹"
        property string networkSsid: "Connected"
        property string networkIcon: "󰤨"
        property string localIp: "127.0.0.1"
        property string publicIp: ""
        property string netRxRate: "0 B/s"
        property string netTxRate: "0 B/s"
        property int volume: 75
        property string volumeIcon: "󰕾"
        property bool volumeMuted: false
        property var audioDevices: []
        property string defaultSink: ""
        property string lang: "ES"
        property string powerProfile: "performance"

        // Dynamic Color Scheme Palettes
        property string themeBg: "#0f172a"
        property string themeCard: "#1e293b"
        property string themeAccent: "#38bdf8"
        property string themeFg: "#f8fafc"
        property string themeMuted: "#94a3b8"
        property string themeBorder: "#334155"
        property bool isLightTheme: false

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
                        if (data.weather_pressure !== undefined) barContainer.weatherPressure = data.weather_pressure;
                        if (data.weather_icon !== undefined) barContainer.weatherIcon = data.weather_icon;
                        if (data.weather_desc !== undefined) barContainer.weatherDesc = data.weather_desc;
                        if (data.weather_forecast !== undefined) barContainer.weatherForecast = data.weather_forecast;
                        if (data.weather_hourly !== undefined) barContainer.weatherHourly = data.weather_hourly;
                        if (data.weather_hourly_by_day !== undefined) barContainer.weatherHourlyByDay = data.weather_hourly_by_day;
                        if (data.battery !== undefined) barContainer.batteryPct = data.battery;
                        if (data.battery_str !== undefined) barContainer.batteryStr = data.battery_str;
                        if (data.battery_charging !== undefined) barContainer.batteryCharging = data.battery_charging;
                        if (data.battery_icon !== undefined) barContainer.batteryIcon = data.battery_icon;
                        if (data.network_ssid !== undefined) barContainer.networkSsid = data.network_ssid;
                        if (data.network_icon !== undefined) barContainer.networkIcon = data.network_icon;
                        if (data.local_ip !== undefined) barContainer.localIp = data.local_ip;
                        if (data.public_ip !== undefined) barContainer.publicIp = data.public_ip;
                        if (data.net_rx_rate !== undefined) barContainer.netRxRate = data.net_rx_rate;
                        if (data.net_tx_rate !== undefined) barContainer.netTxRate = data.net_tx_rate;
                        if (data.volume !== undefined) barContainer.volume = data.volume;
                        if (data.volume_icon !== undefined) barContainer.volumeIcon = data.volume_icon;
                        if (data.volume_muted !== undefined) barContainer.volumeMuted = data.volume_muted;
                        if (data.audio_devices !== undefined) barContainer.audioDevices = data.audio_devices;
                        if (data.default_sink !== undefined) barContainer.defaultSink = data.default_sink;
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

                        // Theme palettes
                        if (data.theme_bg !== undefined) barContainer.themeBg = data.theme_bg;
                        if (data.theme_card !== undefined) barContainer.themeCard = data.theme_card;
                        if (data.theme_accent !== undefined) barContainer.themeAccent = data.theme_accent;
                        if (data.theme_fg !== undefined) barContainer.themeFg = data.theme_fg;
                        if (data.theme_muted !== undefined) barContainer.themeMuted = data.theme_muted;
                        if (data.theme_border !== undefined) barContainer.themeBorder = data.theme_border;
                        if (data.is_light !== undefined) barContainer.isLightTheme = data.is_light;
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

        Timer {
            id: fetchDebounceTimer
            interval: 80
            repeat: false
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
            fetchDebounceTimer.restart();
        }

        function setThemeDirect(scheme) {
            if (scheme === "Serpanplasma-Obsidian") {
                themeBg = "#0f172a"; themeCard = "#1e293b"; themeAccent = "#38bdf8"; themeFg = "#f8fafc"; themeMuted = "#94a3b8"; themeBorder = "#334155"; isLightTheme = false;
            } else if (scheme === "Serpanplasma-Mocha") {
                themeBg = "#1e1e2e"; themeCard = "#313244"; themeAccent = "#89b4fa"; themeFg = "#cdd6f4"; themeMuted = "#a6adc8"; themeBorder = "#45475a"; isLightTheme = false;
            } else if (scheme === "Serpanplasma-Emerald") {
                themeBg = "#064e3b"; themeCard = "#065f46"; themeAccent = "#34d399"; themeFg = "#ecfdf5"; themeMuted = "#6ee7b7"; themeBorder = "#047857"; isLightTheme = false;
            } else if (scheme === "Serpanplasma-Amethyst") {
                themeBg = "#1e1b4b"; themeCard = "#312e81"; themeAccent = "#a855f7"; themeFg = "#faf5ff"; themeMuted = "#c084fc"; themeBorder = "#4338ca"; isLightTheme = false;
            } else if (scheme === "Serpanplasma-Ruby") {
                themeBg = "#450a0a"; themeCard = "#7f1d1d"; themeAccent = "#f43f5e"; themeFg = "#fff1f2"; themeMuted = "#fda4af"; themeBorder = "#991b1b"; isLightTheme = false;
            } else if (scheme === "Serpanplasma-Porcelain") {
                themeBg = "#ffffff"; themeCard = "#f1f5f9"; themeAccent = "#0284c7"; themeFg = "#0f172a"; themeMuted = "#64748b"; themeBorder = "#cbd5e1"; isLightTheme = true;
            } else if (scheme === "Serpanplasma-Latte") {
                themeBg = "#eff1f5"; themeCard = "#e6e9ef"; themeAccent = "#1e66f5"; themeFg = "#4c4f69"; themeMuted = "#7c7f93"; themeBorder = "#ccd0da"; isLightTheme = true;
            } else if (scheme === "Serpanplasma-NordSnow") {
                themeBg = "#eceff4"; themeCard = "#e5e9f0"; themeAccent = "#5e81ac"; themeFg = "#2e3440"; themeMuted = "#4c566a"; themeBorder = "#d8dee9"; isLightTheme = true;
            }
            sendCmd("apply_colorscheme", scheme);
        }

        function stepMonth(delta) {
            calAnim.stop();
            calGridContainer.opacity = 0;
            calGridContainer.x = delta > 0 ? 18 : -18;
            if (delta > 0) {
                if (barContainer.calMonth === 11) {
                    barContainer.calMonth = 0;
                    barContainer.calYear += 1;
                } else {
                    barContainer.calMonth += 1;
                }
            } else {
                if (barContainer.calMonth === 0) {
                    barContainer.calMonth = 11;
                    barContainer.calYear -= 1;
                } else {
                    barContainer.calMonth -= 1;
                }
            }
            calAnim.start();
        }

        Component.onCompleted: {
            updateDateTime();
            barContainer.calMonth = barContainer.todayMonth;
            barContainer.calYear = barContainer.todayYear;
            fetchStatus();
        }

        // ==================== UNIFIED BAR BACKGROUND ====================
        // When not in distinct pills mode, this unified translucent bar spans edge-to-edge across the screen!
        Rectangle {
            anchors.fill: parent
            visible: !barContainer.barDistinctPills
            color: barContainer.themeBg
            opacity: 0.94
            border.color: barContainer.themeBorder
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
                    color: gearMouse.pressed ? barContainer.themeBorder : (gearMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : "transparent"))
                    border.color: barContainer.barDistinctPills ? barContainer.themeBorder : "transparent"
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
                        color: gearMouse.containsMouse ? barContainer.themeAccent : barContainer.themeFg
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
                    color: barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33")
                    border.color: barContainer.barDistinctPills ? barContainer.themeBorder : "transparent"
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
                                color: isActive ? barContainer.themeAccent : (wsMouse.containsMouse ? barContainer.themeMuted : (barContainer.isLightTheme ? "#cbd5e1" : "#334155"))
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
                    color: barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33")
                    border.color: barContainer.barDistinctPills ? barContainer.themeBorder : "transparent"
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
                            color: barContainer.themeAccent
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: barContainer.mediaTitle
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: barContainer.themeFg
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // Compact controls
                        Row {
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "󰒮"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: barContainer.themeMuted
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: barContainer.sendCmd("previous")
                                }
                            }

                            Text {
                                text: barContainer.mediaPlaying ? "󰏤" : "󰐊"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                color: barContainer.themeAccent
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: barContainer.sendCmd("play-pause")
                                }
                            }

                            Text {
                                text: "󰒭"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: barContainer.themeMuted
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: barContainer.sendCmd("next")
                                }
                            }
                        }
                    }
                }
            }

            // ==================== CENTER GROUP ====================
            // Center Time Pill
            Rectangle {
                id: timePill
                visible: barContainer.modClock
                anchors.centerIn: parent
                height: 30
                radius: 10
                color: timeMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                border.color: (timeMouse.containsMouse || calendarDialog.visible) ? barContainer.themeAccent : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
                border.width: 1
                implicitWidth: timeText.implicitWidth + 24
                scale: timeMouse.pressed ? 0.94 : 1.0
                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    id: timeText
                    anchors.centerIn: parent
                    text: barContainer.currentTime
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    font.weight: Font.Black
                    color: barContainer.themeFg
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
                color: dateMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                border.color: (dateMouse.containsMouse || calendarDialog.visible) ? barContainer.themeAccent : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
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
                        color: barContainer.themeAccent
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: barContainer.currentDateShort
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        color: barContainer.themeFg
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
                color: weatherMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                border.color: (weatherMouse.containsMouse || weatherDialog.visible) ? barContainer.themeAccent : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
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
                        color: barContainer.themeAccent
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: barContainer.temp
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.Black
                        color: barContainer.themeFg
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
                    color: themeMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                    border.color: (themeMouse.containsMouse || themeDialog.visible) ? barContainer.themeAccent : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    scale: themeMouse.pressed ? 0.92 : 1.0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "󰏘"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: barContainer.themeAccent
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
                    color: volMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                    border.color: (volMouse.containsMouse || volumeDialog.visible) ? barContainer.themeAccent : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    scale: volMouse.pressed ? 0.92 : 1.0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: barContainer.volumeIcon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: barContainer.volumeMuted ? "#ef4444" : barContainer.themeFg
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

                // Language / Keyboard Layout Pill (CLICKABLE TO TOGGLE ES / US)
                Rectangle {
                    id: layoutPill
                    width: 34
                    height: 28
                    radius: 8
                    color: layoutMouse.containsMouse ? barContainer.themeCard : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                    border.color: layoutMouse.containsMouse ? barContainer.themeAccent : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    scale: layoutMouse.pressed ? 0.92 : 1.0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: barContainer.lang
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: layoutMouse.containsMouse ? barContainer.themeAccent : barContainer.themeFg
                    }

                    MouseArea {
                        id: layoutMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            barContainer.lang = (barContainer.lang === "ES") ? "US" : "ES";
                            barContainer.sendCmd("toggle_layout");
                        }
                    }
                }

                // Network (SOLID WHITE CAPSULE IN DARK / SOLID ACCENT IN LIGHT)
                Rectangle {
                    id: netPill
                    visible: barContainer.modNetwork
                    height: 28
                    radius: 10
                    color: netMouse.containsMouse ? (barContainer.isLightTheme ? barContainer.themeBorder : "#e2e8f0") : (barContainer.isLightTheme ? barContainer.themeCard : "#f8fafc")
                    border.color: barContainer.isLightTheme ? barContainer.themeBorder : "transparent"
                    border.width: barContainer.isLightTheme ? 1 : 0
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
                            color: barContainer.isLightTheme ? barContainer.themeFg : "#0f172a"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: barContainer.networkSsid
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: barContainer.isLightTheme ? barContainer.themeFg : "#0f172a"
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

                // Battery (SOLID WHITE CAPSULE IN DARK / SOLID ACCENT IN LIGHT)
                Rectangle {
                    id: batPill
                    visible: barContainer.modBattery
                    height: 28
                    radius: 10
                    color: batMouse.containsMouse ? (barContainer.isLightTheme ? barContainer.themeBorder : "#e2e8f0") : (barContainer.isLightTheme ? barContainer.themeCard : "#f8fafc")
                    border.color: barContainer.isLightTheme ? barContainer.themeBorder : "transparent"
                    border.width: barContainer.isLightTheme ? 1 : 0
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
                            color: barContainer.isLightTheme ? barContainer.themeFg : "#0f172a"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: barContainer.batteryStr
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: barContainer.isLightTheme ? barContainer.themeFg : "#0f172a"
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

                // Power button (CLICK OPENS POWER ACTION MENU)
                Rectangle {
                    id: powerBtn
                    visible: barContainer.modPower
                    width: 28
                    height: 28
                    radius: 14
                    color: (powerMouse.containsMouse || powerDialog.visible) ? "#ef4444" : (barContainer.barDistinctPills ? barContainer.themeCard : (barContainer.isLightTheme ? "#e2e8f0" : "#141e33"))
                    border.color: (powerMouse.containsMouse || powerDialog.visible) ? "#ef4444" : (barContainer.barDistinctPills ? barContainer.themeBorder : "transparent")
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter
                    scale: powerMouse.pressed ? 0.9 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "⏻"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        color: (powerMouse.containsMouse || powerDialog.visible) ? "#ffffff" : barContainer.themeFg
                    }

                    MouseArea {
                        id: powerMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: powerDialog.visible = !powerDialog.visible
                    }
                }
            }
        }

        // =========================================================================
        // ==================== DROPDOWN POPUP DIALOGS (WAYLAND NATIVE) ============
        // =========================================================================

        // 1. WEATHER DROPDOWN DIALOG (NOW WITH FULL HOURLY FORECAST & RICH STATS)
        PlasmaCore.Dialog {
            id: weatherDialog
            visualParent: weatherPill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 380
                height: 480
                implicitWidth: 380
                implicitHeight: 480
                color: barContainer.themeBg
                radius: 14
                border.color: barContainer.themeAccent
                border.width: 1

                ColumnLayout {
                    id: weatherCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    // Top Bar Header
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "☁ El Tiempo • Madrid, ES"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: barContainer.themeAccent
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "󰑐"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: barContainer.themeMuted
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.fetchStatus()
                            }
                        }
                    }

                    // Main Weather Display
                    RowLayout {
                        spacing: 16
                        Text {
                            text: (barContainer.selectedForecastIdx > 0 && barContainer.weatherForecast.length > barContainer.selectedForecastIdx)
                                  ? barContainer.weatherForecast[barContainer.selectedForecastIdx].icon
                                  : barContainer.weatherIcon
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 36
                            color: barContainer.themeAccent
                        }
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: (barContainer.selectedForecastIdx > 0 && barContainer.weatherForecast.length > barContainer.selectedForecastIdx)
                                      ? (barContainer.weatherForecast[barContainer.selectedForecastIdx].max + " / " + barContainer.weatherForecast[barContainer.selectedForecastIdx].min)
                                      : barContainer.temp
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 24
                                font.weight: Font.Black
                                color: barContainer.themeFg
                            }
                            Text {
                                text: (barContainer.selectedForecastIdx > 0 && barContainer.weatherForecast.length > barContainer.selectedForecastIdx)
                                      ? ("Pronóstico: " + barContainer.weatherForecast[barContainer.selectedForecastIdx].day)
                                      : (barContainer.weatherDesc + " • Sensación " + barContainer.weatherFeelsLike)
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                color: barContainer.themeMuted
                            }
                        }
                    }

                    // Weather details badges row
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Rectangle {
                            Layout.fillWidth: true; height: 32; radius: 6; color: barContainer.themeCard; border.color: barContainer.themeBorder; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 4
                                Text { text: "󰈤"; font.pixelSize: 11; color: barContainer.themeAccent }
                                Text { text: barContainer.weatherHumidity + "% Hum"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: barContainer.themeFg }
                            }
                        }
                        Rectangle {
                            Layout.fillWidth: true; height: 32; radius: 6; color: barContainer.themeCard; border.color: barContainer.themeBorder; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 4
                                Text { text: "󰖝"; font.pixelSize: 11; color: barContainer.themeAccent }
                                Text { text: barContainer.weatherWind; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: barContainer.themeFg }
                            }
                        }
                        Rectangle {
                            Layout.fillWidth: true; height: 32; radius: 6; color: barContainer.themeCard; border.color: barContainer.themeBorder; border.width: 1
                            RowLayout {
                                anchors.centerIn: parent; spacing: 4
                                Text { text: "󰖐"; font.pixelSize: 11; color: barContainer.themeAccent }
                                Text { text: barContainer.weatherPressure; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: barContainer.themeFg }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                    // SECTION 1: HOURLY FORECAST (PRONÓSTICO POR HORAS DINÁMICO POR DÍA)
                    Text {
                        text: "󰥔 Pronóstico por Horas (" + ((barContainer.selectedForecastIdx === 0) ? "Hoy" : (barContainer.weatherForecast && barContainer.weatherForecast.length > barContainer.selectedForecastIdx ? barContainer.weatherForecast[barContainer.selectedForecastIdx].day : "Día " + barContainer.selectedForecastIdx)) + ")"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        color: barContainer.themeMuted
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 84
                        clip: true
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                        ScrollBar.horizontal.policy: ScrollBar.AsNeeded

                        RowLayout {
                            spacing: 6

                            Repeater {
                                model: (barContainer.weatherHourlyByDay && barContainer.weatherHourlyByDay[String(barContainer.selectedForecastIdx)])
                                       ? barContainer.weatherHourlyByDay[String(barContainer.selectedForecastIdx)]
                                       : barContainer.weatherHourly
                                delegate: Rectangle {
                                    width: 60
                                    height: 80
                                    radius: 8
                                    color: hourMouse.containsMouse ? barContainer.themeBorder : barContainer.themeCard
                                    border.color: hourMouse.containsMouse ? barContainer.themeAccent : barContainer.themeBorder
                                    border.width: 1
                                    scale: hourMouse.pressed ? 0.95 : 1.0
                                    Behavior on color { ColorAnimation { duration: 150 } }

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: 2
                                        Text { text: modelData.time; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; color: barContainer.themeMuted; Layout.alignment: Qt.AlignHCenter }
                                        Text { text: modelData.icon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 15; color: barContainer.themeAccent; Layout.alignment: Qt.AlignHCenter }
                                        Text { text: modelData.temp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeFg; Layout.alignment: Qt.AlignHCenter }
                                        Text { text: "󰖗 " + modelData.pop; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 8; color: (modelData.pop !== "0%") ? "#38bdf8" : "#64748b"; Layout.alignment: Qt.AlignHCenter }
                                    }

                                    MouseArea {
                                        id: hourMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                    // SECTION 2: DAILY FORECAST (PRONÓSTICO A 4 DÍAS)
                    Text { text: "󰸗 Pronóstico a 4 Días"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeMuted }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Repeater {
                            model: barContainer.weatherForecast
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: 68
                                radius: 8
                                color: (barContainer.selectedForecastIdx === index) ? barContainer.themeCard : (barContainer.isLightTheme ? "#f1f5f9" : "#1e293b")
                                border.color: (barContainer.selectedForecastIdx === index) ? barContainer.themeAccent : barContainer.themeBorder
                                border.width: (barContainer.selectedForecastIdx === index) ? 2 : 1
                                scale: dayClickArea.pressed ? 0.94 : (dayClickArea.containsMouse ? 1.03 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 150 } }

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 3
                                    Text {
                                        text: modelData.day
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 9
                                        font.weight: Font.Bold
                                        color: (barContainer.selectedForecastIdx === index) ? barContainer.themeAccent : barContainer.themeMuted
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        text: modelData.icon
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 15
                                        color: barContainer.themeAccent
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Text {
                                        text: modelData.max + " / " + modelData.min
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 9
                                        font.weight: Font.Bold
                                        color: barContainer.themeFg
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    id: dayClickArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        barContainer.selectedForecastIdx = index;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // 2. CALENDAR DROPDOWN DIALOG (SMOOTH SLIDE/FADE MONTH TRANSITION)
        PlasmaCore.Dialog {
            id: calendarDialog
            visualParent: timePill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 340
                height: 350
                implicitWidth: 340
                implicitHeight: 350
                color: barContainer.themeBg
                radius: 14
                border.color: barContainer.themeAccent
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
                        color: barContainer.themeCard
                        border.color: barContainer.themeBorder
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 0
                            Text {
                                text: barContainer.currentTime
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 16
                                font.weight: Font.Black
                                color: barContainer.themeAccent
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: barContainer.currentDate
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                color: barContainer.themeMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // Month navigator
                    RowLayout {
                        Layout.fillWidth: true
                        Rectangle {
                            width: 28; height: 28; radius: 7; color: barContainer.themeCard; border.color: barContainer.themeBorder; border.width: 1
                            Text { anchors.centerIn: parent; text: "◀"; font.pixelSize: 10; color: barContainer.themeFg }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.stepMonth(-1)
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
                            color: barContainer.themeFg
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            width: 28; height: 28; radius: 7; color: barContainer.themeCard; border.color: barContainer.themeBorder; border.width: 1
                            Text { anchors.centerIn: parent; text: "▶"; font.pixelSize: 10; color: barContainer.themeFg }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: barContainer.stepMonth(1)
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
                                    color: (index >= 5) ? barContainer.themeAccent : barContainer.themeMuted
                                }
                            }
                        }
                    }

                    // Interactive Calendar Days Grid with Smooth Transition
                    Item {
                        id: calGridContainer
                        Layout.fillWidth: true
                        height: 180

                        ParallelAnimation {
                            id: calAnim
                            NumberAnimation { target: calGridContainer; property: "opacity"; to: 1.0; duration: 220; easing.type: Easing.OutCubic }
                            NumberAnimation { target: calGridContainer; property: "x"; to: 0; duration: 220; easing.type: Easing.OutCubic }
                        }

                        GridLayout {
                            anchors.fill: parent
                            columns: 7
                            rowSpacing: 4
                            columnSpacing: 4

                            Repeater {
                                model: 42
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    height: 26
                                    radius: 7

                                    readonly property int firstDayWeekday: {
                                        var f = new Date(barContainer.calYear, barContainer.calMonth, 1).getDay();
                                        return (f === 0) ? 6 : f - 1; // 0 = Mon, 6 = Sun
                                    }
                                    readonly property int daysInMonth: new Date(barContainer.calYear, barContainer.calMonth + 1, 0).getDate()
                                    readonly property int dayNum: index - firstDayWeekday + 1
                                    readonly property bool isCurrentMonth: dayNum >= 1 && dayNum <= daysInMonth
                                    readonly property bool isToday: isCurrentMonth && dayNum === barContainer.todayDay && barContainer.calMonth === barContainer.todayMonth && barContainer.calYear === barContainer.todayYear

                                    color: isToday ? barContainer.themeAccent : (isCurrentMonth && dayMouse.containsMouse ? barContainer.themeCard : "transparent")
                                    border.color: isToday ? barContainer.themeAccent : (isCurrentMonth && dayMouse.containsMouse ? barContainer.themeBorder : "transparent")
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: isCurrentMonth ? String(dayNum) : ""
                                        font.family: "JetBrainsMono Nerd Font"
                                        font.pixelSize: 10
                                        font.weight: isToday ? Font.Black : Font.Normal
                                        color: isToday ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : (isCurrentMonth ? barContainer.themeFg : "transparent")
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
        }

        // 3. BATTERY & POWER PROFILES DROPDOWN DIALOG (GUARANTEED FIXED DIMENSIONS NO CLIPPING)
        PlasmaCore.Dialog {
            id: batteryDialog
            visualParent: batPill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 350
                height: 275
                implicitWidth: 350
                implicitHeight: 275
                color: barContainer.themeBg
                radius: 14
                border.color: barContainer.themeAccent
                border.width: 1

                ColumnLayout {
                    id: batCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Text { text: barContainer.batteryIcon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: barContainer.themeAccent }
                        Text { text: "Batería y Rendimiento"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: barContainer.themeFg }
                    }

                    // Battery percentage & progress bar
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: barContainer.batteryCharging ? "Cargando (Conectado)" : "Descargando"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: barContainer.themeMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: barContainer.batteryStr; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; font.weight: Font.Black; color: barContainer.themeAccent }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: barContainer.themeCard
                            Rectangle {
                                width: Math.max(6, parent.width * (barContainer.batteryPct / 100.0))
                                height: parent.height
                                radius: 4
                                color: (barContainer.batteryPct <= 20) ? "#ef4444" : ((barContainer.batteryPct <= 45) ? "#f59e0b" : barContainer.themeAccent)
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                    Text { text: "Perfil de Rendimiento Energético"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeMuted }

                    // Power Profiles (Performance, Balanced, Power-saver)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        // Performance
                        Rectangle {
                            Layout.fillWidth: true
                            height: 34
                            radius: 8
                            color: (barContainer.powerProfile === "performance") ? barContainer.themeAccent : barContainer.themeCard
                            border.color: (barContainer.powerProfile === "performance") ? barContainer.themeAccent : barContainer.themeBorder
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: "󰓅"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: (barContainer.powerProfile === "performance") ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                                Text { text: "Rendimiento (144Hz Performance)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (barContainer.powerProfile === "performance") ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.powerProfile = "performance";
                                    barContainer.sendCmd("set_power_profile", "performance");
                                }
                            }
                        }

                        // Balanced
                        Rectangle {
                            Layout.fillWidth: true
                            height: 34
                            radius: 8
                            color: (barContainer.powerProfile === "balanced") ? barContainer.themeAccent : barContainer.themeCard
                            border.color: (barContainer.powerProfile === "balanced") ? barContainer.themeAccent : barContainer.themeBorder
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: "󰾆"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: (barContainer.powerProfile === "balanced") ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                                Text { text: "Equilibrado (Balanced)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (barContainer.powerProfile === "balanced") ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.powerProfile = "balanced";
                                    barContainer.sendCmd("set_power_profile", "balanced");
                                }
                            }
                        }

                        // Power saver
                        Rectangle {
                            Layout.fillWidth: true
                            height: 34
                            radius: 8
                            color: (barContainer.powerProfile === "power-saver") ? barContainer.themeAccent : barContainer.themeCard
                            border.color: (barContainer.powerProfile === "power-saver") ? barContainer.themeAccent : barContainer.themeBorder
                            border.width: 1
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: "󰾆"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: (barContainer.powerProfile === "power-saver") ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                                Text { text: "Ahorro de Batería (Power Saver)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: (barContainer.powerProfile === "power-saver") ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
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

        // 4. NETWORK DROPDOWN DIALOG (PUBLIC IP + RX/TX SPEEDS)
        PlasmaCore.Dialog {
            id: networkDialog
            visualParent: netPill
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 340
                height: 255
                implicitWidth: 340
                implicitHeight: 255
                color: barContainer.themeBg
                radius: 14
                border.color: barContainer.themeAccent
                border.width: 1

                ColumnLayout {
                    id: netCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: "󰤨"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: barContainer.themeAccent }
                        Text { text: "Conexión de Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: barContainer.themeFg }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: netInfoCol.implicitHeight + 20
                        radius: 8
                        color: barContainer.themeCard
                        border.color: barContainer.themeBorder
                        border.width: 1

                        ColumnLayout {
                            id: netInfoCol
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            RowLayout {
                                Text { text: "Red Actual:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: barContainer.themeMuted }
                                Item { Layout.fillWidth: true }
                                Text { text: barContainer.networkSsid; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: barContainer.themeAccent }
                            }
                            RowLayout {
                                Text { text: "IP Local:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: barContainer.themeMuted }
                                Item { Layout.fillWidth: true }
                                Text { text: barContainer.localIp; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeFg }
                            }
                            RowLayout {
                                Text { text: "IP Pública:"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: barContainer.themeMuted }
                                Item { Layout.fillWidth: true }
                                Text { text: barContainer.publicIp !== "" ? barContainer.publicIp : "Detectando..."; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeAccent }
                            }

                            Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                            // Upload / Download Speeds
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󰁅"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#34d399" }
                                    Text { text: "Bajada: " + barContainer.netRxRate; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeFg }
                                }
                                Item { Layout.fillWidth: true }
                                RowLayout {
                                    spacing: 4
                                    Text { text: "󰁝"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; color: "#38bdf8" }
                                    Text { text: "Subida: " + barContainer.netTxRate; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeFg }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 32
                        radius: 8
                        color: barContainer.themeCard
                        border.color: barContainer.themeAccent
                        border.width: 1
                        Text { anchors.centerIn: parent; text: "󰤨 Configuración de Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeAccent }
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

        // 5. VOLUME DROPDOWN DIALOG (SCROLLABLE OUTPUT DEVICE SWITCHER - NO CLIPPING)
        PlasmaCore.Dialog {
            id: volumeDialog
            visualParent: volBtn
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 350
                height: 380
                implicitWidth: 350
                implicitHeight: 380
                color: barContainer.themeBg
                radius: 14
                border.color: barContainer.themeAccent
                border.width: 1

                ColumnLayout {
                    id: volCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: barContainer.volumeIcon; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: barContainer.themeAccent }
                        Text { text: "Control de Audio"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: barContainer.themeFg }
                        Item { Layout.fillWidth: true }
                        Rectangle {
                            width: 65; height: 22; radius: 5
                            color: barContainer.volumeMuted ? "#ef4444" : barContainer.themeCard
                            border.color: barContainer.volumeMuted ? "#ef4444" : barContainer.themeBorder
                            border.width: 1
                            Text { anchors.centerIn: parent; text: barContainer.volumeMuted ? "Silenciado" : "Silenciar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: "#ffffff" }
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
                            Text { text: "Volumen Master"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: barContainer.themeMuted }
                            Item { Layout.fillWidth: true }
                            Text { text: Math.round(volSlider.value) + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: barContainer.themeAccent }
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
                                color: (barContainer.volume === modelData) ? barContainer.themeAccent : barContainer.themeCard
                                border.color: (barContainer.volume === modelData) ? barContainer.themeAccent : barContainer.themeBorder
                                border.width: 1
                                Text { anchors.centerIn: parent; text: modelData + "%"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 9; font.weight: Font.Bold; color: (barContainer.volume === modelData) ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                                MouseArea {
                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                    onClicked: barContainer.sendCmd("vol_set", modelData)
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                    // Output Devices Header & Smooth Scrollable List
                    Text { text: "Dispositivo de Salida (Output Device)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeMuted }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        clip: true
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        ColumnLayout {
                            width: parent.width
                            spacing: 5

                            Repeater {
                                model: barContainer.audioDevices
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    height: 32
                                    radius: 7
                                    color: modelData.active ? (barContainer.isLightTheme ? "#e0f2fe" : "#1e293b") : barContainer.themeCard
                                    border.color: modelData.active ? barContainer.themeAccent : barContainer.themeBorder
                                    border.width: modelData.active ? 1.5 : 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10
                                        spacing: 8

                                        Text {
                                            text: modelData.icon
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 14
                                            color: modelData.active ? barContainer.themeAccent : barContainer.themeMuted
                                        }

                                        Text {
                                            text: modelData.desc
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 10
                                            font.weight: modelData.active ? Font.Bold : Font.Normal
                                            color: modelData.active ? barContainer.themeAccent : barContainer.themeFg
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            visible: modelData.active
                                            text: "󰄵"
                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: 12
                                            color: barContainer.themeAccent
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            barContainer.sendCmd("set_audio_device", modelData.name);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // 6. QUICK THEME SWITCHER DROPDOWN DIALOG (DYNAMIC REACTIVE COLORS)
        PlasmaCore.Dialog {
            id: themeDialog
            visualParent: themeBtn
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 340
                height: 340
                implicitWidth: 340
                implicitHeight: 340
                color: barContainer.themeBg
                radius: 14
                border.color: barContainer.themeAccent
                border.width: 1

                ColumnLayout {
                    id: themeCol
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Text { text: "󰏘"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; color: barContainer.themeAccent }
                        Text { text: "Cambiador Rápido de Tema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: barContainer.themeFg }
                    }

                    Text { text: "Modo Oscuro (Dark Palettes)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeMuted }

                    // Dark Themes Grid
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 6
                        columnSpacing: 6

                        // Obsidian
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: barContainer.themeCard; border.color: "#38bdf8"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#0f172a"; border.color: "#38bdf8"; border.width: 1 }
                                Text { text: "Obsidian"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#38bdf8" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.setThemeDirect("Serpanplasma-Obsidian");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Mocha
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: barContainer.themeCard; border.color: "#89b4fa"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#1e1e2e"; border.color: "#89b4fa"; border.width: 1 }
                                Text { text: "Mocha"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#89b4fa" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.setThemeDirect("Serpanplasma-Mocha");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Emerald
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: barContainer.themeCard; border.color: "#34d399"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#064e3b"; border.color: "#34d399"; border.width: 1 }
                                Text { text: "Emerald"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#34d399" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.setThemeDirect("Serpanplasma-Emerald");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Amethyst
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: barContainer.themeCard; border.color: "#a855f7"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#1e1b4b"; border.color: "#a855f7"; border.width: 1 }
                                Text { text: "Amethyst"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#a855f7" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.setThemeDirect("Serpanplasma-Amethyst");
                                    themeDialog.visible = false;
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                    Text { text: "Modo Claro (Light Palettes)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: barContainer.themeMuted }

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
                                    barContainer.setThemeDirect("Serpanplasma-Porcelain");
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
                                    barContainer.setThemeDirect("Serpanplasma-Latte");
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
                                    barContainer.setThemeDirect("Serpanplasma-NordSnow");
                                    themeDialog.visible = false;
                                }
                            }
                        }

                        // Ruby Red Dark
                        Rectangle {
                            Layout.fillWidth: true; height: 34; radius: 8; color: "#450a0a"; border.color: "#f43f5e"; border.width: 1
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 8; spacing: 6
                                Rectangle { width: 14; height: 14; radius: 3; color: "#7f1d1d"; border.color: "#f43f5e"; border.width: 1 }
                                Text { text: "Ruby Red"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: "#f43f5e" }
                            }
                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    barContainer.setThemeDirect("Serpanplasma-Ruby");
                                    themeDialog.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }

        // 7. POWER MENU DROPDOWN DIALOG (SHUTDOWN, REBOOT, LOGOUT, LOCK, SUSPEND)
        PlasmaCore.Dialog {
            id: powerDialog
            visualParent: powerBtn
            location: PlasmaCore.Types.TopEdge
            type: PlasmaCore.Dialog.PopupMenu
            flags: Qt.Popup | Qt.FramelessWindowHint
            hideOnWindowDeactivate: true
            visible: false

            mainItem: Rectangle {
                width: 260
                height: 265
                implicitWidth: 260
                implicitHeight: 265
                color: barContainer.themeBg
                radius: 14
                border.color: "#ef4444"
                border.width: 1

                ColumnLayout {
                    id: pwrCol
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    RowLayout {
                        spacing: 8
                        Text { text: "⏻"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 16; color: "#ef4444" }
                        Text { text: "Gestión de Energía"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: barContainer.themeFg }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: barContainer.themeBorder }

                    // 1. Apagar Sistema
                    Rectangle {
                        Layout.fillWidth: true; height: 34; radius: 8
                        color: pwrOffMouse.containsMouse ? "#ef4444" : barContainer.themeCard
                        border.color: pwrOffMouse.containsMouse ? "#ef4444" : barContainer.themeBorder
                        border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10
                            Text { text: "⏻"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: pwrOffMouse.containsMouse ? "#ffffff" : "#ef4444" }
                            Text { text: "Apagar Sistema"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: pwrOffMouse.containsMouse ? "#ffffff" : barContainer.themeFg }
                        }
                        MouseArea {
                            id: pwrOffMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { powerDialog.visible = false; barContainer.sendCmd("power_action", "shutdown"); }
                        }
                    }

                    // 2. Reiniciar
                    Rectangle {
                        Layout.fillWidth: true; height: 34; radius: 8
                        color: pwrRebootMouse.containsMouse ? "#f59e0b" : barContainer.themeCard
                        border.color: pwrRebootMouse.containsMouse ? "#f59e0b" : barContainer.themeBorder
                        border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10
                            Text { text: "󰑐"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: pwrRebootMouse.containsMouse ? "#0f172a" : "#f59e0b" }
                            Text { text: "Reiniciar Equipo"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: pwrRebootMouse.containsMouse ? "#0f172a" : barContainer.themeFg }
                        }
                        MouseArea {
                            id: pwrRebootMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { powerDialog.visible = false; barContainer.sendCmd("power_action", "reboot"); }
                        }
                    }

                    // 3. Cerrar Sesión
                    Rectangle {
                        Layout.fillWidth: true; height: 34; radius: 8
                        color: pwrLogoutMouse.containsMouse ? barContainer.themeAccent : barContainer.themeCard
                        border.color: pwrLogoutMouse.containsMouse ? barContainer.themeAccent : barContainer.themeBorder
                        border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10
                            Text { text: "󰍃"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: pwrLogoutMouse.containsMouse ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeAccent }
                            Text { text: "Cerrar Sesión"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: pwrLogoutMouse.containsMouse ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                        }
                        MouseArea {
                            id: pwrLogoutMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { powerDialog.visible = false; barContainer.sendCmd("power_action", "logout"); }
                        }
                    }

                    // 4. Bloquear Pantalla
                    Rectangle {
                        Layout.fillWidth: true; height: 34; radius: 8
                        color: pwrLockMouse.containsMouse ? barContainer.themeAccent : barContainer.themeCard
                        border.color: pwrLockMouse.containsMouse ? barContainer.themeAccent : barContainer.themeBorder
                        border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10
                            Text { text: "󰌾"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: pwrLockMouse.containsMouse ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeAccent }
                            Text { text: "Bloquear Pantalla"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: pwrLockMouse.containsMouse ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                        }
                        MouseArea {
                            id: pwrLockMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { powerDialog.visible = false; barContainer.sendCmd("power_action", "lock"); }
                        }
                    }

                    // 5. Suspender
                    Rectangle {
                        Layout.fillWidth: true; height: 34; radius: 8
                        color: pwrSuspendMouse.containsMouse ? barContainer.themeAccent : barContainer.themeCard
                        border.color: pwrSuspendMouse.containsMouse ? barContainer.themeAccent : barContainer.themeBorder
                        border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10
                            Text { text: "󰤄"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; color: pwrSuspendMouse.containsMouse ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeAccent }
                            Text { text: "Suspender (Dormir)"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: pwrSuspendMouse.containsMouse ? (barContainer.isLightTheme ? "#ffffff" : "#0f172a") : barContainer.themeFg }
                        }
                        MouseArea {
                            id: pwrSuspendMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { powerDialog.visible = false; barContainer.sendCmd("power_action", "suspend"); }
                        }
                    }
                }
            }
        }
    }
}
