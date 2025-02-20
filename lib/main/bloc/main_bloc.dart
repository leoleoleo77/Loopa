import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loopa/main/bloc/main_event.dart';
import 'package:loopa/main/bloc/main_state.dart';
import 'package:loopa/utils/general_utils/permission_handler.dart';
import 'package:loopa/utils/general_utils/screen_size.dart';
import 'package:loopa/utils/log_utils/log_helper.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  bool _expandedState = false;

  MainBloc() : super(MainLoadingState()) {
    on<MainToggleFinishLoadingEvent>(_handleFinishLoadingEvent);
    on<MainToggleExpandedStateEvent>(_handleExpandedStateEvent);
  }

  void init() async {
    PermissionHandler.requestPermissions();
    Loopa.initializeLoopasFromMemory();
    Log.initializeFirebase();
    ScreenDimensions.init();

    add(MainToggleFinishLoadingEvent());
  }

  void _handleFinishLoadingEvent(
      MainToggleFinishLoadingEvent event,
      Emitter<MainState> emit
  ) {
    FlutterNativeSplash.remove();
    emit(MainDisplayState(expandedState: _expandedState));
  }

  void _handleExpandedStateEvent(
      MainToggleExpandedStateEvent event,
      Emitter<MainState> emit
  ) {
    _expandedState = !_expandedState;
    emit(MainDisplayState(expandedState: _expandedState));
  }
}