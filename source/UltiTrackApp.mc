using Toybox.Application as App;

var propertiesNames = ["target", "distance", "rest", "reps"];
var defaultProperties = {
  "distance" => 200,
  "rest" => 60,
  "reps" => 1
};

var defaultDistances = [90, 100, 120, 150, 180, 200, 220, 250, 300, 350, 400];
var defaultTargets = {
   90 => 10,
  100 => 12,
  120 => 14,
  150 => 18,
  180 => 23,
  200 => 30,
  220 => 32,
  250 => 34,
  300 => 42,
  350 => 50,
  400 => 58
};

var preferences = {
  "start" => :start_on_countdown
};

class UltiTrackApp extends App.AppBase {
  var view;
  var workout;

  function onStart() {
    for (var i = 0; i < propertiesNames.size(); i++) {
      var key = propertiesNames[i];
      var value = App.getApp().getProperty(key);
      if (value == null) {
        App.getApp().setProperty(key, defaultProperties[key]);
      }
    }

    var distance = defaultProperties["distance"];
    var time = defaultTargets[distance];
    App.getApp().setProperty("target", time);
    App.getApp().setProperty("manualTargetPM", time * 1000 / distance);
    workout = new Workout(method(:onTick)); 
  }

  function onStop() {
    App.getApp().clearProperties();
    workout.destroy();
  }

  function getInitialView() {
    view = new TimerView();
    return [ view, new TimerInputDelegate() ];
  }

  function onTick(elapsed) {
    view.onTick(elapsed);
  }
}

