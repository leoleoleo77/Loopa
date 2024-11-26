import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/loop_selection_item_model.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionItem extends StatelessWidget {
  final LoopSelectionItemModel model;

  const LoopSelectionItem({
    super.key,
    required this.model
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
                child: _getGradientText(text: model.name)
            ),
          ),
          const SizedBox(width: 8),
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
                    text: model.id.toString(),
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
    if (model.state == LoopaState.initial) {
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