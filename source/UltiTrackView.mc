using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Attention as Attention;


class TimerView extends Ui.View {
  function onLayout(dc) {
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

    var segment = app.workout.getCurrentSegment();

    if (app.workout.running) {
      if (segment[0] == :run) {
        string = ((elapsed / 10).toFloat() / 100).format("%03.2f");
      } else {
        var prevSegment = app.workout.getPrevSegment();
        var nextSegment = app.workout.getNextSegment();
        if (prevSegment != null) {
          string = ((prevSegment[3] / 10).toFloat() / 100).format("%03.2f");
        } else if (nextSegment != null) {
          string = (nextSegment[1] / 1000) + "s";
        }
      }
    } else {
      var time = app.getProperty("target");
      string = time + "s";
    }
    targetElem.setText(string);

    string = "";

    if (app.workout.running) {
      if (segment[0] == :rest) {
        string = ((segment[1] - app.workout.timer.elapsed + 600) /
1000).format("%d");
      } else {
        var nextSegment = app.workout.getNextSegment();
        if (nextSegment != null) {
          string = (nextSegment[1] / 1000) + "s";
        }
      }
    } else {
      var reps = app.getProperty("reps");
      if (reps > 1) {
        var rest = app.getProperty("rest");
        string = rest + "s";
      }
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
    var currentRep = app.workout.getCurrentRep();
    var string;
    if (app.workout.running == true) {
      string = currentRep + "/" + reps;
    } else {
      string = reps.format("%d");
    }
    elem.setText(string);
  }

  function onTick(elapsed) {
    Ui.requestUpdate();
  }

  function openTheMenu() {
    Ui.pushView( new Rez.Menus.MainMenu(), new MainMenuDelegate(), Ui.SLIDE_UP );
  }
}

class MainMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
        if ( item == :menu_item_start ) {
          Ui.pushView( new Rez.Menus.StartMenu(), new StartMenuDelegate(), Ui.SLIDE_UP );
        } else if ( item == :item_2 ) {
            // Do something else here
        }
    }
}

class StartMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
      var value = start_on_countdown;
      if ( item == :menu_item_countdown ) {
        value = start_on_countdown;
      } else if ( item == :menu_item_random ) {
        value = start_on_random;
      } else if ( item == :menu_item_button ) {
        value = start_on_button;
      } else if ( item == :menu_item_motion ) {
        value = start_on_motion;
      }
      App.getApp().setProperty("start", value);
      Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

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
  var lastManualInput = [0,0];

  function onMenu() {
    var app = App.getApp();
    if (app.workout.running == false) {
      app.view.openTheMenu();
    }
    return true;
  }

  function onTap(evt) {
    var cords = evt.getCoordinates();
    if (App.getApp().workout.running) {
      return;
    }

    if (isPointInBox(cords, UIBoxes["distance"])) {
      var manualTargetPM = App.getApp().getProperty("manualTargetPM");
      var oldDistance = App.getApp().getProperty("distance");
      var currIndex = arrayIndexOf(defaultDistances, oldDistance);

      currIndex += 1;
      if (currIndex >= defaultDistances.size()) {
        currIndex = 0;
      }
      var distance = defaultDistances[currIndex];
      App.getApp().setProperty("distance", distance);

      var time = (manualTargetPM * distance) / 1000;

      App.getApp().setProperty("target", time);
      Ui.requestUpdate();
      return;
    }

    var distance = App.getApp().getProperty("distance");

    if (isPointInBox(cords, UIBoxes["target"])) {
      var time = App.getApp().getProperty("target");
      Ui.pushView(
        new NumberPicker([1, 180], time - 1, "Target time for " + distance + "m"),
        new TargetPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    }

    if (isPointInBox(cords, UIBoxes["rest"])) {
      var rest = App.getApp().getProperty("rest");
      Ui.pushView(
        new NumberPicker([1, 180], rest - 1, "Rest time for " + distance + "m"),
        new RestPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    }

    if (isPointInBox(cords, UIBoxes["reps"])) {
      var reps = App.getApp().getProperty("reps");
      Ui.pushView(
        new NumberPicker([1, 12], reps - 1, "Number of reps"),
        new RepsPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
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

  function onBack(evt) {
    var app = App.getApp();

    if (app.workout.running == false) {
      return false;
    } else {
      app.workout.reset(); 
      Ui.requestUpdate();
      return true;
    }
  }
}
