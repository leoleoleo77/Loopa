
class LoopClearController {
  static late Function() startFlashing;
  static late Function() stopFlashing;
  bool loopWasCleared = false;


  void onClearComplete() {
    loopWasCleared = true;
    startFlashing();
  }
}
