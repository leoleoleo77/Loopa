import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoopaColors {
  static const Color softGrey = Colors.white70;
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static Color inactiveRecLightRed = Colors.red.withOpacity(0.15);
  static Color inactivePlayLightGreen = Colors.green.withOpacity(0.1);
  static const Color playRecLightBackground = Color.fromRGBO(21, 21, 21, 1);

  static List<Color> idleGreenGradient = <Color>[
    Colors.lightGreenAccent.shade400.withOpacity(0.4),
    Colors.lightGreenAccent.shade400.withOpacity(0.4)
  ];
  static List<Color> activeGreenGradient = <Color>[
    Colors.lightGreenAccent.shade400,
    Colors.lightGreenAccent.shade700
  ];
  static List<Color> toolBarBackgroundGradient = <Color>[
    const Color.fromRGBO(21, 21, 21, 1),
    const Color.fromRGBO(24, 24, 24, 1),
    const Color.fromRGBO(31, 31, 31, 1)
  ];
  static List<Color> expandedMenuBackgroundGradient = [
    const Color.fromRGBO(21, 21, 21, 1),
    const Color.fromRGBO(24, 24, 24, 1),
    const Color.fromRGBO(24, 24, 24, 1),
    const Color.fromRGBO(28, 28, 28, 1),
    const Color.fromRGBO(31, 31, 31, 1)
  ];
  static List<Color> flashAnimationGradient = [
    Colors.grey.withOpacity(0.1),
    Colors.grey.withOpacity(0.2),
    Colors.grey.withOpacity(0.3),
  ];
}

class LoopaText {
  static const String play = "PLAY";
  static const String rec = "REC";
  static const String clear = "CLEAR";
  static const String noText = "";
  static const String memory = "Memory";
  static const String clearInstruction = "CLEAR: PRESS & HOLD";
  static const String playStopInstruction = "START/STOP: PRESS ONCE";
}

class LoopaFont {
  static const String retro = 'Jersey25';
}

class LoopaTextStyle {
  static const TextStyle instructions = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14
  );
  static const TextStyle menuLabels = TextStyle(
    color: LoopaColors.softGrey,
    fontSize: 12,
  );
}

class LoopaAssets {
  static const String note1 = "assets/note1.svg";
  static const String note2 = "assets/note2.svg";
  static const String largePressed =  "assets/large_pressed.jpg";
  static const String largeIdle =  "assets/large_idle.jpg";
  static const String smallPressed =  "assets/small_pressed.jpg";
  static const String smallIdle =  "assets/small_idle.jpg";
  static const String loopaLogo = 'assets/loopa_logo.png';
}

class LoopaSpacing {
  static const double toolBarHeight = 92;
  static const double expandedMenuHeight = 600;
  static const double selectionItemNameWidth = 124;
  static const double dancingNoteWidth = 40;
  static const double dancingNoteHeight = 40;
  static const double loopaInstructionsHeight = 128;
  static const double loopaLogoHeight = 72;
  static const double spacing8 = 8;
  static const double spacing4 = 4;
}

class LoopaPadding {
  static const EdgeInsets horizontal16 =  EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontal8 =  EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets vertical12 =  EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets top8 =  EdgeInsets.only(top: 8.0);
  static const EdgeInsets top16 =  EdgeInsets.only(top: 16.0);
  static const EdgeInsets loopaInstructionsPadding = EdgeInsets.fromLTRB(16, 16, 16, 8);
}

class LoopaDuration {
  static const Duration milliseconds500 = Duration(milliseconds: 500);
  static const Duration clearAnimationTickDuration = Duration(milliseconds: 16);
  static const Duration zero = Duration.zero;
  static const Duration loopClearAnimationFadeDuration = Duration(milliseconds: 200);
  static const Duration loopClearFlashAnimationDuration = Duration(milliseconds: 300);
}

class LoopaFontSize {
  static const double fontSize36 = 36;
  static const double fontSize20 = 20;
  static const double fontSize18 = 18;
}

class LoopaBorderRadius {
  static BorderRadius circularBorder12 = BorderRadius.circular(12.0);
  static const BorderRadius left12 = BorderRadius.horizontal(
      left: Radius.circular(12.0)
  );
}

class LoopaConstants {
  static const double playRecLightsRadius = 20;
  static const double clearAnimationTick = 16;
  static const int loopaCount = 100;
}

class LoopaSemantics {
  static const SemanticsProperties loopButtonSemantics = SemanticsProperties(
    label: "Main loop button",
    tooltip: "Press once to record audio, then press it again to play and loop the recorded audio. Afterwards press once again to pause the audio or press and hold it to clear the loop",
    button: true,
  );
  static const SemanticsProperties toolBarSemantics = SemanticsProperties(
    label: "Loopa's toolbar",
    button: true,
  );
}