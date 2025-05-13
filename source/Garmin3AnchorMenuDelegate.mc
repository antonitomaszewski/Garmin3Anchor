import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Position;

class Garmin3AnchorMenuDelegate extends WatchUi.Menu2InputDelegate {
    var _view;

    function initialize(view) {
        System.println("Garmin3AnchorMenuDelegate.initialize");
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onMenuItem(index as Number) as Boolean {
        System.println("Garmin3AnchorMenuDelegate.onMenuItem: " + index);

        if (index == 0) { // Set Anchor Position
            var app = getApp();
            var posInfo = Position.getInfo();
            if (posInfo != null && posInfo.position != null) {
                app.setAnchorPosition(posInfo);
                System.println("Pozycja kotwicy ustawiona!");
            } else {
                System.println("Brak pozycji GPS!");
            }
            return true;
        } else if (index == 1) { // Set Anchor Chain Length
            var app = getApp();
            WatchUi.pushView(app.getChainView(), app.getChainDelegate(), WatchUi.SLIDE_LEFT);
            return true;
        }
        return false;
    }

    function onBack() as Void {
        System.println("Garmin3AnchorMenuDelegate.onBack");
        // Przejście do widoku mapy (do zaimplementowania)
        var app = getApp();
        WatchUi.pushView(app.getMapView(), null, WatchUi.SLIDE_LEFT);
    }

}