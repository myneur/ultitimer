using Toybox.Application as App;

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

    var distance = App.getApp().getProperty("distance");
    var time = defaultTargets[distance];
    App.getApp().setProperty("target", time);
    App.getApp().setProperty("manualTargetPM", time * 1000 / distance);
    workout = new Workout(method(:onTick)); 
  }

  function onStop() {
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

