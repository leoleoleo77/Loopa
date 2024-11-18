import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loopa/utils/tool_bar_animation_controller.dart';

class ToolBarAnimation extends StatefulWidget {
  final ToolBarAnimationController animationController;

  const ToolBarAnimation({
    super.key,
    required this.animationController
  });

  @override
  State<ToolBarAnimation> createState() => _ToolBarAnimationState();
}

class _ToolBarAnimationState extends State<ToolBarAnimation>
    with SingleTickerProviderStateMixin {

  double _containerWidth = 0; // Initial width

  late Timer _timer;

  void _startExpanding(double? maxWidth) {
    if (maxWidth == null) return;

    _timer = Timer.periodic(
        const Duration(milliseconds: 16), // About 60 fps
        (_) {
          setState(() {
            if (_containerWidth < maxWidth) {
              _containerWidth += 5.0; // Increment width
            } else {
              _timer.cancel(); // Stop if max width is reached
            }
          });
        });
  }

  void _stopExpanding() {
    _timer.cancel();
    setState(() {
      _containerWidth = 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Ensure timer is canceled when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        widget.animationController
            .setStartExpanding(() => _startExpanding(maxWidth))
            .setStopExpanding(() => _stopExpanding());

        return Container(
          width: _containerWidth,
          height: 50.0,
          color: Colors.blue,
          alignment: Alignment.center,
        );
      },
    );
  }
}


  // BoxDecoration _getBoxDecoration2() {
  //   return BoxDecoration(
  //     gradient: LinearGradient(
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //         colors: [
  //           Colors.grey.withOpacity(0.1),
  //           Colors.grey.withOpacity(0.2),
  //           Colors.grey.withOpacity(0.3),
  //         ]
  //     ),
  //     borderRadius: BorderRadius.horizontal(
  //         left: Radius.circular(12.0)
  //     ),
  //   );
  // }

