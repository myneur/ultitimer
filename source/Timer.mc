using Toybox.Timer as Timer;

class UltiTimer {
  var elapsed = 0;
  var running = false;

  var mOnTick;
  var mTimer;

  function initialize(onTick) {
    mOnTick = onTick;
    mTimer = new Timer.Timer();
  }

  function start() {
    running = true;
    mTimer.start(method(:onTick), 50, true); 
    mOnTick.invoke(elapsed);
  }

  function onTick() {
    elapsed += 50;
    mOnTick.invoke(elapsed);
  }

  function stop() {
    running = false;
    mTimer.stop();
  }

  function reset() {
    elapsed = 0;
  }

  function destroy() {
    mOnTick = null;
  }
}
