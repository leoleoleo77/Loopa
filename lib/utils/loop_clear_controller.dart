
class LoopClearController {
  late Function() startFlashing;
  late Function() stopFlashing;
  late bool loopWasCleared;
  
  LoopClearController() {
    startFlashing = () {};
    stopFlashing = () {};
    loopWasCleared = false;
  }

  void onClearComplete() {
    loopWasCleared = true;
    startFlashing();
  }
}
