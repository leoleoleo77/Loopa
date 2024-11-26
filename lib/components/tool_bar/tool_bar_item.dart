import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_view.dart';
import 'package:loopa/components/play_rec_lights.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation.dart';
import 'package:loopa/utils/loopa.dart';

class ToolBar extends StatefulWidget {
  final Loopa loopa;
  final VoidCallback onToolbarPressed;

  const ToolBar({
    super.key,
    required this.loopa,
    required this.onToolbarPressed
  });

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // TODO: fix the detector hitbox
      child: GestureDetector(
        onTap: widget.onToolbarPressed,
        child: Container(
            width: double.infinity,
            height: 92,
            decoration: _getBoxDecoration(),
            child: Stack(
              children: [
                ToolBarAnimation(
                  animationController: widget.loopa.getToolBarAnimationController(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      PlayRecLights(loopaStateNotifier: widget.loopa.getStateNotifier()),
                      const Spacer(),
                      LoopSelectionView(loopa: widget.loopa)
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
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
    );
  }
}
