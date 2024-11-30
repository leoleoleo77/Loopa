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

class LoopaAssets {
  static const String note1 = "assets/note1.svg";
  static const String note2 = "assets/note2.svg";
  static const String largePressed =  "assets/large_pressed.jpg";
  static const String largeIdle =  "assets/large_idle.jpg";
  static const String smallPressed =  "assets/small_pressed.jpg";
  static const String smallIdle =  "assets/small_idle.jpg";
}

class LoopaLabels {
  static const loopButton = "Main loop button. Instructions: press once to record/play audio, press & hold to clear the loop";
}