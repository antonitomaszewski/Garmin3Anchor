import Toybox.Lang;
import Toybox.WatchUi;

class Garmin3AnchorDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new Garmin3AnchorMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}