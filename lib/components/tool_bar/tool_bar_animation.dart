import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/loopa_utils/long_press_listener.dart';
import 'package:loopa/utils/loopa_utils/tool_bar_animation_controller.dart';

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
  Timer? _timer;

  void _startExpanding(double? maxWidth) {
    if (maxWidth == null) return;

    final double widthPerTick = _getWidthPerTick(maxWidth);
    _timer = Timer.periodic(
        LoopaDuration.clearAnimationTickDuration,
        (_) => _onTick(maxWidth, widthPerTick)
    );
  }

  void _onTick(double maxWidth, double widthPerTick) {
    setState(() {
      if (_containerWidth < maxWidth) {
        _containerWidth += widthPerTick;
      } else {
        // This is never executed
        _timer?.cancel();
      }
      if (_containerWidth > maxWidth / 3) {
        _progressIndicatorOpacity = 1;
      }
    });
  }

  void _stopExpanding() {
    _timer?.cancel();
    setState(() {
      _containerWidth = 0;
      _progressIndicatorOpacity = 0;
    });
  }

  void _onComplete() {
    // Why doesn't this need to be inside a setState? curious.
    _showCompletionFlash = true;
    Timer(
      LoopaDuration.loopClearFlashAnimationDuration,
      () => setState(() { _showCompletionFlash = false; })
    );
  }

  double _getWidthPerTick(double maxWidth) {
    return maxWidth /
        (LongPressListener.longPressDurationMilliseconds / LoopaConstants.clearAnimationTick);
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    // TODO: make this better
    return AnimatedOpacity(
      opacity: _showCompletionFlash ? 1.0 : 0.0,
      duration: _showCompletionFlash ?
        LoopaDuration.zero :
        LoopaDuration.loopClearAnimationFadeDuration,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _getCompletionFlashBoxDecoration(),
      ),
    );
  }

  BoxDecoration _getCompletionFlashBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: LoopaColors.flashAnimationGradient
      ),
      borderRadius: LoopaBorderRadius.left12
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
      borderRadius: LoopaBorderRadius.left12
    );
  }

  int _getFadeDuration() {
    return LongPressListener.longPressDurationMilliseconds ~/ 2;
  }
}


