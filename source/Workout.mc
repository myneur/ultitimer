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
    setNotifications();

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
    
    if (currentSegment + 1 >= segments.size()) {
      if (timer.running == false) {
        reset();
      } else {
        timer.stop();
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

  function setSegments() {
    var app = App.getApp();
    var reps = app.getProperty("reps");
    var target = app.getProperty("target");
    var distance = app.getProperty("distance");
    var rest = app.getProperty("rest");
    var rest_type = app.getProperty("rest_type");


    var mode;
    var useInitialCountdown = false;

    var start = app.getProperty("start");

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
      if (mode == :run) {
        segments[i] = [:run, target * 1000, distance, null];
        mode = :rest;
      } else {
        if (useInitialCountdown == true && i == 0) {
          segments[i] = [:rest, 2000, null, null];
        } else {
          if (rest_type == rest_type_time) {
            segments[i] = [:rest, rest * 1000, null, null];
          } else {
            segments[i] = [:rest, null, null, null];
          }
        }
        mode = :run;
      }
    }
  }

  function setNotifications() {
    var segment = segments[currentSegment];
    var target = segment[1];

    if (target == null) {
      return;
    }

    var countdown = 2;
    if (segment[0] == :run) {
      countdown = 5;
    }

    var size = countdown;
    var i = 0;
    var splits = 0;
    var distance = 0;
    if (segment[0] == :run) {
      distance = segment[2];

      var isPartial = distance % 100 > 0;

      splits = ((distance - (distance % 100)) / 100);
      if (!isPartial) {
        splits -= 1;
      }

      size += splits;
      size += 2;
    }

    notifications = new [size];

    if (segment[0] == :run) {
      notifications[0] =  [
        0,
        Attention.TONE_START,
        [new Attention.VibeProfile(400, 400)]
      ];
      i += 1;
    }

    for (var j = 0; j < splits; j++) {
      var splitTime = target / distance * 100;
      notifications[j + i] = [
        splitTime * (j + 1),
        Attention.TONE_LAP,
        [new Attention.VibeProfile(400, 400)]
      ];
    }
    i += splits;

    for (var j = 0; j < countdown; j++) {
      notifications[j + i] = [
        target - (1000 * (countdown - j)),
        Attention.TONE_LOUD_BEEP,
        null
      ];
    }
    i += countdown;

    if (segment[0] == :run) {
      notifications[size - 1] = [
        target,
        Attention.TONE_TIME_ALERT,
        [new Attention.VibeProfile(400, 400)]
      ];
    }

    currentNotification = 0;
  }

  function onTick(elapsed) {
    if (currentNotification < notifications.size() &&
        notifications[currentNotification][0] <= elapsed - (timer.mInterval /
2)) {
      var notification = notifications[currentNotification];

      Attention.backlight(true);
      Attention.playTone(notification[1]);
      if (notification[2]) {
        Attention.vibrate(notification[2]);
      }

      currentNotification++;

      while (currentNotification + 1 < notifications.size() &&
        notifications[currentNotification][0] >=
notifications[currentNotification + 1][0]) {
        currentNotification++;
      }
    }

    var app = App.getApp();
    var segment = app.workout.getCurrentSegment();

    if (segment[0] == :rest && segment[1] != null) {
      if (elapsed >= segment[1]) {
        app.workout.switchMode();
        return;
      }
    }

    mOnTick.invoke(elapsed);
  }
}
