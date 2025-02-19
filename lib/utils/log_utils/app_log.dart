import 'package:flutter/foundation.dart';

/// source: https://stackoverflow.com/a/78452373/14656077

class DebugLog {
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

  static void firebaseEvent(
      String name,
      Map<String, Object> parameters
  ) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('\x1B[33mFirebase Event: $name\x1B[0m'); // Blue color
    buffer.writeln('\x1B[32mParameters:\x1B[0m'); // Green color

    parameters.forEach((key, value) {
      buffer.writeln('  - \x1B[36m$key\x1B[0m: \x1B[35m$value\x1B[0m'); // Cyan key, Magenta value
    });

    debugPrint(buffer.toString());

  }
}