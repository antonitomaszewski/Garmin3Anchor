import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class Garmin3AnchorMenuView extends WatchUi.View {
    private var _selectedIndex as Number = 0;

    private var _menuLayout as Array<Drawable>?;
    private enum Actions {
        ACTION_ANCHOR_POSITION,
        ACTION_ANCHOR_LENGTH,
        ACTION_BACK_TO_MAP,
        ACTION_COUNT
    }

    function initialize() {
        System.println("Garmin3AnchorMenuView.initialize");
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        _menuLayout = $.Rez.Layouts.MenuLayout(dc);
        setLayout(_menuLayout);
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var height = dc.getHeight();
        var width = dc.getWidth();

        // Draw selected box
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, _selectedIndex * height / ACTION_COUNT, width, height / ACTION_COUNT);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Draw frames
        dc.drawLine(0, height / ACTION_COUNT, width, height / ACTION_COUNT);
        dc.drawLine(0, 2 * height / ACTION_COUNT, width, 2 * height / ACTION_COUNT);

        // Draw text fields in layout
        if (_menuLayout != null) {
            for (var i = 0; i < _menuLayout.size(); i++) {
                _menuLayout[i].draw(dc);
            }
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }

    //! Increment the currently selected option index
    public function incIndex() as Void {
        _selectedIndex = (_selectedIndex + 1) % ACTION_COUNT;
    }

    //! Decrement the currently selected option index
    public function decIndex() as Void {
        _selectedIndex = (_selectedIndex + ACTION_COUNT - 1) % ACTION_COUNT;
    }

    //! Process the current attention action
    public function action() as Void {
        if (ACTION_ANCHOR_POSITION == _selectedIndex) {
            // Set anchor position
            var app = getApp();
            var posInfo = Position.getInfo();
            if (posInfo != null && posInfo.position != null) {
                app.setAnchorPosition(posInfo);
                System.println("Pozycja kotwicy ustawiona!");
            } else {
                System.println("Brak pozycji GPS!");
            }
        } else if (ACTION_ANCHOR_LENGTH == _selectedIndex) {
            // Set anchor chain length
            var app = getApp();
            WatchUi.pushView(app.getChainView(), app.getChainDelegate(), WatchUi.SLIDE_LEFT);
        } else if (ACTION_BACK_TO_MAP == _selectedIndex) {
            // Exit menu
            var app = getApp();
            WatchUi.pushView(app.getMapView(), null, WatchUi.SLIDE_LEFT);
            // WatchUi.pushView(new Garmin3AnchorMapView(), null, WatchUi.SLIDE_LEFT);
        }
        WatchUi.requestUpdate();
    }
}