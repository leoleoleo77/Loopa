import 'dart:async';

class LoopClearListener {
  Timer? _timer;
  late Function(Timer?)? onLoopCleared;
  late Function()? onStopFlashing;
  late bool _loopWasCleared;
  
  LoopClearListener() {
    _loopWasCleared = false;
  }

  void flashName() {
    _loopWasCleared = true;
    if (_methodsInitialized()) {
      onLoopCleared!(_timer);
    }
  }

  void cancel() {
    onStopFlashing!();
    // if (_methodsInitialized() && _timerIsActive()) {
    //   onStopFlashing!();
    //   _timer!.cancel();
    //   _timer = null;
    // }
  }
  
  void setWasCleared(bool wasCleared) => _loopWasCleared = wasCleared;
  bool wasCleared() => _loopWasCleared;
  bool _methodsInitialized() => 
      onLoopCleared != null && onStopFlashing != null;
  bool _timerIsActive() => _timer?.isActive == true;
}
