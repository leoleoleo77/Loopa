import 'dart:async';

import 'package:flutter/foundation.dart';

/// source: https://stackoverflow.com/a/78452373/14656077

class AppLog {
  ///Method for log as error
  static void error(dynamic message) {
    if (kDebugMode) {
      debugPrint(
        '\x1B[31mAppError: ${message == null ? '' : message.toString()}\x1B[0m',
      );
    }
  }

  ///Method for log as info
  static void info(dynamic message) {
    if (kDebugMode) debugPrint('\x1B[34mAppInfo: $message\x1B[0m');
  }

  ///Method for log as warning
  static void warning(dynamic message) {
    if (kDebugMode) {
      debugPrint('\x1B[33mAppWarning: $message\x1B[0m');
    }
  }
}