// Serpanplasma Top Floating Bar Layout Script for KDE Plasma 6
// Replicates the Serpantinum floating bar aesthetic with pills layout

// 1. Remove existing panels
var existingPanels = panels();
for (var i = 0; i < existingPanels.length; ++i) {
    existingPanels[i].remove();
}

// 2. Create the floating top bar
var panel = new Panel;
panel.location = "top";
panel.height = 42;
panel.floating = true;
panel.lengthMode = "fill";

// --- Left Group (Launcher + Media Player) ---
var launcher = panel.addWidget("org.kde.plasma.kickoff");
launcher.currentConfigGroup = ["General"];
launcher.writeConfig("icon", "serpanplasma-launcher");
launcher.writeConfig("favoritesPortedToKAstats", true);

var media = panel.addWidget("org.kde.plasma.mediacontroller");

// --- Center Spacer (Pushes Clock to Center) ---
var spacerLeft = panel.addWidget("org.kde.plasma.panelspacer");
spacerLeft.currentConfigGroup = ["General"];
spacerLeft.writeConfig("expanding", true);

// --- Center Group (Digital Clock with Full Date in Spanish & JetBrains Mono) ---
var clock = panel.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("dateFormat", "custom");
clock.writeConfig("customDateFormat", "dddd, d 'de' MMMM");
clock.writeConfig("showDate", "true");
clock.writeConfig("dateDisplayFormat", "BesideTime");
clock.writeConfig("fontFamily", "JetBrainsMono Nerd Font");
clock.writeConfig("fontStyleName", "SemiBold");
clock.writeConfig("fontWeight", 600);
clock.writeConfig("showSeconds", "Never");

// --- Right Spacer (Maintains Clock Center) ---
var spacerRight = panel.addWidget("org.kde.plasma.panelspacer");
spacerRight.currentConfigGroup = ["General"];
spacerRight.writeConfig("expanding", true);

// --- Right Group (Weather + Status Pills + System Tray) ---
var weather = panel.addWidget("org.kde.plasma.weather");

var volume = panel.addWidget("org.kde.plasma.volume");
var network = panel.addWidget("org.kde.plasma.networkmanagement");
var battery = panel.addWidget("org.kde.plasma.battery");

var tray = panel.addWidget("org.kde.plasma.systemtray");
tray.currentConfigGroup = ["General"];
tray.writeConfig("shownItems", [
    "org.kde.plasma.notifications",
    "org.kde.plasma.clipboard"
]);
tray.writeConfig("hiddenItems", [
    "org.kde.plasma.volume",
    "org.kde.plasma.networkmanagement",
    "org.kde.plasma.battery"
]);
