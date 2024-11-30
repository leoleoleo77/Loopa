
class LoopClearController {
  late Function() startFlashing;
  late Function() stopFlashing;
  late bool _loopWasCleared; // TODO: make this public
  
  LoopClearController() {
    startFlashing = () {};
    stopFlashing = () {};
    _loopWasCleared = false;
  }

  void onClearComplete() {
    _loopWasCleared = true;
    startFlashing();
  }
  
  void setWasCleared(bool wasCleared) => _loopWasCleared = wasCleared;

  bool wasCleared() => _loopWasCleared;
}
