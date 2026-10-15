// Serpanplasma Wallpaper Slideshow Setup for Plasma 6
var d = desktops();
var wallpaperDir = userDataPath("pictures") + "/Wallpapers";

for (var i = 0; i < d.length; ++i) {
    d[i].wallpaperPlugin = "org.kde.slideshow";
    d[i].currentConfigGroup = ["Wallpaper", "org.kde.slideshow", "General"];
    d[i].writeConfig("SlidePaths", [wallpaperDir]);
    d[i].writeConfig("SlideInterval", 900); // 15 minutes rotation
}
