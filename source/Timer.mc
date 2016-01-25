using Toybox.Timer as Timer;

class UltiTimer {
  var elapsed = 0;
  var running = false;

  var mInterval = 50;

  var mOnTick;
  var mTimer;
  var mLastTime = 0;

  function initialize(onTick) {
    mOnTick = onTick;
    mTimer = new Timer.Timer();
  }

  function start() {
    mTimer.start(method(:onTick), mInterval, true); 
    mLastTime = System.getTimer();
    running = true;
    mOnTick.invoke(elapsed);
  }

  function onTick() {
    var now = System.getTimer();
    elapsed += now - mLastTime;
    mLastTime = now;
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
