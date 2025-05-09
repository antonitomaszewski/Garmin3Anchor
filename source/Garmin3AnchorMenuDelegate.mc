import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class Garmin3AnchorMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        System.println("Garmin3AnchorMenuDelegate.initialize");
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        System.println("Garmin3AnchorMenuDelegate.onMenuItem");
        if (item == :item_1) {
            System.println("item 1");
        } else if (item == :item_2) {
            System.println("item 2");
        }
    }

}