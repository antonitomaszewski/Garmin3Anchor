import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Position;

class Garmin3AnchorApp extends Application.AppBase {
    var positionInfo;

    function initialize() {
        System.println("Garmin3AnchorApp.initialize");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("Garmin3AnchorApp.onStart");
        System.println("Włączanie GPS...");
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        System.println("GPS włączony.");
    }

    function onPosition(info as Position.Info) as Void {
        System.println("Garmin3AnchorView.onPosition");
        var myLocation = info.position.toDegrees();
        positionInfo = myLocation;
        System.println("Position Info: " + positionInfo);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        System.println("Garmin3AnchorApp.onStop");
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        System.println("Garmin3AnchorApp.getInitialView");
        return [ new Garmin3AnchorView(), new Garmin3AnchorDelegate() ];
    }

    public function getPositionInfo() as Array? {
        System.println("Garmin3AnchorApp.getPositionInfo");
        return positionInfo; // Zwraca aktualną pozycję GPS
    }

}

function getApp() as Garmin3AnchorApp {
    System.println("Garmin3AnchorApp.getApp");
    return Application.getApp() as Garmin3AnchorApp;
}