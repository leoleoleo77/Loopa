import 'package:flutter/material.dart';

class LoopSelectionItem extends StatelessWidget {
  final bool compactView;

  const LoopSelectionItem({
    super.key,
    this.compactView = true
  });

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
                child: _getGradientText("LOOP_0", 36)
              ),
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

  Widget _getGradientText(
      String text,
      double fontSize,
  ) {
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