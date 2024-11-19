import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loopa/utils/long_press_listener.dart';
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

  static const int _tickRate = 16;
  double _containerWidth = 0;
  double _progressIndicatorOpacity = 0;
  bool _showCompletionFlash = false;
  late Timer _timer;

  void _startExpanding(double? maxWidth) {
    if (maxWidth == null) return;
    final double widthPerTick = _getWidthPerTick(maxWidth);
    _timer = Timer.periodic(
        const Duration(milliseconds: _tickRate),
        (_) => _onTick(maxWidth, widthPerTick)
    );
  }

  void _onTick(double maxWidth, double widthPerTick) {
    setState(() {
      if (_containerWidth < maxWidth) {
        _containerWidth += widthPerTick;
      } else {
        // This is never executed
        _timer.cancel();
      }
      if (_containerWidth > maxWidth / 3) {
        _progressIndicatorOpacity = 1;
      }
    });
  }

  void _stopExpanding() {
    _timer.cancel();
    setState(() {
      _containerWidth = 0;
      _progressIndicatorOpacity = 0;
    });
  }

  void _onComplete() {
    _showCompletionFlash = true;
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showCompletionFlash = false;
      });
    });
  }

  double _getWidthPerTick(double maxWidth) {
    return maxWidth /
        (LongPressListener.longPressDurationMilliseconds / _tickRate);
  }

  @override
  void dispose() {
    _timer.cancel();
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
            .setStopExpanding(() => _stopExpanding())
            .setOnComplete(() => _onComplete());

        return AnimatedOpacity(
          opacity: _progressIndicatorOpacity,
          duration: Duration(milliseconds: _getFadeDuration()),
          child: Container(
            width: _containerWidth,
            alignment: Alignment.center,
            decoration: _getProgressIndicatorBoxDecoration(),
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
        decoration: _getCompletionFlashBoxDecoration(),
      ),
    );
  }

  // TODO: make this nice
  BoxDecoration _getCompletionFlashBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.3),
          ]
      ),
      borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(12.0)
      ),
    );
  }

  BoxDecoration _getProgressIndicatorBoxDecoration() {
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

  int _getFadeDuration() {
    return LongPressListener.longPressDurationMilliseconds ~/ 2;
  }
}


