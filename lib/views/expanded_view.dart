import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loopa/components/loop_button.dart';
import 'package:loopa/components/loop_selection/loop_selection_view.dart';
import 'package:loopa/components/play_rec_lights.dart';
import 'package:loopa/components/play_span_slider.dart';
import 'package:loopa/components/save_loopa_button.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class ExpandedView extends StatelessWidget {
  final VoidCallback onToolbarPressed;
  final Loopa loopa;

  const ExpandedView({
    super.key,
    required this.onToolbarPressed,
    required this.loopa
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getExpandedMenu(),
        const SizedBox(height: LoopaSpacing.spacing8),
        LoopButton(
          largeState: false,
          loopa: loopa,
          isKeyboardActive: false,
        )
      ],
    );
  }

  Widget _getExpandedMenu() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: LoopaPadding.horizontal8,
            child: Container(
                height: LoopaSpacing.expandedMenuHeight,
                decoration: _getExpandedViewBoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getPlayRecLightsAndLoopaSelection(),
                    RangeSliderExample(),// temp
                    _getToggleExpandButton()
                  ],
                ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPlayRecLightsAndLoopaSelection() {
    return Padding(
      padding: LoopaPadding.expandedToolBarPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: LoopaSpacing.expandedToolBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlayRecLights(
                    loopaStateNotifier: loopa.getStateNotifier()
                ),
                LoopSelectionView(
                  loopa: loopa,
                  compactView: false,
                  toggleKeyboardNotifier: () {},
                )
              ],
            ),
          ),
          SaveLoopaButton(loopa: loopa)
        ],
      ),
    );
  }

  // TODO: make this nice and add semantics
  Widget _getToggleExpandButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onToolbarPressed,
        child: SizedBox(
          height: 44,
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(24, 24, 24, 1),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(21, 21, 21, 1),
                //     spreadRadius: 1,
                //     blurRadius: 10,
                //   ),
                // ],
                // gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [
                //       Color.fromRGBO(28, 28, 28, 1),
                //       Color.fromRGBO(24, 24, 24, 1),
                //       Color.fromRGBO(24, 24, 24, 1),
                //       Color.fromRGBO(21, 21, 21, 1),
                //     ]
                // ),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4),
                    bottom: Radius.circular(8)
                )
            ),
            child: const Icon(
              Icons.menu_rounded,
              size: 32,
              color: LoopaColors.softGrey
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getExpandedViewBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: LoopaColors.expandedMenuBackgroundGradient,
      ),
      borderRadius: LoopaBorderRadius.circularBorder12
    );
  }
}