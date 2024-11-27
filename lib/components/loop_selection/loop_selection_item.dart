import 'package:flutter/material.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionItem extends StatelessWidget {
  final int id;

  const LoopSelectionItem({
    super.key,
    required this.id
  });

  static const String _memory = "Memory";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 124,
            child: Transform.scale(
                scaleY: 1.5,
                child: _getGradientText(
                    text: Loopa.getNameFromMap(id)
                )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scaleY: 1.5,
                child: _getGradientText(
                    text: _memory,
                    fontSize: 18,
                )
              ),
              Transform.scale(
                scaleY: 1.5,
                child: _getGradientText(
                    text: id.toString(),
                    fontSize: 20
                )
              ),
            ],
          )
        ],
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
          height: 1,
          fontSize: fontSize,
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
}