import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_bloc.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt mGetIt = GetIt.instance;

Future<void> setupLocator() async {

  // Register SharedPreferences as a singleton
  mGetIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());

  mGetIt.registerSingleton<ToolBarAnimationBloc>(ToolBarAnimationBloc());

  mGetIt.registerSingleton<ValueNotifier<Loopa>>(ValueNotifier<Loopa>(Loopa.getLoopaFromMap(0)));
}