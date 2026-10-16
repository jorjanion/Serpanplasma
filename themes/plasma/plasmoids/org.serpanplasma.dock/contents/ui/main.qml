import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.taskmanager as TaskManager
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    Layout.fillWidth: false
    Layout.fillHeight: true
    Layout.preferredWidth: iconRow.implicitWidth + 28
    Layout.preferredHeight: dockHeight
    preferredRepresentation: fullRepresentation

    // Theming & custom styling (live synced with Serpanplasma Daemon)
    property string themeBg: "#0f172a"
    property string themeCard: "#1e293b"
    property string themeAccent: "#38bdf8"
    property string themeFg: "#f8fafc"
    property string themeMuted: "#94a3b8"
    property string themeBorder: "#334155"
    property bool isLightTheme: false

    // Dock configuration
    property int dockHeight: 54
    property int dockOpacity: 90
    property real hoverScale: 1.45
    property bool hoverZoomEnabled: true
    property bool showIndicators: true
    property bool showAllTasks: true
    property string activeScope: "current"

    // Geometry properties
    readonly property int baseIconSize: Math.max(26, Math.min(68, dockHeight - 16))

    // Dynamic wave tracking
    property real dockMouseX: -9999
    property real dockMouseY: -9999
    property bool isDockHovered: false
    property string hoveredTitle: ""
    property real hoveredCenterX: 0

    function fetchStatus() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/status");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    if (d.dock_height !== undefined) root.dockHeight = Math.max(38, Math.min(84, d.dock_height));
                    if (d.dock_opacity !== undefined) root.dockOpacity = Math.max(20, Math.min(100, d.dock_opacity));
                    if (d.hover_scale !== undefined) root.hoverScale = Math.max(1.0, Math.min(1.85, d.hover_scale / 100.0));
                    if (d.cascade_scale !== undefined) root.hoverZoomEnabled = d.cascade_scale;
                    if (d.running_indicators !== undefined) root.showIndicators = d.running_indicators;
                    if (d.show_all_tasks !== undefined) root.showAllTasks = d.show_all_tasks;
                    if (d.active_scope !== undefined) root.activeScope = d.active_scope;

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

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.fetchStatus()
    }

    TaskManager.TasksModel {
        id: tasksModel
        sortMode: TaskManager.TasksModel.SortManual
        groupMode: TaskManager.TasksModel.GroupDisabled
        filterByVirtualDesktop: root.activeScope === "current"
        filterByCurrentVirtualDesktop: root.activeScope === "current"
        filterByScreen: true
        filterByActivity: true
        filterHidden: true
        launcherList: [
            "applications:org.kde.dolphin.desktop",
            "preferred://browser",
            "applications:org.kde.konsole.desktop",
            "applications:discord.desktop",
            "applications:spotify-launcher.desktop",
            "applications:systemsettings.desktop"
        ]

        Component.onCompleted: {
            if (plasmoid.configuration && plasmoid.configuration.launchers && plasmoid.configuration.launchers.length > 0) {
                tasksModel.launcherList = plasmoid.configuration.launchers;
            }
        }
    }

    Item {
        id: dockArea
        anchors.fill: parent

        // Floating Tooltip Badge above the closest hovered icon
        Rectangle {
            id: tooltipBadge
            visible: root.isDockHovered && root.hoveredTitle.length > 0
            x: Math.max(4, Math.min(dockArea.width - width - 4, root.hoveredCenterX - width / 2))
            y: -28
            height: 24
            width: tooltipLabel.implicitWidth + 18
            radius: 6
            color: root.themeCard
            border.color: root.themeBorder
            border.width: 1
            opacity: visible ? 1.0 : 0.0
            z: 9999

            Behavior on opacity { NumberAnimation { duration: 120 } }
            Behavior on x { NumberAnimation { duration: 50; easing.type: Easing.OutQuad } }

            Text {
                id: tooltipLabel
                anchors.centerIn: parent
                text: root.hoveredTitle
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: root.themeFg
            }
        }

        // Continuous macOS wave tracking mouse area
        MouseArea {
            id: dockTrackingMouse
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            onPositionChanged: function(mouse) {
                root.dockMouseX = mouse.x;
                root.dockMouseY = mouse.y;
                root.isDockHovered = true;
            }

            onExited: {
                root.isDockHovered = false;
                root.dockMouseX = -9999;
                root.dockMouseY = -9999;
                root.hoveredTitle = "";
            }
        }

        Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: 8

            // Spotlight Quick Launcher Icon
            Item {
                id: spotlightDockItem
                width: root.baseIconSize
                height: root.baseIconSize
                anchors.verticalCenter: parent.verticalCenter

                property real itemCenterX: mapToItem(dockArea, width / 2, height / 2).x
                property real dist: Math.abs(itemCenterX - root.dockMouseX)
                property real influenceRadius: root.baseIconSize * 2.2
                property real targetScale: {
                    if (!root.isDockHovered || !root.hoverZoomEnabled) return 1.0;
                    if (dist >= influenceRadius) return 1.0;
                    var angle = (dist / influenceRadius) * (Math.PI / 2);
                    return 1.0 + (root.hoverScale - 1.0) * Math.cos(angle);
                }

                transformOrigin: Item.Bottom
                scale: spotPress.pressed ? targetScale * 0.88 : targetScale
                z: Math.round(targetScale * 100)

                Behavior on scale {
                    NumberAnimation { duration: 75; easing.type: Easing.OutQuad }
                }

                onDistChanged: {
                    if (root.isDockHovered && dist < (root.baseIconSize * 0.6)) {
                        root.hoveredTitle = "Spotlight Launcher";
                        root.hoveredCenterX = itemCenterX;
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: Math.round(width / 3.2)
                    color: spotPress.containsMouse ? root.themeAccent : (root.isLightTheme ? "#cbd5e1" : "#1e293b")
                    border.color: root.themeBorder
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󰍉"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: Math.round(parent.width * 0.52)
                        color: spotPress.containsMouse ? (root.isLightTheme ? "#ffffff" : "#0f172a") : root.themeAccent
                    }
                }

                MouseArea {
                    id: spotPress
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        var xhr = new XMLHttpRequest();
                        xhr.open("GET", "http://127.0.0.1:19842/cmd?action=toggle_spotlight");
                        xhr.send();
                    }
                }
            }

            // Divider Separator
            Rectangle {
                width: 1
                height: Math.round(root.baseIconSize * 0.65)
                anchors.verticalCenter: parent.verticalCenter
                color: root.themeBorder
                opacity: 0.6
            }

            // Application and Task Icons
            Repeater {
                id: taskRepeater
                model: tasksModel

                delegate: Item {
                    id: taskDelegate
                    required property var model
                    required property int index

                    width: root.baseIconSize
                    height: root.baseIconSize
                    anchors.verticalCenter: parent.verticalCenter

                    property real itemCenterX: mapToItem(dockArea, width / 2, height / 2).x
                    property real dist: Math.abs(itemCenterX - root.dockMouseX)
                    property real influenceRadius: root.baseIconSize * 2.2
                    property real targetScale: {
                        if (!root.isDockHovered || !root.hoverZoomEnabled) return 1.0;
                        if (dist >= influenceRadius) return 1.0;
                        var angle = (dist / influenceRadius) * (Math.PI / 2);
                        return 1.0 + (root.hoverScale - 1.0) * Math.cos(angle);
                    }

                    transformOrigin: Item.Bottom
                    scale: delegateMouse.pressed ? targetScale * 0.88 : targetScale
                    z: Math.round(targetScale * 100)

                    Behavior on scale {
                        NumberAnimation { duration: 75; easing.type: Easing.OutQuad }
                    }

                    onDistChanged: {
                        if (root.isDockHovered && dist < (root.baseIconSize * 0.6)) {
                            var name = model.display || model.AppName || "";
                            root.hoveredTitle = name;
                            root.hoveredCenterX = itemCenterX;
                        }
                    }

                    Kirigami.Icon {
                        anchors.fill: parent
                        source: model.decoration || model.icon || "application-x-executable"
                        smooth: true
                    }

                    // Running / Active dot indicator
                    Rectangle {
                        id: runDot
                        visible: root.showIndicators && (!model.IsLauncher || model.IsActive)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -5
                        width: model.IsActive ? 12 : 4
                        height: 3
                        radius: 1.5
                        color: model.IsActive ? root.themeAccent : root.themeMuted

                        Behavior on width { NumberAnimation { duration: 150 } }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    MouseArea {
                        id: delegateMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: false
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: function(mouse) {
                            if (mouse.button === Qt.LeftButton) {
                                tasksModel.requestActivate(tasksModel.index(index, 0));
                            } else if (mouse.button === Qt.RightButton) {
                                tasksModel.requestNewInstance(tasksModel.index(index, 0));
                            }
                        }
                    }
                }
            }
        }
    }
}
