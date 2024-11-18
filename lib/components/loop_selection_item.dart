import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionItem extends StatefulWidget {
  final Loopa loopa;
  final bool compactView;

  const LoopSelectionItem({
    super.key,
    required this.loopa,
    this.compactView = true,
  });

  @override
  State<LoopSelectionItem> createState() => _LoopSelectionItemState();
}

class _LoopSelectionItemState extends State<LoopSelectionItem> {

  static const String _noText = "";
  late String _displayText;
  bool _textIsVisible = true;
  Timer? _temp;

  void _startFlashing(Timer? flashTimer) {
    setState(() {
      _displayText = "CLEAR";
      _textIsVisible = !_textIsVisible;
    });
    _temp = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        setState(() {
          _textIsVisible = !_textIsVisible; // Toggle visibility
        });

        if (timer.tick == 7) {
          timer.cancel();
          _stopFlashing();
        }
      },
    );
  }

  void _stopFlashing() {
    if (_temp == null) return;
    _temp!.cancel();
    setState(() {
      _displayText = widget.loopa.getName();
      _textIsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _displayText = widget.loopa.getName();
    widget.loopa.setNameFlashingMethod(_startFlashing);
    widget.loopa.setNameFlashingOnCancelMethod(_stopFlashing);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
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
                // ValueListenableBuilder<LoopaState>(
                //     valueListenable: widget.loopa.getStateNotifier(),
                //     builder: (context, loopaState, child) {
                //       if (loopaState == LoopaState.initial) {
                //         _displayText = "CLEAR";
                //         _startFlashing(_displayText);
                //       } else {
                //         _displayText = widget.loopa.getName();
                //       }
                //       return _getGradientText(
                //           text: _textIsVisible
                //               ? _displayText
                //               : _noText
                //       );
                //     }
                )
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Transform.scale(
              //       scaleY: 2.0,
              //       child: Text(
              //           "Memory",
              //         style: TextStyle(
              //             fontFamily: 'Jersey25',
              //             color: Colors.white,
              //             fontSize: 16
              //         ),
              //       ),
              //     ),
              //     Transform.scale(
              //       scaleY: 2.0,
              //       child: Text(
              //           "99",
              //         style: TextStyle(
              //             fontFamily: 'Jersey25',
              //             color: Colors.white,
              //             fontSize: 16
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
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
        return LinearGradient(colors: [
          Colors.lightGreenAccent.shade400,
          Colors.lightGreenAccent.shade700,
        ]).createShader(
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
}