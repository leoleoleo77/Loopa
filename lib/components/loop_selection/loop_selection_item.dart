import 'package:flutter/material.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionItem extends StatelessWidget {
  final int id;

  const LoopSelectionItem({
    super.key,
    required this.id
  });

  static const double _bigFont = 36;
  static const double _mediumFont = 20;
  static const double _smallFont = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          _getEdgesCover(leftEdge: true),
          _getEdgesCover(leftEdge: false),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 124,
                child: _getGradientText(
                  text: Loopa.getNameFromMap(id),
                  fontSize: _bigFont,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getGradientText(
                      text: LoopaText.memory,
                      fontSize: _smallFont,
                  ),
                  _getGradientText(
                      text: id.toString(),
                      fontSize: _mediumFont
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getGradientText({
    required String text,
    required double fontSize,
  }) {
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
            height: 1,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColor() {
    // TODO: make this condition a bit clearer
    if (Loopa.getStateFromMap(id) == LoopaState.initial) {
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

  // Kinda disgusting but there was a 16px space in each side
  // where a ripple effect was visible when the user tapped/scrolled the loops
  // and I think this is the simplest way to solve it.
  Widget _getEdgesCover({required bool leftEdge}) {
    return Align(
      alignment: leftEdge
          ? AlignmentDirectional.bottomStart
          : AlignmentDirectional.bottomEnd,
      child: Transform.translate(
        offset: Offset(
            leftEdge ? -16 : 16,
            0
        ),
        child: Container(
          width: 16,
          height: double.infinity,
          color: Colors.black,
        ),
      ),
    );
  }
}