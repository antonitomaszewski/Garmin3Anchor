import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class Garmin3AnchorChainView extends WatchUi.View {
    private var _digits = [0,0,0] as Array<Lang.Number>;
    private var _selected = 0 as Lang.Number;

    function incrementDigit() { _digits[_selected] = (_digits[_selected]+1)%10; WatchUi.requestUpdate(); }
    function decrementDigit() { _digits[_selected] = (_digits[_selected]+9)%10; WatchUi.requestUpdate(); }
    function nextDigitOrAccept() {
        if (_selected < 2) { _selected += 1; }
        else { /* zatwierdź */ WatchUi.popView(WatchUi.SLIDE_UP); }
        WatchUi.requestUpdate();
    }

    public function initialize() {
        View.initialize();
        // WatchUi.setBackgroundColor(Graphics.COLOR_BLACK);
        // WatchUi.setColor(Graphics.COLOR_WHITE);
        // WatchUi.setFont(Graphics.FONT_LARGE);
    }

    public function onUpdate(dc as Dc) as Void {

        // Set background color
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var x = dc.getWidth() / 2 as Number;
        var y = dc.getHeight() / 2 as Number;

        var font = Graphics.FONT_SMALL;
        var textHeight = dc.getFontHeight(font);

        y -= textHeight / 2;
        var display = "" as String;
        for (var i = 0; i < 3; ++i) {
            if (i == _selected) {
                display += "[" + _digits[i].toString() + "]";
            } else {
                display += " " + _digits[i].toString() + " ";
            }
        }
        dc.drawText(x, y, Graphics.FONT_SMALL, display, Graphics.TEXT_JUSTIFY_CENTER);
    }
}