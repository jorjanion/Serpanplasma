import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    Layout.fillWidth: true
    Layout.fillHeight: true

    fullRepresentation: Item {
        id: barContainer
        anchors.fill: parent

        // State properties
        property string currentTime: "20:01:47"
        property string currentDate: "domingo, 13 de septiembre"
        property string mediaTitle: "No hay nada reprc"
        property bool mediaPlaying: false
        property int currentDesktop: 1
        property int totalDesktops: 8
        property string temp: "13.9°C"
        property string weatherIcon: "☁"
        property string batteryStr: "43%"
        property string batteryIcon: "󰁹"
        property string networkSsid: "Connected"
        property string networkIcon: "󰤨"
        property string volumeIcon: "󰕾"
        property string lang: "EN"

        function updateDateTime() {
            var now = new Date();
            var h = String(now.getHours()).padStart(2, '0');
            var m = String(now.getMinutes()).padStart(2, '0');
            var s = String(now.getSeconds()).padStart(2, '0');
            currentTime = h + ":" + m + ":" + s;

            var days = ["domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"];
            var months = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
            currentDate = days[now.getDay()] + ", " + now.getDate() + " de " + months[now.getMonth()];
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
                        if (data.media_playing !== undefined) barContainer.mediaPlaying = data.media_playing;
                        if (data.desktop !== undefined) barContainer.currentDesktop = data.desktop;
                        if (data.temp !== undefined) barContainer.temp = data.temp;
                        if (data.weather_icon !== undefined) barContainer.weatherIcon = data.weather_icon;
                        if (data.battery_str !== undefined) barContainer.batteryStr = data.battery_str;
                        if (data.battery_icon !== undefined) barContainer.batteryIcon = data.battery_icon;
                        if (data.network_ssid !== undefined) barContainer.networkSsid = data.network_ssid;
                        if (data.network_icon !== undefined) barContainer.networkIcon = data.network_icon;
                        if (data.volume_icon !== undefined) barContainer.volumeIcon = data.volume_icon;
                        if (data.lang !== undefined) barContainer.lang = data.lang;
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

        function sendCmd(action, val) {
            var url = "http://127.0.0.1:19842/cmd?action=" + action;
            if (val !== undefined) {
                url += "&val=" + val;
            }
            var xhr = new XMLHttpRequest();
            xhr.open("GET", url);
            xhr.send();
            // Immediate optimistic update
            setTimeout(fetchStatus, 80);
        }

        Component.onCompleted: {
            updateDateTime();
            fetchStatus();
        }

        // --- BAR CONTENT ---
        Item {
            id: barInner
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            anchors.topMargin: 3
            anchors.bottomMargin: 3

            // --- LEFT GROUP ---
            Row {
                id: leftGroup
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // Settings / Launcher Button
                Rectangle {
                    id: gearBtn
                    width: 30
                    height: 30
                    radius: 9
                    color: gearMouse.pressed ? "#475569" : (gearMouse.containsMouse ? "#334155" : "#1e293b")
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
                        onClicked: barContainer.sendCmd("launcher")
                    }
                }

                // Workspaces (Active pill + 7 dots)
                Row {
                    id: wsRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 7

                    Repeater {
                        model: 8
                        delegate: Rectangle {
                            id: wsDot
                            required property int index
                            property bool isActive: (index + 1) === barContainer.currentDesktop

                            height: 18
                            width: isActive ? 34 : 16
                            radius: 9
                            color: isActive ? "#d0d0d0" : (wsMouse.containsMouse ? "#475569" : "#1e293b")
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

                // Media Player Capsule
                Rectangle {
                    id: mediaPill
                    height: 30
                    radius: 10
                    color: "#1e293b"
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
                            color: playMouse.containsMouse ? "#38bdf8" : "#ffffff"
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

            // --- CENTER GROUP (Clock + Weather) ---
            Row {
                id: centerGroup
                anchors.centerIn: parent
                spacing: 14

                // Stacked Clock
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: -2

                    Text {
                        text: barContainer.currentTime
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.weight: Font.Black
                        color: "#ffffff"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: barContainer.currentDate
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 9
                        font.weight: Font.Bold
                        color: "#94a3b8"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Weather
                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    Text {
                        text: barContainer.weatherIcon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 15
                        color: "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: barContainer.temp
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        font.weight: Font.Black
                        color: "#f8fafc"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // --- RIGHT GROUP ---
            Row {
                id: rightGroup
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // Volume
                Rectangle {
                    id: volBtn
                    width: 32
                    height: 28
                    radius: 8
                    color: volMouse.containsMouse ? "#334155" : "#1e293b"
                    anchors.verticalCenter: parent.verticalCenter
                    scale: volMouse.pressed ? 0.92 : 1.0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: barContainer.volumeIcon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: "#f8fafc"
                    }

                    MouseArea {
                        id: volMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: barContainer.sendCmd("vol_mute")
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
                    color: "#1e293b"
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
                    height: 28
                    radius: 10
                    color: "#f8fafc"
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: netRow.implicitWidth + 20

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
                }

                // Battery (SOLID WHITE CAPSULE)
                Rectangle {
                    id: batPill
                    height: 28
                    radius: 10
                    color: "#f8fafc"
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: batRow.implicitWidth + 20

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
                }

                // Power button
                Rectangle {
                    id: powerBtn
                    width: 28
                    height: 28
                    radius: 14
                    color: powerMouse.containsMouse ? "#ef4444" : "#1e293b"
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
    }
}
