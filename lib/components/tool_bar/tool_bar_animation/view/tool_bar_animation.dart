
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_bloc.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_event.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_state.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';

class ToolBarAnimation extends StatelessWidget {
  final bool expandedState;

  const ToolBarAnimation({
    super.key,
    this.expandedState = false
  });

  @override
  Widget build(BuildContext context) {
    // todo: remove layout builder
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocProvider.value(
          value: mGetIt.get<ToolBarAnimationBloc>()
              ..add(ToolBarAnimationInitialEvent(
                  maxWidth: constraints.maxWidth)),
          child: BlocBuilder<ToolBarAnimationBloc, ToolBarAnimationState>(
            builder: (context, state) {
              return _getAnimationContainer(state);
            },
          ),
        );
      }
    );
  }

  Widget _getAnimationContainer(
      ToolBarAnimationState state
  ) {
    return AnimatedOpacity(
      opacity: state.animationOpacity,
      duration: state.animationDuration,
      child: Container(
        width: state.animationWidth,
        decoration: state.animationInProgress
            ? _getProgressIndicatorBoxDecoration(state)
            : _getCompletionFlashBoxDecoration(),
      ),
    );
  }

  BoxDecoration _getCompletionFlashBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: LoopaColors.flashAnimationGradient
      ),
      borderRadius: LoopaBorderRadius.left12
    );
  }

  // TODO: clean up the code
  BoxDecoration _getProgressIndicatorBoxDecoration(
      ToolBarAnimationState state
  ) {
    if (expandedState) {
      return BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.withOpacity(0.2 * state.animationOpacity),
                Colors.grey.withOpacity(0.1 * state.animationOpacity),
                Colors.grey.withOpacity(0.05 * state.animationOpacity),
                Colors.grey.withOpacity(0.025 * state.animationOpacity),
                Colors.grey.withOpacity(0.01 * state.animationOpacity),
              ]),
          // borderRadius: LoopaBorderRadius.left12
      );
    } else {
      return BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.withOpacity(0.1 * state.animationOpacity),
                Colors.grey.withOpacity(0.2 * state.animationOpacity),
                Colors.grey.withOpacity(0.3 * state.animationOpacity),
              ]
          ),
          borderRadius: LoopaBorderRadius.left12
      );
    }
  }
}


