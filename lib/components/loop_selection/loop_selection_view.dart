import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_dropdown.dart';
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

  static const String _noText = "";
  late String _displayText;
  bool _textIsVisible = true;
  Timer? _flashTimer;

  void _startFlashing() {
    setState(() {
      _displayText = "CLEAR";
      _textIsVisible = !_textIsVisible;
    });
    _flashTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        setState(() {
          _textIsVisible = !_textIsVisible;
        });

        if (timer.tick == 7) {
          timer.cancel();
          _stopFlashing();
        }
      },
    );
  }

  void _stopFlashing() {
    if (_flashTimer == null) return;
    _flashTimer!.cancel();
    setState(() {
      _displayText = widget.loopa.getName();
      _textIsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _displayText = widget.loopa.getName();
    widget.loopa.setStartFlashingMethod(_startFlashing);
    widget.loopa.setStopFlashingMethod(_stopFlashing);
  }

  @override
  Widget build(BuildContext context) {
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
      width: 124,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
                scaleY: 1.5,
                child: _getGradientText(
                    text: _textIsVisible
                        ? _displayText
                        : _noText
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _getGradientText({
    required String text,
    double fontSize = 36,
  }) {
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
          text,
          style: TextStyle(
              fontFamily: 'Jersey25',
              fontSize: fontSize,
          ),
      ),
    );
  }

  List<Color> _getGradientColor() {
    // TODO: make this condition a bit clearer
    if (widget.loopa.getStateNotifier().value == LoopaState.initial
        && _displayText != "CLEAR"
    ) {
      return <Color>[
        Colors.lightGreenAccent.shade400.withOpacity(0.4),
        Colors.lightGreenAccent.shade400.withOpacity(0.4)
      ];
    } else {
      return <Color>[
        Colors.lightGreenAccent.shade400,
        Colors.lightGreenAccent.shade700
      ];
    }
  }
}



