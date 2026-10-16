import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami 2.20 as Kirigami

Window {
    id: root
    width: 680
    height: 520
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Dialog
    visible: true

    // Centered window placement
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }

    // Dynamic reactive theme properties
    property string themeBg: "#0f172a"
    property string themeCard: "#1e293b"
    property string themeAccent: "#38bdf8"
    property string themeFg: "#f8fafc"
    property string themeMuted: "#94a3b8"
    property string themeBorder: "#334155"
    property bool isLightTheme: false

    property var allApps: []
    property var searchResults: []
    property int selectedIndex: 0
    property string calcResult: ""
    property bool isCalc: false
    property bool isCmd: false

    readonly property bool hasQuery: searchField.text.trim().length > 0
    readonly property bool noMatches: hasQuery && !isCalc && !isCmd && searchResults.length === 0

    readonly property int headerHeight: 64
    readonly property int footerHeight: 36
    readonly property int itemHeight: 56

    readonly property int targetHeight: {
        if (!hasQuery) {
            return headerHeight;
        }
        if (isCalc || isCmd) {
            return headerHeight + 1 + 60 + footerHeight;
        }
        if (searchResults.length === 0) {
            return headerHeight + 1 + 56 + footerHeight;
        }
        var visibleRows = Math.min(6, searchResults.length);
        return headerHeight + 1 + (visibleRows * itemHeight) + footerHeight;
    }

    function sendCmdAndQuit(action, val) {
        root.visible = false;
        var url = "http://127.0.0.1:19842/cmd?action=" + action;
        if (val !== undefined && val !== "") {
            url += "&val=" + encodeURIComponent(val);
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        var quitFired = false;
        function doQuit() {
            if (!quitFired) {
                quitFired = true;
                Qt.quit();
            }
        }
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                doQuit();
            }
        };
        xhr.send();
        // Safety timeout so launcher process never hangs
        var timer = Qt.createQmlObject('import QtQuick; Timer { interval: 150; running: true; repeat: false; }', root);
        timer.triggered.connect(doQuit);
    }

    function fetchApps() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/apps");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    root.allApps = JSON.parse(xhr.responseText);
                    root.updateSearch();
                } catch(e) {}
            }
        };
        xhr.send();
    }

    function fetchStatus() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://127.0.0.1:19842/status");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
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

    function evalMath(expr) {
        try {
            var sanitized = expr.replace(/[^0-9+\-*/().,%^ ]/g, '');
            if (sanitized.length < 2) return "";
            sanitized = sanitized.replace(/\^/g, '**');
            var res = Function('"use strict"; return (' + sanitized + ')')();
            if (res !== undefined && !isNaN(res) && isFinite(res)) {
                return String(res);
            }
        } catch(e) {}
        return "";
    }

    function updateSearch() {
        var q = searchField.text.trim();
        root.selectedIndex = 0;
        root.isCalc = false;
        root.isCmd = false;
        root.calcResult = "";

        if (q === "") {
            root.searchResults = [];
            return;
        }

        if (q.startsWith(">")) {
            root.isCmd = true;
            root.searchResults = [];
            return;
        }

        // Math evaluation
        if (/^[0-9+\-*/().,%^ ]+$/.test(q) && q.length >= 2 && /[+\-*/^%]/.test(q)) {
            var mathVal = evalMath(q);
            if (mathVal !== "") {
                root.isCalc = true;
                root.calcResult = mathVal;
            }
        }

        var qLower = q.toLowerCase();
        var matches = [];
        for (var j = 0; j < root.allApps.length; j++) {
            var app = root.allApps[j];
            var nameMatch = app.name.toLowerCase().indexOf(qLower);
            var commentMatch = (app.comment || "").toLowerCase().indexOf(qLower);
            var execMatch = (app.exec || "").toLowerCase().indexOf(qLower);
            if (nameMatch === 0) {
                matches.unshift(app);
            } else if (nameMatch > 0 || commentMatch !== -1 || execMatch !== -1) {
                matches.push(app);
            }
        }
        root.searchResults = matches.slice(0, 15);
    }

    function executeSelected() {
        if (root.isCmd) {
            var cmd = searchField.text.substring(1).trim();
            if (cmd) {
                root.sendCmdAndQuit("launch_app", "kitty -e " + cmd + " || konsole -e " + cmd + " || alacritty -e " + cmd + " || " + cmd);
            } else {
                Qt.quit();
            }
            return;
        }

        if (root.isCalc) {
            root.sendCmdAndQuit("launch_app", "wl-copy " + root.calcResult + " 2>/dev/null || xclip -selection c <<< " + root.calcResult);
            return;
        }

        if (root.noMatches) {
            var query = searchField.text.trim();
            root.sendCmdAndQuit("open_url", "https://www.google.com/search?q=" + encodeURIComponent(query));
            return;
        }

        if (root.searchResults.length > 0 && root.selectedIndex < root.searchResults.length) {
            var selectedApp = root.searchResults[root.selectedIndex];
            var target = selectedApp.desktopPath || selectedApp.id || selectedApp.exec;
            root.sendCmdAndQuit("launch_app", target);
        }
    }

    Component.onCompleted: {
        fetchStatus();
        fetchApps();
        searchField.forceActiveFocus();
    }

    property bool hasBeenActive: false
    onActiveChanged: {
        if (active) {
            hasBeenActive = true;
            searchField.forceActiveFocus();
        } else if (hasBeenActive) {
            Qt.quit();
        }
    }

    // Dismiss on clicking transparent background outside the card
    MouseArea {
        anchors.fill: parent
        onClicked: Qt.quit()
    }

    // Main Spotlight Container Card (animates upward smoothly as results expand)
    Rectangle {
        id: mainCard
        width: parent.width
        height: root.targetHeight
        anchors.horizontalCenter: parent.horizontalCenter
        y: Math.round((parent.height - height) / 2)

        Behavior on y {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }
        Behavior on height {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        radius: 18
        color: root.themeBg
        opacity: 0.98
        border.color: root.themeAccent
        border.width: 1.5
        clip: true

        // Absorb clicks on the card itself so they don't dismiss the window
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // 1. SEARCH BAR HEADER
            Rectangle {
                Layout.fillWidth: true
                height: root.headerHeight
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 14

                    // Search Icon
                    Text {
                        text: "󰍉"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 22
                        color: root.themeAccent
                    }

                    // Input Field
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                        color: root.themeFg
                        placeholderText: "Buscar aplicaciones, comandos (>), cálculos..."
                        placeholderTextColor: root.themeMuted
                        background: null
                        focus: true
                        selectByMouse: true

                        onTextChanged: root.updateSearch()

                        Keys.onDownPressed: {
                            if (root.searchResults.length > 0) {
                                root.selectedIndex = Math.min(root.searchResults.length - 1, root.selectedIndex + 1);
                                resultList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                        }

                        Keys.onUpPressed: {
                            if (root.searchResults.length > 0) {
                                root.selectedIndex = Math.max(0, root.selectedIndex - 1);
                                resultList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                        }

                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Super_L || event.key === Qt.Key_Super_R || event.key === Qt.Key_Meta) {
                                event.accepted = true;
                                Qt.quit();
                            }
                        }

                        Keys.onReturnPressed: root.executeSelected()
                        Keys.onEnterPressed: root.executeSelected()
                        Keys.onEscapePressed: Qt.quit()
                    }

                    // Clear button
                    Rectangle {
                        visible: searchField.text.length > 0
                        width: 26
                        height: 26
                        radius: 13
                        color: clearMouse.containsMouse ? root.themeBorder : root.themeCard
                        Text {
                            anchors.centerIn: parent
                            text: "󰅖"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            color: root.themeMuted
                        }
                        MouseArea {
                            id: clearMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                searchField.text = "";
                                searchField.forceActiveFocus();
                            }
                        }
                    }

                    // ESC Badge
                    Rectangle {
                        width: 42
                        height: 24
                        radius: 6
                        color: root.themeCard
                        border.color: root.themeBorder
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "ESC"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 9
                            font.weight: Font.Bold
                            color: root.themeMuted
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.quit()
                        }
                    }
                }
            }

            // Separator divider (only visible when there is active content below)
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: root.themeBorder
                visible: root.hasQuery
            }

            // 2. SPECIAL RESULT: CALCULATOR
            Rectangle {
                Layout.fillWidth: true
                height: 60
                visible: root.isCalc
                color: root.themeCard
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 14
                    Text { text: "󰪚"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 22; color: "#34d399" }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "Resultado de cálculo"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeMuted }
                        Text { text: root.calcResult; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 18; font.weight: Font.Black; color: root.themeFg }
                    }
                    Text { text: "↵ Copiar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeAccent }
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: root.executeSelected()
                }
            }

            // 3. SPECIAL RESULT: TERMINAL COMMAND (>)
            Rectangle {
                Layout.fillWidth: true
                height: 60
                visible: root.isCmd
                color: root.themeCard
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 14
                    Text { text: "󰆍"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 22; color: root.themeAccent }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "Ejecutar comando en terminal"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeMuted }
                        Text { text: searchField.text.substring(1).trim(); font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14; font.weight: Font.Bold; color: root.themeFg; elide: Text.ElideRight }
                    }
                    Text { text: "↵ Ejecutar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeAccent }
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: root.executeSelected()
                }
            }

            // 4. SPECIAL RESULT: NO MATCHES FOUND
            Rectangle {
                Layout.fillWidth: true
                height: 56
                visible: root.noMatches
                color: "transparent"
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 14
                    Text { text: "󰍉"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 20; color: root.themeMuted }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "Sin resultados para \"" + searchField.text.trim() + "\""; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12; font.weight: Font.Bold; color: root.themeFg; elide: Text.ElideRight }
                        Text { text: "↵ Presiona Enter para buscar en la web"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeAccent }
                    }
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: root.executeSelected()
                }
            }

            // 5. RESULTS LIST VIEW
            ListView {
                id: resultList
                visible: !root.isCalc && !root.isCmd && root.searchResults.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(6, root.searchResults.length) * root.itemHeight
                clip: true
                model: root.searchResults
                currentIndex: root.selectedIndex
                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    id: itemDelegate
                    width: resultList.width
                    height: root.itemHeight
                    color: (root.selectedIndex === index) ? root.themeCard : (itemMouse.containsMouse ? (root.isLightTheme ? "#e2e8f0" : "#1e293b") : "transparent")
                    border.color: (root.selectedIndex === index) ? root.themeAccent : "transparent"
                    border.width: (root.selectedIndex === index) ? 1 : 0
                    radius: 10

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 18
                        spacing: 14

                        // App Icon
                        Kirigami.Icon {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            source: modelData.icon || "application-x-executable"
                        }

                        // App Name & Details
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: modelData.name
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 13
                                font.weight: (root.selectedIndex === index) ? Font.Black : Font.Bold
                                color: (root.selectedIndex === index) ? root.themeAccent : root.themeFg
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: modelData.comment || modelData.exec || "Aplicación de escritorio"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 10
                                color: root.themeMuted
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        // Return hint
                        Text {
                            visible: root.selectedIndex === index
                            text: "󰌑"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: root.themeAccent
                        }
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selectedIndex = index
                        onClicked: {
                            root.selectedIndex = index;
                            root.executeSelected();
                        }
                    }
                }
            }

            // 6. FOOTER SHORTCUT LEGEND
            Rectangle {
                Layout.fillWidth: true
                height: root.footerHeight
                color: root.isLightTheme ? "#f1f5f9" : "#090d16"
                visible: root.hasQuery

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 18

                    RowLayout {
                        spacing: 4
                        Text { text: "󰁝󰁅"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; color: root.themeAccent }
                        Text { text: "Seleccionar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeMuted }
                    }
                    Text { text: "•"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 8; color: root.themeBorder }
                    RowLayout {
                        spacing: 4
                        Text { text: "↵"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 11; font.weight: Font.Bold; color: root.themeAccent }
                        Text { text: "Abrir"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeMuted }
                    }
                    Text { text: "•"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 8; color: root.themeBorder }
                    RowLayout {
                        spacing: 4
                        Text { text: "esc"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; font.weight: Font.Bold; color: root.themeAccent }
                        Text { text: "Cerrar"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 10; color: root.themeMuted }
                    }
                }
            }
        }
    }
}
