import 'dart:async';

import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_event.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class LoopSelectionItemBloc extends Bloc<LoopSelectionItemEvent, LoopSelectionItemState> {

  LoopSelectionItemBloc() : super(LoopSelectionItemIdleState());
}