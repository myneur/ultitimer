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
    System.println("Timer starts");
    running = true;
    mOnDone = onDone;
    mTarget = target;

    mTimer.start(method(:onTick), mInterval, true); 
    mLastTime = System.getTimer();
    onTick();
  }

  function onTick() {
    var now = System.getTimer();

    if (elapsed < mTarget &&
       elapsed + now - mLastTime >= mTarget) {
      mOnDone.invoke(elapsed);
    }

    elapsed += now - mLastTime;
    System.println("onTick: " + elapsed);

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
