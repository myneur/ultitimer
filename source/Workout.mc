using Toybox.Application as App;

class Workout {
  var segments = [];
  var currentSegment = 0;

  var timer;
  var running = false;

  var mOnTick;

  function initialize(onTick) {
    mOnTick = onTick;
    timer = new UltiTimer(method(:onTick));
  }

  function start() {
    var app = App.getApp();
    var reps = app.getProperty("reps");
    var target = app.getProperty("target");
    var distance = app.getProperty("distance");
    var rest = app.getProperty("rest");

    var size = 1 + reps + (reps - 1);
    segments = new [size];

    var mode = :run;

    for (var i = 0; i < size; i++) {
      if (mode == :rest) {
        segments[i] = [:run, target * 1000, distance, null];
        mode = :run;
      } else {
        segments[i] = [:rest, rest * 1000, null, null];
        mode = :rest;
      }
    }
    running = true;
    timer.start();
  }

  function stop() {
    running = false;
    timer.stop();
  }

  function reset() {
    currentSegment = 0;
    timer.reset();
  }

  function destroy() {
    timer.destroy();
    mOnTick = null;
  }

  function getCurrentSegment() {
    if (currentSegment >= segments.size()) {
      return null;
    }
    return segments[currentSegment];
  }

  function getCurrentRep() {
    if (running ==  false) {
      return 1;
    }
    var result = 0;

    for (var i = 0; i <= currentSegment; i++) {
      if (segments[i][0] == :rest) {
        result += 1;
      }
    }

    if (result == 0) {
      return 1;
    }
    return result;
  }

  function getNextSegment() {
    if (currentSegment + 1 >= segments.size()) {
      return null;
    }
    return segments[currentSegment + 1];
  }

  function getPrevSegment() {
    if (currentSegment - 1 < 0) {
      return null;
    }
    return segments[currentSegment - 1];
  }

  function switchMode() {
    segments[currentSegment][3] = timer.elapsed;
    
    currentSegment += 1;
    timer.elapsed = 0;

    if (currentSegment >= segments.size()) {
      stop();
    }
  }

  function onTick(elapsed) {
    mOnTick.invoke(elapsed);
  }
}
