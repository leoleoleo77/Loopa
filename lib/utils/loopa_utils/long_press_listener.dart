import 'dart:async';
import 'package:loopa/utils/loopa_utils/tool_bar_animation_controller.dart';

class LongPressListener {
  late Timer? _timer;
  late final Function() onFinish;
  static final ToolBarAnimationController toolBarAnimationController =
    ToolBarAnimationController();
  static const int longPressDurationSeconds = 2;
  static const int longPressDurationMilliseconds =
      longPressDurationSeconds * 1000;

  LongPressListener({
   required this.onFinish,
 });

 void start() {
   _timer = Timer(
       const Duration(seconds: longPressDurationSeconds),
       onFinish
   );
   toolBarAnimationController.startExpanding!();
 }

 void cancel() {
   _timer?.cancel();
   _timer = null; // Reset the timer
   toolBarAnimationController.stopExpanding!();

 }

 void onClearComplete() {
   toolBarAnimationController.onComplete!();
 }
}
