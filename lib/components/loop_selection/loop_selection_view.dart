import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_dropdown.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionView extends StatefulWidget {
  final Loopa loopa;
  final bool compactView;

  const LoopSelectionView({
    super.key,
    required this.loopa,
    this.compactView = true,
  });

  @override
  State<LoopSelectionView> createState() => _LoopSelectionViewState();
}

class _LoopSelectionViewState extends State<LoopSelectionView> {

  bool _textIsVisible = true;
  Timer? _flashTimer;

  void _startFlashing() {
    _toggleDisplayTextVisibility();
    _flashTimer = Timer.periodic(
      LoopaDuration.milliseconds500,
      (timer) {
        _toggleDisplayTextVisibility();
        if (timer.tick == 7) {
          timer.cancel();
          _stopFlashing();
        }
      },
    );
  }

  void _stopFlashing() {
    if (_flashTimer == null) return;
    _flashTimer?.cancel();
    setState(() {
      _textIsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Loopa.setStartFlashingMethod(_startFlashing);
    Loopa.setStopFlashingMethod(_stopFlashing);
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LoopaPadding.vertical12,
      child: LoopSelectionDropdown(
        dropdownBuilder: _getSelectedItem(),
      )
    );
  }

  Widget _getSelectedItem() {
    return Container(
      color: Colors.black,
      width: widget.compactView ? 132 : 200,
      height: double.infinity,
      child: Padding(
        padding: LoopaPadding.top16,
        child: Row(
          mainAxisAlignment: widget.compactView ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getGradientText(
              _getDisplayText(),
              LoopaFontSize.fontSize36,
            ),
            _getMemoryInfoText(),
          ],
        ),
      ),
    );
  }

  Widget _getMemoryInfoText() {
    if (widget.compactView) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getGradientText(
          LoopaText.memory,
          LoopaFontSize.fontSize18,
        ),
        _getGradientText(
            widget.loopa.id.toString(),
            LoopaFontSize.fontSize20,
        ),
      ],
    );
  }

  Widget _getGradientText(
      String text,
      double fontSize,
  ) {
    return Transform.scale(
      scaleY: 1.5,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: _getGradientColor()
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        child: Text(
            text,
            style: TextStyle(
                fontFamily: LoopaFont.retro,
                fontSize: fontSize,
                height: 1
            ),
        ),
      ),
    );
  }

  List<Color> _getGradientColor() {
    bool loopaStateIsInitial = widget.loopa.getStateNotifier().value == LoopaState.initial;
    bool isFlashing = !(_flashTimer?.isActive == true);

    if (loopaStateIsInitial && isFlashing) {
      return LoopaColors.idleGreenGradient;
    } else {
      return LoopaColors.activeGreenGradient;
    }
  }

  void _toggleDisplayTextVisibility() {
    setState(() {
      _textIsVisible = !_textIsVisible;
    });
  }

  String _getDisplayText() {
    if (_flashTimer?.isActive == true) {
      if (_textIsVisible) {
        return LoopaText.clear;
      } else {
        return LoopaText.noText;
      }
    } else {
      return widget.loopa.getName();
    }
  }
}



