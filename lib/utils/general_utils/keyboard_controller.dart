import 'package:flutter/material.dart';

class KeyboardController {
  static final ValueNotifier<bool> _keyboardNotifier = ValueNotifier<bool>(false);

  static ValueNotifier<bool> get keyboardNotifier => _keyboardNotifier;

  static bool get isKeyboardActive => _keyboardNotifier.value;

  static set isKeyboardActive(bool value) => _keyboardNotifier.value = value;
}