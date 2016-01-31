using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Attention as Attention;

var UIBoxes = {
  "distance" => {
    "x" => [120, 205],
    "y" => [0, 80]
  },
  "reps" => {
    "x" => [0, 105],
    "y" => [0, 80]
  },
  "target" => {
    "x" => [50, 155],
    "y" => [80, 140]
  },
  "rest" => {
    "x" => [50, 155],
    "y" => [140, 200]
  }
};

class TimerInputDelegate extends Ui.BehaviorDelegate {
  function onMenu() {
    var app = App.getApp();
    if (app.workout.running == false) {
      app.view.openTheMenu();
    }
    return true;
  }

  function onBack(evt) {
    var app = App.getApp();

    if (app.workout.running == false) {
      return false;
    } else {
      app.workout.stop();
      app.workout.reset(); 
      Ui.requestUpdate();
      return true;
    }
  }
}

class TouchScreenInputDelegate extends TimerInputDelegate {

  function onTap(evt) {
    var cords = evt.getCoordinates();
    if (App.getApp().workout.running) {
      return;
    }

    if (isPointInBox(cords, UIBoxes["distance"])) {
      Ui.pushView(
        new DistancePicker("Distance"),
        new DistancePickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
      return;
    }


    if (isPointInBox(cords, UIBoxes["target"])) {
      var distance = App.getApp().getProperty("distance");
      var time = App.getApp().getProperty("target");
      Ui.pushView(
        new NumberPicker([1, 180], time - 1, "Target time for " + distance + "m"),
        new TargetPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
      return;
    }

    if (isPointInBox(cords, UIBoxes["rest"])) {
      var distance = App.getApp().getProperty("distance");
      var rest = App.getApp().getProperty("rest");
      Ui.pushView(
        new TimePicker([1, 180], rest, "Rest time for " + distance + "m"),
        new RestPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
      return;
    }

    if (isPointInBox(cords, UIBoxes["reps"])) {
      var reps = App.getApp().getProperty("reps");
      Ui.pushView(
        new NumberPicker([1, 12], reps - 1, "Number of reps"),
        new RepsPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    }
  }

  function onKey(evt) {
    var key = evt.getKey();
    var app = App.getApp();

    if (key == 4) { // Start in the emulator
      var segment = app.workout.getCurrentSegment();
      if (app.workout.running && segment != null) {
        if (segment[0] == :rest) {
          if (app.workout.timer.running) {
            Attention.backlight(true);
            Attention.playTone(Attention.TONE_STOP);
            app.workout.stop();
          } else {
            Attention.backlight(true);
            Attention.playTone(Attention.TONE_STOP);
            app.workout.unpause();
          }
        } else {
          Attention.backlight(true);
          Attention.playTone(Attention.TONE_STOP);
          app.workout.switchMode();
          Ui.requestUpdate();
        }
      } else {
        if (app.workout.segments.size() > 0) {
          Attention.backlight(true);
          Attention.playTone(Attention.TONE_STOP);
          app.workout.reset();
          Ui.requestUpdate();
        } else {
          Attention.backlight(true);
          Attention.playTone(Attention.TONE_START);
          app.workout.start();
        }
      }
    }
  }
}


class NonTouchScreenInputDelegate extends TimerInputDelegate {
  function onKey(evt) {
    var key = evt.getKey();
    var app = App.getApp();

    if (key == 4) { // Start in the emulator
      var segment = app.workout.getCurrentSegment();
      if (app.workout.running && segment != null) {
        if (segment[0] == :rest) {
          if (app.workout.timer.running) {
            Attention.backlight(true);
            Attention.playTone(Attention.TONE_STOP);
            app.workout.stop();
          } else {
            Attention.backlight(true);
            Attention.playTone(Attention.TONE_STOP);
            app.workout.unpause();
          }
        } else {
          Attention.backlight(true);
          Attention.playTone(Attention.TONE_STOP);
          app.workout.switchMode();
          Ui.requestUpdate();
        }
      } else {
        if (app.workout.segments.size() > 0) {
          Attention.backlight(true);
          Attention.playTone(Attention.TONE_STOP);
          app.workout.reset();
          Ui.requestUpdate();
        } else {
          Attention.backlight(true);
          Attention.playTone(Attention.TONE_START);
          app.workout.start();
        }
      }
    }
  }
}
