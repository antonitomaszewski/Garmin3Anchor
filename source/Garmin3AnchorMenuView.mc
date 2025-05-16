import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class Garmin3AnchorMenuView extends WatchUi.View {
    private var _selectedIndex as Number = 0;
    private var _options as Array<String>;
    private var _menuLayout as Array<Drawable>?;
    private enum Actions {
        ACTION_ANCHOR_POSITION,
        ACTION_ANCHOR_LENGTH,
        ACTION_BACK_TO_MAP,
        ACTION_EXIT,
        ACTION_COUNT
    }

    function initialize() {
        System.println("Garmin3AnchorMenuView.initialize");
        View.initialize();

        _options = [
            Application.loadResource($.Rez.Strings.setAnchorPosition),
            Application.loadResource($.Rez.Strings.setAnchorChainLength),
            Application.loadResource($.Rez.Strings.back),
            Application.loadResource($.Rez.Strings.exit)
        ];
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

        // Wyznacz indeksy opcji do wyświetlenia (poprzednia, aktualna, następna)
        var count = _options.size();
        var topIdx    = (_selectedIndex - 1 + count) % count;
        var centerIdx = _selectedIndex;
        var bottomIdx = (_selectedIndex + 1) % count;

            // Ustaw teksty w layout
        var topLabel    = findDrawableById("menuOptionTop") as WatchUi.Text;
        var centerLabel = findDrawableById("menuOptionCenter") as WatchUi.Text;
        var bottomLabel = findDrawableById("menuOptionBottom") as WatchUi.Text;

        if (topLabel != null)    { topLabel.setText(_options[topIdx]); }
        if (centerLabel != null) { centerLabel.setText(_options[centerIdx]); }
        if (bottomLabel != null) { bottomLabel.setText(_options[bottomIdx]); }

        // Podświetl środkową opcję
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        var centerY = dc.getHeight() / 2 - dc.getFontHeight(Graphics.FONT_MEDIUM) / 2;
        dc.fillRectangle(0, centerY, width, dc.getFontHeight(Graphics.FONT_MEDIUM));


        // // Draw selected box
        // dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        // dc.fillRectangle(0, _selectedIndex * height / ACTION_COUNT, width, height / ACTION_COUNT);
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // // Draw frames
        // dc.drawLine(0, height / ACTION_COUNT, width, height / ACTION_COUNT);
        // dc.drawLine(0, 2 * height / ACTION_COUNT, width, 2 * height / ACTION_COUNT);

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
            // Exit menu -- z tego wzroca powinniśmy zazwyczaj korzystać,
            // dodatkowo należy push - pop używać często, a nie sztuwno zdefiniowane mieć wszystkie widoki w 
            // App
//             ja chyba czegoś nie rozumiem w przepływie plików,
// mam wrażenie że powinnieśmy więcej korzystać z push view, pop view
// czyli:
// na samej inicjalizacji aplikacji robimy PushView (map) 
// w inicjaliacji map robimy PushView(menu)
// i gdy klikniemy back w menu to robimy popView()
// a w Map nie ma możliwości klikniecia back, natomiast jest opcja przytrzymania długeigo key_up i to robi nam z powroten PushView Menu
// Dodatkowo pewnie nie powinniśmy wszystkich widoków trzymać raz zainicjowanych w naszym APP tylko za każdym razem wywoływać new w pushView 
            var view = new $.Garmin3AnchorMapView();
            var delegate = new $.Garmin3AnchorMapDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_DOWN);
        } else if (ACTION_EXIT == _selectedIndex) {
            System.println("Wyjście z aplikacji przez menu");
            System.exit();
        }
        WatchUi.requestUpdate();
    }
}