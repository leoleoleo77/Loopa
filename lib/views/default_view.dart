import 'package:flutter/material.dart';
import 'package:loopa/components/loop_button.dart';
import 'package:loopa/components/tool_bar/tool_bar_item.dart';
import 'package:loopa/utils/loopa.dart';

class DefaultView extends StatelessWidget {
  final VoidCallback onToolbarPressed;
  final Loopa loopa;

  const DefaultView({
    super.key,
    required this.onToolbarPressed,
    required this.loopa
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToolBar(
          loopa: loopa,
          onToolbarPressed: onToolbarPressed
        ),
        _getLoopaInstructions(),
        LoopButton(loopa: loopa),
      ],
    );
  }

  Widget _getLoopaInstructions() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 8.0,
          left: 16.0,
          right: 16.0
      ),
      child: SizedBox(
        width: double.infinity,
        height: 128,
        //color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage('assets/loopa_temp2.png'), // TODO
              height: 72,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "CLEAR: PRESS & HOLD",
                style: _getInstructionsTextStyle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "START/STOP: PRESS ONCE",
                style: _getInstructionsTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _getInstructionsTextStyle() {
    return const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14
    );
  }
}