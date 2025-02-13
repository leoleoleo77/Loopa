import 'package:flutter/material.dart';

class KeyboardController {
  KeyboardController();
  final ValueNotifier<bool> _keyboardNotifier = ValueNotifier<bool>(false);

  ValueNotifier<bool> get keyboardNotifier => _keyboardNotifier;
  bool get isKeyboardActive => _keyboardNotifier.value;
  set isKeyboardActive(bool value) => _keyboardNotifier.value = value;
}