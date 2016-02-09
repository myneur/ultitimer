using Toybox.WatchUi as Ui;
using Toybox.Application as App;


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

    var segment = app.workout.segments[:current];

    if (app.workout.running) {
      if (segment[:type] == :run) {
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
    System.println("Tick: " + elapsed);
    Ui.requestUpdate();
  }

  function openTheMenu() {
    if (App.getApp().isTouchScreen()) {
      Ui.pushView( new Rez.Menus.WorkoutSettingsMenu(), new WorkoutSettingsMenuDelegate(), Ui.SLIDE_UP );
    } else {
      Ui.pushView( new Rez.Menus.WorkoutMenu(), new WorkoutMenuDelegate(), Ui.SLIDE_UP );
    }
  }
}
