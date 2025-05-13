import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Position;

class Garmin3AnchorApp extends Application.AppBase {
    // var positionInfo
    private var anchorPosition as Position.Location or Null;
    private var anchorChainLength as Number or Null;
    private var sailboatPositions as Array<Position.Location> = [];

    private var chainView as Garmin3AnchorChainView or Null;
    private var chainDelegate as Garmin3AnchorChainDelegate or Null;
    private var mapView as Garmin3AnchorMapView or Null;
    // private var MapDelegate as Garmin3AnchorMapDelegate or Null;
    private var menuView as Garmin3AnchorMenuView or Null;
    private var menuDelegate as Garmin3AnchorMenuDelegate or Null;

    function initialize() {
        System.println("Garmin3AnchorApp.initialize");
        AppBase.initialize();
        chainView = new Garmin3AnchorChainView();
        chainDelegate = new Garmin3AnchorChainDelegate(chainView);
        mapView = new Garmin3AnchorMapView();
        // MapDelegate = new Garmin3AnchorMapDelegate(MapView);
        menuView = new Garmin3AnchorMenuView();
        menuDelegate = new Garmin3AnchorMenuDelegate(menuView);

    }

    function onStart(state as Dictionary?) as Void {
        System.println("Garmin3AnchorApp.onStart");
        System.println("Włączanie GPS...");
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        System.println("GPS włączony.");
    }

    function onPosition(info as Position.Info) as Void {
        System.println("Garmin3AnchorView.onPosition");
        if (isAnchorPositionSet()) {
            addSailboatPosition(info);
        }
    }
    
    function onStop(state as Dictionary?) as Void {
        System.println("Garmin3AnchorApp.onStop");
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function isAnchorPositionSet() as Boolean {
        return anchorPosition != null;
    }

    function setAnchorPosition(info as Position.Info) as Void {
        System.println("Garmin3AnchorApp.setAnchorPosition" + info.position.toDegrees());
        anchorPosition = info.position;
    }

    function getAnchorPosition() as Position.Location or Null {
        return anchorPosition;
    }

    function setAnchorChainLength(length as Number) as Void {
        System.println("Garmin3AnchorApp.setAnchorChainLength: " + length);
        anchorChainLength = length;
    }

    function getAnchorChainLength() as Number or Null {
        return anchorChainLength;
    }

    function addSailboatPosition(info as Position.Info) as Void {
        System.println("Garmin3AnchorApp.addSailboatPosition");
        sailboatPositions.add(info.position);
    }

    function getSailboatPositions() as Array<Position.Location> {
        return sailboatPositions;
    }


    function getChainView() as Garmin3AnchorChainView {
        return chainView;
    }
    function getChainDelegate() as Garmin3AnchorChainDelegate {
        return chainDelegate;
    }
    function getMapView() as Garmin3AnchorMapView {
        return mapView;
    }
    function getMenuView() as Garmin3AnchorMenuView {
        return menuView;
    }
    function getMenuDelegate() as Garmin3AnchorMenuDelegate {
        return menuDelegate;
    }


    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        System.println("Garmin3AnchorApp.getInitialView");
        return [menuView, menuDelegate];
    }
}

function getApp() as Garmin3AnchorApp {
    System.println("Garmin3AnchorApp.getApp");
    return Application.getApp() as Garmin3AnchorApp;
}