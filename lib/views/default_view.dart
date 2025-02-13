import 'package:flutter/material.dart';
import 'package:loopa/components/loop_button.dart';
import 'package:loopa/components/tool_bar/tool_bar_item.dart';
import 'package:loopa/utils/general_utils/constants.dart';

class DefaultView extends StatefulWidget {
  final VoidCallback onToolbarPressed;

  const DefaultView({
    super.key,
    required this.onToolbarPressed,
  });

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  // TODO: register this as a singleton
  //late bool _isKeyboardActive;

  @override
  void initState() {
    super.initState();
    //_isKeyboardActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToolBar(
          onToolbarPressed: widget.onToolbarPressed,
          // toggleKeyboardNotifier: _toggleKeyboardNotifier
        ),
        _getLoopaInstructions(),
        LoopButton(
            // isKeyboardActive: _isKeyboardActive
        ),
      ],
    );
  }

  Widget _getLoopaInstructions() {
    return const Padding(
      padding: LoopaPadding.loopaInstructionsPadding,
      child: SizedBox(
        width: double.infinity,
        height: LoopaSpacing.loopaInstructionsHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(LoopaAssets.loopaLogo), // TODO: add semantics
              height: LoopaSpacing.loopaLogoHeight,
            ),
            SizedBox(height: LoopaSpacing.spacing8),
            Padding(
              padding: LoopaPadding.horizontal16,
              child: Text(
                LoopaText.clearInstruction,
                style: LoopaTextStyle.instructions
              ),
            ),
            Padding(
              padding: LoopaPadding.horizontal16,
              child: Text(
                LoopaText.playStopInstruction,
                style: LoopaTextStyle.instructions
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _toggleKeyboardNotifier() {
  //   setState(() {
  //     _isKeyboardActive = !_isKeyboardActive;
  //   });
  // }
}