// Serpanplasma Layout Script for KDE Plasma 6
// Replicates the Serpantinum floating bar (pills) and floating application dock

// 1. Remove all existing panels to prevent duplicates
var existingPanels = panels();
for (var i = 0; i < existingPanels.length; ++i) {
    existingPanels[i].remove();
}

// 2. Remove any accidental applets on the desktop
var ds = desktops();
for (var i = 0; i < ds.length; ++i) {
    var ws = ds[i].widgets();
    for (var j = 0; j < ws.length; ++j) {
        if (ws[j].type === "org.kde.plasma.digitalclock") {
            ws[j].remove();
        }
    }
}

// 3. Create the Top Floating Bar (Exact Serpantinum Pills Layout)
var topBar = new Panel;
topBar.location = "top";
topBar.height = 38;
topBar.floating = true;
topBar.lengthMode = "fill";
var barApplet = topBar.addWidget("org.serpanplasma.bar");

// 4. Create the Bottom Floating Application Dock
var dock = new Panel;
dock.location = "bottom";
dock.height = 54;
dock.floating = true;
dock.alignment = "center";
dock.lengthMode = "fit";

var tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:kitty.desktop",
    "applications:org.kde.dolphin.desktop",
    "preferred://browser",
    "applications:discord.desktop",
    "applications:spotify.desktop",
    "applications:systemsettings.desktop"
]);
tasks.writeConfig("fill", false);
tasks.writeConfig("maxStripes", 1);
