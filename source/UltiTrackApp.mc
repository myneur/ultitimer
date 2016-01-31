using Toybox.Application as App;
using Toybox.WatchUi as Ui;

enum {
  start_on_countdown,
  start_on_button,
  start_on_random,
  start_on_motion
}

enum {
  stop_on_button,
  stop_on_target
}

var propertiesNames = ["target", "distance", "rest", "reps", "start", "stop"];
var defaultProperties = {
  "distance" => 200,
  "rest" => 60,
  "reps" => 1,
  "start" => start_on_countdown,
  "stop" => stop_on_button
};

var defaultDistances = [90, 100, 120, 150, 180, 200, 220, 250, 300, 350, 400];

var defaultManualTargetPM = 150;

class UltiTrackApp extends App.AppBase {
  var view;
  var workout;
  
  var mDeviceName;
  var mIsTouchScreen;

  function onStart() {
    for (var i = 0; i < propertiesNames.size(); i++) {
      var key = propertiesNames[i];
      var value = App.getApp().getProperty(key);
      if (value == null) {
        App.getApp().setProperty(key, defaultProperties[key]);
      }
    }


    var manualTarget = App.getApp().getProperty("manualTargetPM");
    var distance = App.getApp().getProperty("distance");

    if (manualTarget) {
      App.getApp().setProperty("target", manualTarget * distance / 1000);
      App.getApp().setProperty("manualTargetPM", manualTarget);
    } else {
      var time = defaultManualTargetPM * distance / 1000;
      App.getApp().setProperty("target", time);
      App.getApp().setProperty("manualTargetPM", defaultManualTargetPM);
    }
    workout = new Workout(method(:onTick)); 
  }

  function onStop() {
    workout.destroy();
  }

  function getInitialView() {
    view = new TimerView();
    if (isTouchScreen()) {
      return [ view, new TouchScreenInputDelegate() ];
    } else {
      return [ view, new NonTouchScreenInputDelegate() ];
    }
  }

  function onTick(elapsed) {
    view.onTick(elapsed);
  }

  function getDeviceName() {
    if (mDeviceName == null) {
      mDeviceName = Ui.loadResource(Rez.Strings.Device);
    }
    return mDeviceName;
  }

  function isTouchScreen() {
    if (mIsTouchScreen == null) {
      var str = Ui.loadResource(Rez.Strings.isTouchScreen);
      if (str.equals("true")) {
        mIsTouchScreen = true;
      } else {
        mIsTouchScreen = false;
      }
    }
    return mIsTouchScreen;
  }
}

