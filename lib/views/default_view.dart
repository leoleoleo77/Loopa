import 'package:flutter/material.dart';
import 'package:loopa/components/loop_button.dart';
import 'package:loopa/components/loop_selection_item.dart';
import 'package:loopa/components/play_rec_lights.dart';
import 'package:loopa/loopa.dart';

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
        _getToolBar(),
        _getLoopaInstructions(),
        LoopButton(updateLoopaState: loopa.updateState),
      ],
    );
  }

  Widget _getToolBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: onToolbarPressed,
        child: Container(
            width: double.infinity,
            height: 92,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(21, 21, 21, 1),
                    Color.fromRGBO(24, 24, 24, 1),
                    Color.fromRGBO(31, 31, 31, 1)
                  ]
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                PlayRecLights(
                  loopaStateNotifier: loopa.getStateNotifier()
                ),
                const Spacer(),
                const LoopSelectionItem()
              ],
            )
        ),
      ),
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
              image: AssetImage('assets/loopa_temp2.png'),
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