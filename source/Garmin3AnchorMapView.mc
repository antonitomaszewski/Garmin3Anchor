import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Attention;
import Toybox.Position;
import Toybox.Lang;
import Toybox.Math;

class Garmin3AnchorMapView extends WatchUi.MapView {
    // w setIcon ustawiamy współrzędne w pikselach, które mamy ustawić dokładnie na lokalizacji
    // w setSize ustawiamy wielkość, ale tej metody nie ma na MapMarker
    private var anchorIcon = WatchUi.loadResource($.Rez.Drawables.Anchor) as BitmapResource;
    private var boatIcon = WatchUi.loadResource($.Rez.Drawables.Boat) as BitmapResource;
    private var greenDotIcon = WatchUi.loadResource($.Rez.Drawables.GreenDot) as BitmapResource;
    private var redDotIcon = WatchUi.loadResource($.Rez.Drawables.RedDot) as BitmapResource;
    private var anchorIconSize = 12;
    private var greenDotSize = 4;
    public function initialize() {
        System.println("Garmin3AnchorMapView.initialize");
        MapView.initialize();
        setDefaultMapSettings();
    }

    public function setDefaultMapSettings() as Void {
        System.println("Garmin3AnchorMapView.setDefaultMapSettings");
        MapView.setMapMode(WatchUi.MAP_MODE_PREVIEW);
        var app = getApp();
        var anchor = app.getAnchorPosition();
        var chainLength = app.getAnchorChainLength();
        var ZoomIN = 2;

        if (anchor != null and chainLength != null) {
            // Oblicz przesunięcie w stopniach dla podanej odległości (przybliżenie)
            var earthRadius = 6371000.0; // metry
            var dLat = (ZoomIN * chainLength / earthRadius) * 180.0 / Math.PI;
            var dLon = (ZoomIN * chainLength / (earthRadius * Math.cos(anchor.toDegrees()[0] * Math.PI / 180.0))) * 180.0 / Math.PI;


            // Lewy górny róg (NW)
            var topLeft = new Position.Location({
                :latitude => anchor.toDegrees()[0] + dLat,
                :longitude => anchor.toDegrees()[1] - dLon,
                :format => :degrees
            });
            System.println(topLeft.toString());

            // Prawy dolny róg (SE)
            var bottomRight = new Position.Location({
                :latitude => anchor.toDegrees()[0] - dLat,
                :longitude => anchor.toDegrees()[1] + dLon,
                :format => :degrees            
            });
            System.println("Coś chyba ustawiłem");

            // Ustaw widoczny obszar mapy
            MapView.setMapVisibleArea(topLeft, bottomRight);

            // Ustaw widoczny obszar ekranu (cały ekran)
            MapView.setScreenVisibleArea(0, 0, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight);
        } else {
            var top_left = new Position.Location({:latitude => 51.115, :longitude =>17.04, :format => :degrees});
            var bottom_right = new Position.Location({:latitude => 51.110, :longitude =>17.06, :format => :degrees});
            MapView.setMapVisibleArea(top_left, bottom_right);
            MapView.setScreenVisibleArea(0, 0, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight / 2);
        }
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        // setScreenVisibleArea(0, 0, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight);
        // setDefaultMapSettings();
    }

