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
      const Duration(milliseconds: 500),
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
    // _displayText = widget.loopa.getName();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: LoopSelectionDropdown(
        dropdownBuilder: _getSelectedItem(),
      )
    );
  }

  Widget _getSelectedItem() {
    return Container(
      color: Colors.black,
      width: 132,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
                scaleY: 1.5,
                child: _getGradientText()
            )
          ],
        ),
      ),
    );
  }

  Widget _getGradientText() {

    String displayText;
    if (_flashTimer?.isActive == true) {
      if (_textIsVisible) {
        displayText = LoopaText.clear;
      } else {
        displayText = LoopaText.noText;
      }
    } else {
      displayText = widget.loopa.getName();
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: _getGradientColor()
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
          displayText,
          style: const TextStyle(
              fontFamily: LoopaFont.retro,
              fontSize: 36,
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
}



