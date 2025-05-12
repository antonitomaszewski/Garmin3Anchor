import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class Garmin3AnchorMapView extends WatchUi.MapView {
    function initialize() {
        MapView.initialize();
        System.println("Garmin3AnchorMapView.initialize");
    }

    function onShow() as Void {
        System.println("Garmin3AnchorMapView.onShow");
        // Ustaw pozycję mapy na positionInfo
        var app = getApp() as Garmin3AnchorApp;
        // var position = app.getPositionInfo();
        // if (position != null && position.size() == 2) {

            // setMapLocation(position[0], position[1]);
            // setMapZoom(16); // przykładowy zoom
            // clearMapMarkers();
            // addMapMarker(position[0], position[1]);
        // }
    }
}