    public function distance(pos1 as Position.Location or Null, pos2 as Position.Location or Null) as Number or Double or Float {
        if (pos1 == null || pos2 == null) {
            return 0;
        }
        var R = 6371000.0; // promień Ziemi w metrach
        var lat1 = pos1.toRadians()[0];
        var lon1 = pos1.toRadians()[1];
        var lat2 = pos2.toRadians()[0];
        var lon2 = pos2.toRadians()[1];
        var dlat = lat2 - lat1;
        var dlon = lon2 - lon1;
        var a = Math.pow(Math.sin(dlat/2),2) + Math.cos(lat1)*Math.cos(lat2)*Math.pow(Math.sin(dlon/2),2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    public function onUpdate(dc as Dc) as Void {
        System.println("Garmin3AnchorMapView.onUpdate");
        MapView.onUpdate(dc);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        
        var app = getApp();
        var anchor = app.getAnchorPosition();
        var sailboatPositions = app.getSailboatPositions();
        if (anchor != null) {
            var mapMarkers = [];
            var anchorPositionMapMarker = new WatchUi.MapMarker(anchor);
            anchorPositionMapMarker.setIcon(anchorIcon, anchorIconSize, anchorIconSize);
            anchorPositionMapMarker.setLabel("Anchor");
            // anchorPositionMapMarker.setSize("Anchor");
            mapMarkers.add(anchorPositionMapMarker);

            for (var i = 0; i < sailboatPositions.size() - 1; ++i) {
                var pos = sailboatPositions[i];
                var marker = new WatchUi.MapMarker(pos);
                marker.setIcon(greenDotIcon, greenDotSize, greenDotSize);
                // marker.setLabel("Boat " + (i + 1));
                mapMarkers.add(marker);
            }
            if (sailboatPositions.size() > 0) {
                var currentPosition = sailboatPositions[sailboatPositions.size() - 1];
                var marker = new WatchUi.MapMarker(currentPosition);
                marker.setIcon(boatIcon, greenDotSize, greenDotSize);
                // marker.setLabel("Current Position");
                mapMarkers.add(marker);
            }
            MapView.setMapMarker(mapMarkers);
        }
    }

    // public function onUpdate(dc as Dc) as Void {
    //     System.println("Garmin3AnchorMapView.onUpdate");
    //     dc.clear();

    //     var app = getApp();
    //     var anchor = app.getAnchorPosition();
    //     var chainLength = app.getAnchorChainLength();
    //     var positions = app.getSailboatPositions();


    //     if (anchor == null or chainLength == null or positions == null or positions.size() == 0) {
    //         dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    //         dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_LARGE, "Brak danych", Graphics.TEXT_JUSTIFY_CENTER);
    //         return;
    //     }

    //     // Ustal parametry "mapy"
    //     var mapX = 30;
    //     var mapY = 30;
    //     var mapW = dc.getWidth() - 60;
    //     var mapH = dc.getHeight() - 60;

    //     // Rysuj tło mapy
    //     dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
    //     dc.drawRectangle(mapX, mapY, mapW, mapH);

    //     // Jeśli anchorPosition jest ustawiony
    //     if (anchor != null) {
    //         // Wyznacz środek mapy
    //         var centerX = mapX + mapW/2;
    //         var centerY = mapY + mapH/2;

    //         // Rysuj okrąg alarmowy (jeśli anchorChainLength ustawiony)
    //         if (chainLength != null) {
    //             var scale = 1.0; // Możesz dobrać skalę do rozmiaru mapy
    //             var radius = chainLength * scale;
    //             dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    //             dc.drawCircle(centerX, centerY, radius);
    //         }

    //         // Zaznacz anchorPosition (czarny X)
    //         dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    //         dc.drawText(centerX, centerY, Graphics.FONT_LARGE, "X", Graphics.TEXT_JUSTIFY_CENTER);

    //         // Rysuj pozycje łodzi (zielone kółka)
    //         if (positions != null && positions.size() > 0) {
    //             for (var i = 0; i < positions.size(); ++i) {
    //                 var pos = positions[i];
    //                 // Przeskaluj pozycję względem anchorPosition (tu uproszczenie: wszystkie na środku)
    //                 // W praktyce musisz przeliczyć różnicę współrzędnych na piksele!
    //                 var px = pos.toDegrees()[0] * 10 + centerX; // Przykładowe przeliczenie
    //                 var py = pos.toDegrees()[1] * 10 + centerY; // Przykładowe przeliczenie
    //                 dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    //                 dc.fillCircle(px, py, 6);
    //             }
    //         }

    //         // Sprawdź dystans do ostatniej pozycji i włącz wibrację jeśli poza zasięgiem
    //         if (positions != null && positions.size() > 0 && chainLength != null) {
    //             var lastPos = positions[positions.size()-1];
    //             var dist = distance(anchor, lastPos); // w metrach
    //             if (dist > chainLength) {
    //                 Attention.vibrate([new Attention.VibeProfile(25, 100)]);
    //             }
    //         }
    //     } else {
    //         // Brak pozycji kotwicy
    //         dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    //         dc.drawText(mapX+mapW/2, mapY+mapH/2, Graphics.FONT_LARGE, "Ustaw kotwicę", Graphics.TEXT_JUSTIFY_CENTER);
    //     }
    // }
}