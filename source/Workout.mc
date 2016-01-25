using Toybox.Application as App;
using Toybox.Attention as Attention;

class Workout {
  var segments = [];
  var currentSegment = 0;

  var notifications = [];
  var currentNotification = 0;

  var timer;
  var running = false;

  var mOnTick;
  var mSplitDistance = 100;

  function initialize(onTick) {
    mOnTick = onTick;
    timer = new UltiTimer(method(:onTick));
  }

  function start() {
    setSegments();
    //setNotifications();

    running = true;
    timer.start();
  }

  function unpause() {
    timer.start();
  }

  function stop() {
    timer.stop();
  }

  function reset() {
    running = false;
    currentSegment = 0;
    segments = [];
    currentNotification = 0;
    notifications = [];
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

  function setSegments() {
    var app = App.getApp();
    var reps = app.getProperty("reps");
    var start = app.getProperty("start");
    var target = app.getProperty("target");
    var distance = app.getProperty("distance");
    var rest = app.getProperty("rest");

    var mode;
    var useInitialCountdown = false;

    if (start == start_on_countdown) {
      mode = :rest;
      useInitialCountdown = true;
    } else {
      mode = :run;
    }

    var size = reps + (reps - 1);

    if (useInitialCountdown) {
      size += 1;
    }

    segments = new [size];


    for (var i = 0; i < size; i++) {
      var segment;

      if (mode == :run) {
        segment = {
          :type => :run,
          :target => {
            :type => :open,
            :time => target * 1000,
            :distance => distance
          },
          :notifications => [],
          :result => {}
        };
        mode = :rest;
      } else {
        if (useInitialCountdown == true && i == 0) {
          segment = {
            :type => :rest,
            :target => {
              :type => :time,
              :time => 2000,
              :distance => null
            },
            :notifications => [],
            :result => {}
          };
        } else {
          segment = {
            :type => :rest,
            :target => {
              :type => :time,
              :time => rest * 1000,
              :distance => null
            },
            :notifications => [],
            :result => {}
          };
        }
        mode = :run;
      }
      segments[i] = segment;
    }
  }

  function advanceSegment() {
    var segment = getCurrentSegment();
    segment[:result][:time] = timer.elapsed;

    if (currentSegment + 1 >= segments.size()) {
      if (timer.running == false) {
        reset();
      } else {
        stop();
      }
      return;
    }

    currentSegment += 1;

    setNotifications();
    timer.stop();
    timer.reset();
    timer.start();
  }

  function onAdvanceButton() {
  }

  function setNotifications() {
  }

  function onTick(elapsed) {
    var segment = getCurrentSegment();

    if (segment[:target][:type] == :time) {
      if (elapsed >= segment[:target][:time]) {
        app.workout.advanceSegment();
        return;
      }
    }

    mOnTick.invoke(elapsed);
  }
}
