import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_event.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBarAnimationBloc extends Bloc<ToolBarAnimationEvent, ToolBarAnimationState> {
  ToolBarAnimationBloc() : super(ToolBarAnimationIdleState());

}