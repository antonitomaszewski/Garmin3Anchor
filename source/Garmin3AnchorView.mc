import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Position;
import Toybox.System;

class Garmin3AnchorView extends WatchUi.View {
    var positionInfo;

    function initialize() {
        System.println("Garmin3AnchorView.initialize");
        View.initialize();
    }

    //! Handle app startup and enable location events to make sure GPS is on
    //! @param state Startup arguments
    public function onStart(state) as Void {
        System.println("Garmin3AnchorView.onStart");
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        System.print(1);
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

    public function onPosition(info as Position.Info) as Void {
        System.println("Garmin3AnchorView.onPosition");
        var myLocation = info.position.toDegrees();
        positionInfo = myLocation;
        System.println("Position Info: " + positionInfo);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        System.println("Garmin3AnchorView.onUpdate");
        // Call the parent onUpdate function to redraw the layout
    // Wyczyszczenie ekranu
        dc.clear();

        // Sprawdzenie, czy mamy dane GPS
        if (positionInfo != null) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            dc.fillRectangle(100, 100, 100, 100);
            var lat = positionInfo.toDegrees()[0];
            var lon = positionInfo.toDegrees()[1];
            System.println("Aktualna pozycja: lat = " + lat + ", lon = " + lon);
            // Wyświetlenie współrzędnych GPS
            // dc.drawText("Lat: " + lat, Graphics.FONT_LARGE, 10, 50, Graphics.TEXT_JUSTIFY_LEFT);
            // dc.drawText("Lon: " + lon, Graphics.FONT_LARGE, 10, 100, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
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
