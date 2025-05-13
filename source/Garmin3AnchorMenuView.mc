import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class Garmin3AnchorMenuView extends WatchUi.Menu2 {
    
    function initialize() {
        System.println("Garmin3AnchorMenuView.initialize");
        Menu2.initialize({
            :title => "Anchor Menu",
        });
    }

    function getItemCount() as Number {
        return 2;
    }

    function getItem(index as Number) as WatchUi.MenuItem or Null {
        System.println("Garmin3AnchorMenuView.getItem: " + index);
        if (index == 0) {
            return new WatchUi.MenuItem("Set Anchor Position", null, :basic, null);
        } else if (index == 1) {
            return new WatchUi.MenuItem("Set Anchor Chain Length", null, :basic, null);
        }
        System.println("BŁĄD: Nieobsługiwany index w getItem: " + index);
        return new WatchUi.MenuItem("Błąd menu", null, :basic, null);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Powrót do poprzedniego widoku
    }
}