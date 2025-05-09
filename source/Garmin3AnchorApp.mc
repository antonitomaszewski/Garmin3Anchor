import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class Garmin3AnchorApp extends Application.AppBase {

    function initialize() {
        System.println("Garmin3AnchorApp.initialize");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("Garmin3AnchorApp.onStart");
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

}

function getApp() as Garmin3AnchorApp {
    System.println("Garmin3AnchorApp.getApp");
    return Application.getApp() as Garmin3AnchorApp;
}