import 'dart:async';
import 'package:loopa/utils/tool_bar_animation_controller.dart';

class LongPressListener {
  late Timer? _timer;
  late Function() onFinish;
  static final ToolBarAnimationController toolBarAnimationController =
    ToolBarAnimationController();

  LongPressListener({
   required this.onFinish,
 });

 void start() {
   _timer = Timer(
       const Duration(seconds: 2),
       onFinish
   );

   if (toolBarAnimationController.isInitialized()) {
     toolBarAnimationController.startExpanding!();
   }
 }

 void cancel() {
   _timer?.cancel();
   _timer = null; // Reset the timer

   if (toolBarAnimationController.isInitialized()) {
     toolBarAnimationController.stopExpanding!();
   }
 }
}
