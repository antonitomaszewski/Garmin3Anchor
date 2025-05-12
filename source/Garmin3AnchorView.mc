import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Position;
import Toybox.System;
import Toybox.Application;

class Garmin3AnchorView extends WatchUi.View {

    function initialize() {
        System.println("Garmin3AnchorView.initialize");
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        System.println("Garmin3AnchorView.onLayout");
        setLayout(Rez.Layouts.MainLayout(dc));
    }
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        System.println("Garmin3AnchorView.onShow");
        // Start GPS
    }
    // Update the view
    function onUpdate(dc as Dc) as Void {
        System.println("Garmin3AnchorView.onUpdate");
        dc.clear();
        var app = getApp() as Garmin3AnchorApp;
        // var position = app.getPositionInfo();
        var position = [1,2];
        // Ustal parametry "mapy"
        var mapX = 30;
        var mapY = 30;
        var mapW = dc.getWidth() - 60;
        var mapH = dc.getHeight() - 60;
        // Rysuj "mapę" jako prostokąt
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK); // użyj DK_GRAY zamiast GRAY
        dc.drawRectangle(mapX, mapY, mapW, mapH);
        // Jeśli mamy pozycję, zaznacz ją na mapie
        if (position != null && position.size() == 2 && position[0] != null && position[1] != null) {
            var lat = position[0];
            var lon = position[1];
            System.println("Aktualna pozycja: lat = " + lat + ", lon = " + lon);
            // Przeskaluj współrzędne do prostokąta mapy (przykładowo, środek mapy)
            var markerX = mapX + mapW/2;
            var markerY = mapY + mapH/2;
            // Zaznacz punkt na mapie
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
            dc.fillCircle(markerX, markerY, 8);
            // Opis współrzędnych
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(mapX+5, mapY+5, Graphics.FONT_SMALL, "Lat: " + lat + ", Lon: " + lon, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(mapX+mapW/2, mapY+mapH/2, Graphics.FONT_LARGE, "Czekam na GPS...", Graphics.TEXT_JUSTIFY_CENTER);
            System.println("Czekam na GPS...");
        }
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        System.println("Garmin3AnchorView.onHide");
    }

}
