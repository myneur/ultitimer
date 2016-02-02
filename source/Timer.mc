using Toybox.Timer as Timer;

class UltiTimer {
  var elapsed = 0;
  var running = false;

  var mOnTick;
  var mOnDone;
  var mTimer;
  var mLastTime = 0;
  var mInterval = 1000;
  var mTarget;

  function initialize(onTick) {
    mOnTick = onTick;
    mTimer = new Timer.Timer();
  }

  function start(target, onDone) {
    running = true;
    mOnDone = onDone;
    mTarget = target;

    mTimer.start(method(:onTick), mInterval, true); 
    mLastTime = System.getTimer();
    mOnTick.invoke(elapsed);
  }

  function onTick() {
    var now = System.getTimer();
    elapsed += now - mLastTime;
    if (elapsed >= mTarget) {
      mOnDone.invoke(elapsed);
    }

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
    mOnDone = null;
  }
}
