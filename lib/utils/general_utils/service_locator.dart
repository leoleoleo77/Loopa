import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_bloc.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_bloc.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_bloc.dart';
import 'package:loopa/main/bloc/main_bloc.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt mGetIt = GetIt.instance;

Future<void> setupLocator() async {

  mGetIt.registerSingleton<MainBloc>(MainBloc());

  // Register SharedPreferences as a singleton
  mGetIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());

  mGetIt.registerSingleton<ToolBarAnimationBloc>(ToolBarAnimationBloc());

  mGetIt.registerSingleton<LoopSelectionItemBloc>(LoopSelectionItemBloc());

  mGetIt.registerSingleton<WaveformBloc>(WaveformBloc());

  // Register ValueNotifier<Loopa> as a singleton and initialize it with the last visited loopa key
  mGetIt.registerSingleton<ValueNotifier<Loopa>>(
      ValueNotifier<Loopa>(Loopa.getLoopaFromMemory(key: Loopa.getLastVisitedLoopaKey)));
}