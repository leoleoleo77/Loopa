import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

import 'save_loopa_button_event.dart';
import 'save_loopa_button_state.dart';

class SaveLoopaButtonBloc extends Bloc<SaveLoopaButtonEvent, SaveLoopaButtonState> {
  SaveLoopaButtonBloc() : super(SaveLoopaButtonInitialState()) {
    on<SaveLoopaButtonSaveLoopaEvent>(_handleSaveLoopaEvent);
    on<SaveLoopaButtonLoopaChangedEvent>(_handleChangedEvent);
  }

  Future<void> _handleSaveLoopaEvent(
      SaveLoopaButtonSaveLoopaEvent event,
      Emitter<SaveLoopaButtonState> emit
  ) async {
    await mGetIt.get<ValueNotifier<Loopa>>().value.handleSave();
    bool isLoopaSaved =
        mGetIt.get<ValueNotifier<Loopa>>().value.saveNotifier.value;

    emit(SaveLoopaButtonPopulateState(isLoopaSaved: isLoopaSaved));
  }

  Future<void> _handleChangedEvent(
      SaveLoopaButtonLoopaChangedEvent event,
      Emitter<SaveLoopaButtonState> emit
  ) async {
    bool isLoopaSaved =
        mGetIt.get<ValueNotifier<Loopa>>().value.saveNotifier.value;

    emit(SaveLoopaButtonPopulateState(isLoopaSaved: isLoopaSaved));
  }

}