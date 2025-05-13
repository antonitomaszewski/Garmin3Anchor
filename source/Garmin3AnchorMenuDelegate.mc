import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Position;

class Garmin3AnchorMenuDelegate extends WatchUi.InputDelegate {
    var _view as Garmin3AnchorMenuView;

    function initialize(view) {
        System.println("Garmin3AnchorMenuDelegate.initialize");
        InputDelegate.initialize();
        _view = view;
    }

    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        if (WatchUi.KEY_DOWN == key) {
            _view.incIndex();
        } else if (WatchUi.KEY_UP == key) {
            _view.decIndex();
        } else if (WatchUi.KEY_ENTER == key) {
            _view.action();
        } else if (WatchUi.KEY_START == key) {
            _view.action();
        } else if (key == WatchUi.KEY_ESC) {
            _view.action();
        } else {
            return false;
        }
        WatchUi.requestUpdate();
        return true;
    }
}