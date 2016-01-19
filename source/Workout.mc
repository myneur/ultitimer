
class Workout {
  var data = [];
  var timer;
  var mode = :rest;
  var target = 5000;
  var running = false;

  var mOnTick;

  function initialize(onTick) {
    mOnTick = onTick;
    timer = new UltiTimer(method(:onTick));
  }

  function start() {
    running = true;
    timer.start();
  }

  function stop() {
    timer.stop();
  }

  function reset() {
    timer.reset();
  }

  function destroy() {
    timer.destroy();
    mOnTick = null;
  }

  function switchMode() {
    if (mode == :rest) {
      mode = :run;
      timer.elapsed = 0;
      target = 10000;
    } else {
      mode = :rest;
      timer.elapsed = 0;
      target = 5000;
    }
  }

  function onTick(elapsed) {
    mOnTick.invoke(elapsed);
  }
}
