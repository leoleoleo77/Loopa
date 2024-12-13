import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_view.dart';
import 'package:loopa/components/play_rec_lights.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class ToolBar extends StatefulWidget {
  final Loopa loopa;
  final VoidCallback onToolbarPressed;
  final VoidCallback toggleKeyboardNotifier;

  const ToolBar({
    super.key,
    required this.loopa,
    required this.onToolbarPressed,
    required this.toggleKeyboardNotifier
  });

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Semantics.fromProperties(
      properties: LoopaSemantics.toolBarSemantics,
      child: Padding(
        padding: LoopaPadding.horizontal16,
        // TODO: fix the detector hitbox
        child: GestureDetector(
          onTap: widget.onToolbarPressed,
          child: Container(
              width: double.infinity,
              height: LoopaSpacing.toolBarHeight,
              decoration: _getBoxDecoration(),
              child: Stack(
                children: [
                  ToolBarAnimation(
                    animationController: widget.loopa.getToolBarAnimationController(),
                  ),
                  Padding(
                    padding: LoopaPadding.horizontal16,
                    child: Row(
                      children: [
                        PlayRecLights(loopaStateNotifier: widget.loopa.getStateNotifier()),
                        const Spacer(),
                        LoopSelectionView(
                            loopa: widget.loopa,
                            toggleKeyboardNotifier: widget.toggleKeyboardNotifier,
                        )
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: LoopaColors.toolBarBackgroundGradient,
      ),
      borderRadius: LoopaBorderRadius.circularBorder12
    );
  }
}
