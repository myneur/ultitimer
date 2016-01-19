using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attention;
using Toybox.Application as App;


class TimerView extends Ui.View {
  var mDC;

  function onLayout(dc) {
    mDC = dc;
    setLayout(Rez.Layouts.MainLayout(dc));
  }

  function onUpdate(dc) {
    var app = App.getApp();
    drawTargetAndRest(app);
    drawDistance(app);
    drawReps(app);
    View.onUpdate(dc);
  }

  function drawTargetAndRest(app) {
    var targetElem = findDrawableById("target_value");
    var restElem = findDrawableById("rest_value");

    var elapsed = app.workout.timer.elapsed;
    var string = "";

    if (app.workout.running &&
        app.workout.mode == :run) {
      string = ((elapsed / 10).toFloat() / 100).format("%03.2f");
    } else {
      var time = app.getProperty("target");
      string = time + "s";
    }
    targetElem.setText(string);

    if (app.workout.running &&
        app.workout.mode == :rest) {
      string = ((app.workout.target - app.workout.timer.elapsed + 600) /
1000).format("%d");
    } else {
      var rest = app.getProperty("rest");
      string = rest + "s";
    }
    restElem.setText(string);
  }

  function drawDistance(app) {
    var elem = findDrawableById("distance_value");
    var distance = app.getProperty("distance");
    var string = distance + "m";
    elem.setText(string);
  }

  function drawReps(app) {
    var elem = findDrawableById("reps_value");
    var reps = app.getProperty("reps");
    var string;
    if (app.workout.timer.elapsed > 0) {
      string = 1 + "/" + reps;
    } else {
      string = reps.format("%d");
    }
    elem.setText(string);
  }

  function onTick(elapsed) {
    System.println(elapsed);
    var app = App.getApp();
    if (app.workout.mode == :rest) {
      if (elapsed < app.workout.target) {
        if (elapsed % 1000 == 0) {
          Attention.playTone(Attention.TONE_LOUD_BEEP);
        }
      }
    }

    if (elapsed == app.workout.target) {
      Attention.backlight(true);
      Attention.playTone(Attention.TONE_START);
      app.workout.switchMode();
    ///} else if (elapsed == 10 * 1000) {
    //  Attention.backlight(true);
    //  Attention.playTone(Attention.TONE_TIME_ALERT);
    }

    drawReps(app);
    drawTargetAndRest(app);
    View.onUpdate(mDC);
  }
}

var UIBoxes = {
  "distance" => {
    "x" => [145, 205],
    "y" => [0, 50]
  },
  "reps" => {
    "x" => [0, 65],
    "y" => [0, 50]
  },
  "target" => {
    "x" => [50, 155],
    "y" => [60, 120]
  },
  "rest" => {
    "x" => [50, 155],
    "y" => [120, 180]
  }
};

class TimerInputDelegate extends Ui.BehaviorDelegate {
  function onMenu() {
    return true;
  }

  function onTap(evt) {
    var cords = evt.getCoordinates();

    if (isPointInBox(cords, UIBoxes["distance"])) {
      var oldDistance = App.getApp().getProperty("distance");
      var currIndex = arrayIndexOf(defaultDistances, oldDistance);

      currIndex += 1;
      if (currIndex >= defaultDistances.size()) {
        currIndex = 0;
      }
      var distance = defaultDistances[currIndex];
      App.getApp().setProperty("distance", distance);
      var time = defaultTargets[distance];
      App.getApp().setProperty("target", time);
      Ui.requestUpdate();
      return;
    }

    if (isPointInBox(cords, UIBoxes["reps"])) {
      var reps = App.getApp().getProperty("reps");

      reps += 1;
      if (reps >= 5) {
         reps = 1;
      }
      App.getApp().setProperty("reps", reps);
      Ui.requestUpdate();
      return;
    }

    if (isPointInBox(cords, UIBoxes["target"])) {
      var time = App.getApp().getProperty("target");
      Ui.pushView(new TimePicker([1, 180], time - 1), new TargetPickerDelegate(), Ui.SLIDE_IMMEDIATE);
    }

    if (isPointInBox(cords, UIBoxes["rest"])) {
      var rest = App.getApp().getProperty("rest");
      Ui.pushView(new TimePicker([1, 180], rest - 1), new RestPickerDelegate(), Ui.SLIDE_IMMEDIATE);
    }
  }

  function onHold(evt) {
  }

  function onSwipe(evt) {
  }

  function onKey(evt) {
    var key = evt.getKey();
    var app = App.getApp();

    if (key == 4) { // Start in the emulator
      if (app.workout.running) {
        if (app.workout.mode == :rest) {
          app.workout.stop();
        } else {
          Attention.playTone(Attention.TONE_STOP);
          app.workout.switchMode();
        }
      } else {
        Attention.playTone(Attention.TONE_START);
        app.workout.start();
      }
    }
  }

  function onBack(evt) {
    var app = App.getApp();

    if (app.workout.timer.elapsed == 0.0) {
      return false;
    } else {
      app.workout.reset(); 
      Ui.requestUpdate();
      return true;
    }
  }
}
