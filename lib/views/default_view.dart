import 'package:flutter/material.dart';
import 'package:loopa/components/loop_button.dart';
import 'package:loopa/components/tool_bar/tool_bar_item.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class DefaultView extends StatefulWidget {
  final VoidCallback onToolbarPressed;
  final Loopa loopa;

  const DefaultView({
    super.key,
    required this.onToolbarPressed,
    required this.loopa
  });

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  late bool _isKeyboardActive;

  @override
  void initState() {
    super.initState();
    _isKeyboardActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToolBar(
          loopa: widget.loopa,
          onToolbarPressed: widget.onToolbarPressed,
          toggleKeyboardNotifier: _toggleKeyboardNotifier,
        ),
        _getLoopaInstructions(),
        LoopButton(
            loopa: widget.loopa,
            isKeyboardActive: _isKeyboardActive
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

  void _toggleKeyboardNotifier() {
    setState(() {
      _isKeyboardActive = !_isKeyboardActive;
    });
  }
}