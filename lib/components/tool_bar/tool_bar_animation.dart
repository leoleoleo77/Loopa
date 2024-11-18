import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  double _containerWidth = 0;
  double _progressIndicatorOpacity = 0;
  bool _showCompletionFlash = false;
  late Timer _timer;

  void _startExpanding(double? maxWidth) {
    if (maxWidth == null) return;
    final double widthPerTick = maxWidth / 120;
    _timer = Timer.periodic(
        const Duration(milliseconds: 16), // About 60 fps
        // TODO: clean this up
        (_) {
          setState(() {
            if (_containerWidth < maxWidth) {
              _containerWidth += widthPerTick; // Increment width
            } else {
              _timer.cancel();
              // probably pass this as a method
              // _showCompletionFlash = true;
              // Timer(const Duration(seconds: 1), () {
              //   _showCompletionFlash = false;
              // });
            }
            if (_containerWidth > maxWidth / 3) {
              _progressIndicatorOpacity = 1;
            }
          });
        });
  }

  void _stopExpanding() {
    _timer.cancel();
    setState(() {
      _containerWidth = 0;
      _progressIndicatorOpacity = 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Ensure timer is canceled when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getClearProgressIndicator(),
        _getCompletionFlash()
      ],
    );
  }

  Widget _getClearProgressIndicator() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        widget.animationController
            .setStartExpanding(() => _startExpanding(maxWidth))
            .setStopExpanding(() => _stopExpanding());

        return AnimatedOpacity(
          opacity: _progressIndicatorOpacity,
          duration: const Duration(milliseconds: 1000),
          child: Container(
            width: _containerWidth,
            alignment: Alignment.center,
            decoration: _getBoxDecoration(),
          ),
        );
      },
    );
  }

  Widget _getCompletionFlash() {
    return Opacity(
      opacity: _showCompletionFlash ? 1.0 : 0.0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey.withOpacity(0.1 * _progressIndicatorOpacity),
            Colors.grey.withOpacity(0.2 * _progressIndicatorOpacity),
            Colors.grey.withOpacity(0.3 * _progressIndicatorOpacity),
          ]
      ),
      borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(12.0)
      ),
    );
  }
}


