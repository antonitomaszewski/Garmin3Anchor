import Toybox.Lang;
import Toybox.WatchUi;

class Garmin3AnchorDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        System.println("Garmin3AnchorDelegate.initialize");
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        System.println("Garmin3AnchorDelegate.onMenu");
        WatchUi.pushView(new Rez.Menus.MainMenu(), new Garmin3AnchorMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}