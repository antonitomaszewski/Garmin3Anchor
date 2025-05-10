import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
using Toybox.Lang;

class Garmin3AnchorSettingsView extends WatchUi.Menu2 {
    var chainLength = 10; // Domyślna długość łańcucha (10m)

    function initialize() {
        System.println("Garmin3AnchorSettingsView.initialize");
        Menu2.initialize({
            :id => :settings_view,
            :title => "Ustawienia",
            :background => Graphics.COLOR_BLACK,
            :foreground => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_LARGE
        });
    }

    function getItem(index as Lang.Number) as WatchUi.MenuItem or Null {
        if (index == 0) {
            return new WatchUi.MenuItem(
                "Długość łańcucha" + chainLength + "m", null, :basic, null);
          }
        return null;
    }

    function onSelect(index as Lang.Number) as Void {
        if (index == 0) {
            // Zwiększ długość łańcucha o 10m (cyklicznie w przedziale 0-100m)
            chainLength = (chainLength + 10) % 110;
            requestUpdate(); // Odśwież widok
        }
    }

    function onBack() as Void {
        // Powrót do głównego widoku
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    public function getChainLength() as Lang.Number {
        return chainLength;
    }
    
}