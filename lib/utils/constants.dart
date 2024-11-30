import 'package:flutter/material.dart';

class LoopaColors {
  static const Color softGrey = Colors.white70;
  static List<Color> idleGreenGradient = <Color>[
    Colors.lightGreenAccent.shade400.withOpacity(0.4),
    Colors.lightGreenAccent.shade400.withOpacity(0.4)
  ];
  static List<Color> activeGreenGradient = <Color>[
    Colors.lightGreenAccent.shade400,
    Colors.lightGreenAccent.shade700
  ];
}

class LoopaText {
  static const String play = "PLAY";
  static const String rec = "REC";
  static const String clear = "CLEAR";
  static const String noText = "";
  static const String memory = "Memory";
}

class LoopaFont {
  static const String retro = 'Jersey25';
}