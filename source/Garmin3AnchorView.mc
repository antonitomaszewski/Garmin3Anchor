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
        // Call the parent onUpdate function to redraw the layout
    // Wyczyszczenie ekranu
        dc.clear();
        var app = getApp() as Garmin3AnchorApp;
        var position = app.getPositionInfo();
        // var komunikat = findDrawableById(:id_komunikat) as WatchUi.Text;
        

        // Sprawdzenie, czy mamy dane GPS
        if (position != null) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            dc.fillRectangle(100, 100, 100, 100);
            var lat = position[0];
            var lon = position[1];
            System.println("Aktualna pozycja: lat = " + lat + ", lon = " + lon);
            // Wyświetlenie współrzędnych GPS
            // dc.drawText("Lat: " + lat, Graphics.FONT_LARGE, 10, 50, Graphics.TEXT_JUSTIFY_LEFT);
            // dc.drawText("Lon: " + lon, Graphics.FONT_LARGE, 10, 100, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_LARGE, "Czekam na GPS...", Graphics.TEXT_JUSTIFY_LEFT);
            // komunikat.setText("Czekam na GPS...");
            System.println("Czekam na GPS...");
            // Wyświetlenie komunikatu, jeśli GPS jeszcze nie jest gotowy
            // dc.drawText("Czekam na GPS...", Graphics.FONT_LARGE, 10, 50, Graphics.TEXT_JUSTIFY_LEFT);
        }

        // Wywołanie metody nadrzędnej
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        System.println("Garmin3AnchorView.onHide");
    }

}
