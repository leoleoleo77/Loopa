import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ScreenDimensions {
  static late final double _width;
  static late final double _height;

  static init() {
    FlutterView view =
        WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio; //.dp

    _width = size.width;
    _height = size.height;
  }

  static double get width => _width;

  static double get height => _height;
}