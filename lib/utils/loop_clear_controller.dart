
class LoopClearController {
  late Function() startFlashing;
  late Function() stopFlashing;
  late bool _loopWasCleared;
  
  LoopClearController() {
    startFlashing = () {};
    stopFlashing = () {};
    _loopWasCleared = false;
  }

  void onStartFlashing() {
    _loopWasCleared = true;
    startFlashing();
  }

  void onStopFlashing() => stopFlashing();
  
  void setWasCleared(bool wasCleared) => _loopWasCleared = wasCleared;

  bool wasCleared() => _loopWasCleared;
}
