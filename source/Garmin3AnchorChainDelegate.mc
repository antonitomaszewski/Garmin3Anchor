import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;
import Toybox.Application;

class Garmin3AnchorChainDelegate extends WatchUi.InputDelegate {
    private var _view as Garmin3AnchorChainView;

    function initialize(view) {
        InputDelegate.initialize();
        _view = view;
    }

    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        System.println("AnchorChainDelegate.onKey: " + key);
        if (key == WatchUi.KEY_UP) {
            _view.incrementDigit();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.decrementDigit();
            return true;
        } else if (key == WatchUi.KEY_ENTER) {
            _view.nextDigitOrAccept();
            return true;
        } else if (key == WatchUi.KEY_ESC) {
            _view.escape();
            return true;
        } 
        WatchUi.requestUpdate();
        return false;
    }
}