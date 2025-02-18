import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/view/loop_selection_item_view.dart';
import 'package:loopa/components/play_rec_lights.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/view/tool_bar_animation.dart';
import 'package:loopa/main/bloc/main_bloc.dart';
import 'package:loopa/main/bloc/main_event.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';

class ToolBar extends StatelessWidget {

  const ToolBar({ super.key });

  @override
  Widget build(BuildContext context) {
    return Semantics.fromProperties(
      properties: LoopaSemantics.toolBarSemantics,
      child: Padding(
        padding: LoopaPadding.horizontal16,
        child: GestureDetector(
          onTap: () => mGetIt.get<MainBloc>().add(MainToggleExpandedStateEvent()),
          child: Container(
              width: double.infinity,
              height: LoopaSpacing.toolBarHeight,
              decoration: _getBoxDecoration(),
              child: const Stack(
                children: [
                  ToolBarAnimation(),
                  Padding(
                    padding: LoopaPadding.defaultToolBarPadding,
                    child: Row(
                      children: [
                        PlayRecLights(),
                        Spacer(),
                        LoopSelectionView()
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
