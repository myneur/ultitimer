using Toybox.Application as App;
using Toybox.Attention as Attention;

class Workout {
  var segments = {
    :plan => [],
    :current => null,
    :history => []
  };

  var segmentPtrs = {
    :plan => 0,
    :history => 0
  };

  var running = false;
  var timer;

  var mOnTick;

  function initialize(onTick) {
    mOnTick = onTick;
    timer = new UltiTimer(method(:onTick));
  }

  function start() {
    System.println("start");
    createPlan();

    running = true;

    segments[:current] = segments[:plan][0];

    timer.start(segments[:current][:target][:time], method(:targetReached));
  }

  function stop() {
    System.println("stop");
    timer.stop();
  }

  function reset() {
    System.println("reset");
    running = false;
    segmentPtrs[:plan] = 0;
    segmentPtrs[:history] = 0;
    segments[:plan] = [];
    segments[:current] = null;
    segments[:history] = [];

    timer.reset();
  }

  function destroy() {
   timer.destroy();
   mOnTick = null;
  }

  function createPlan() {
    var app = App.getApp();
    var start = app.getProperty("start");
    var reps = app.getProperty("reps");
    var distance = app.getProperty("distance");
    var target = app.getProperty("target");
    var rest = app.getProperty("rest");

    var mode = :run;

    var size = reps * 2 - 1;

    segments[:plan] = new [size];
    segments[:history] = new [size];

    for (var i = 0; i < size; i++) {
      if (mode == :rest) {
        segments[:plan][i] = {
          :type => :rest,
          :start => {
            :trigger => null
          },
          :stop => {
            :trigger => :button
          },
          :target => {
            :time => 2000
          }
        };
        mode = :run;
      } else if (mode == :run) {
        segments[:plan][i] = {
          :type => :run,
          :start => {
            :trigger => :button
          },
          :stop => {
            :trigger => :button
          },
          :target => {
            :time => target * 1000,
            :distance => distance
          }
        };
        mode = :rest;
      }
    }
    System.println("Plan:");
    System.println(segments[:plan]);
  }

  function targetReached() {
    var segment = getCurrentSegment();

    System.println("Target reached");

    if (segment[:stop][:trigger] == :time) {
      advanceSegment();
    }
  }

  function advanceSegment() {
    System.println("advanceSegment");

    var segment = getCurrentSegment();

    segments[:history][segmentPtrs[:history]] = {
      :type => segment[:type],
      :result => {
        :time => timer.elapsed
      }
    };
    segmentPtrs[:history] += 1;

    System.println("History:");
    System.println(segments[:history]);

    if (segmentPtrs[:plan] + 1 >= segments[:plan].size()) {
      if (running == false) {
        reset();
      } else {
        stop();
      }
      return;
    }

    segmentPtrs[:plan] += 1;

    timer.stop();
    timer.reset();
    timer.start();
  }

  function onAdvanceButton() {
    System.println("onAdvanceButton");
    if (running == false) {
      start();
    } else {
      var segment = getCurrentSegment();

      if (segment[:stop][:trigger] == :button) {
        advanceSegment();
      }
    }
  }

  function getCurrentSegment() {
    return segments[:current];
  }

  function getCurrentRep() {
    return 1;
    if (running == false) {
      return 1;
    }

    var result = 0;

    for (var i = 0; i < segments[:history].size(); i++) {
      if (segments[:history][i][:type] == :run) {
        result += 1;
      }
    }

    return result + 1;
  }

  function onTick(elapsed) {
    mOnTick.invoke(elapsed);
  }
}
