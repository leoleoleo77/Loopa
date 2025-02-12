class KeyboardController {
  KeyboardController();

  bool isKeyboardActive = false;

  void toggleKeyboard() => isKeyboardActive = !isKeyboardActive;
}