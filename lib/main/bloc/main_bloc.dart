import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loopa/main/bloc/main_event.dart';
import 'package:loopa/main/bloc/main_state.dart';
import 'package:loopa/utils/general_utils/permission_handler.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  bool _expandedState = false;

  MainBloc() : super(MainLoadingState()) {
    on<MainToggleFinishLoadingEvent>(_handleFinishLoadingEvent);
    on<MainToggleExpandedStateEvent>(_handleExpandedStateEvent);
  }

  void init()  {
    PermissionHandler.requestPermissions();
    Loopa.initializeLoopasFromMemory();
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