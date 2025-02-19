import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_event.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/keyboard_controller.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';


class LoopSelectionItemBloc extends Bloc<LoopSelectionItemEvent, LoopSelectionItemState> {
  static const int timerTicks = 7;

  FocusNode? _textFieldFocusNode;
  Timer? _flashingTimer;
  bool _nameNotChanged = true;

  LoopSelectionItemBloc() : super(LoopSelectionItemState()) {
    on<LoopSelectionItemOpenKeyboardEvent>(_handleOpenKeyboardEvent);
    on<LoopSelectionItemCloseKeyboardEvent>(_handleCloseKeyboardEvent);
    on<LoopSelectionItemKeyboardInputEvent>(_handleKeyboardInputEvent);
    on<LoopSelectionItemStartFlashingEvent>(_handleStartFlashingEvent);
    on<LoopSelectionItemStopFlashingEvent>(_handleStopFlashingEvent);
    on<LoopSelectionItemToggleNameVisibilityEvent>(_handleToggleNameVisibilityEvent);
    on<LoopSelectionItemToggleMemoryIdAsteriskEvent>(_handleToggleMemoryIdAsteriskEvent);
  }

  void _handleOpenKeyboardEvent(
      LoopSelectionItemOpenKeyboardEvent event,
      Emitter<LoopSelectionItemState> emit
  ) {
    _textFieldFocusNode = FocusNode()..requestFocus();
    KeyboardController.isKeyboardActive = true;

    emit(state.copyWith(textFieldFocusNode: _textFieldFocusNode));
  }

  void _handleCloseKeyboardEvent(
      LoopSelectionItemCloseKeyboardEvent event,
      Emitter<LoopSelectionItemState> emit
  ) {
    final loopa = mGetIt.get<ValueNotifier<Loopa>>().value;

    if (loopa.name == LoopaText.noText) loopa.setDefaultName();
    KeyboardController.isKeyboardActive = false;
    _textFieldFocusNode?.unfocus();
    _nameNotChanged = true;

    emit(state.copyWith(
        displayName: loopa.name,
        textFieldFocusNode: _textFieldFocusNode
    ));
  }

  void _handleKeyboardInputEvent(
      LoopSelectionItemKeyboardInputEvent event,
      Emitter<LoopSelectionItemState> emit
  ) {
    final loopa = mGetIt.get<ValueNotifier<Loopa>>().value;

    if (!_nameNotChanged) {
      loopa.name = event.text;
      emit(state.copyWith(displayName: loopa.name));
      return;
    }

    int loopaNameLength = loopa.name.length;
    int textInputLength =  event.text.length;
    bool inputWasBackspace = loopaNameLength > textInputLength;
    if (inputWasBackspace) {
      loopa.name = LoopaText.noText;
      emit(state.copyWith(displayName: LoopaText.noText));
    } else {
      String inputCharacter = event.text[textInputLength - 1];
      loopa.name = inputCharacter;
      emit(state.copyWith(displayName: inputCharacter));
    }
    _nameNotChanged = false;
  }

  Future<void> _handleStartFlashingEvent(
      LoopSelectionItemStartFlashingEvent event,
      Emitter<LoopSelectionItemState> emit
  ) async {
    add(LoopSelectionItemToggleNameVisibilityEvent(hideName: true));
    _flashingTimer = Timer.periodic(
      LoopaDuration.milliseconds500,
      (timer) {
        bool shouldShowName = timer.tick.isEven;
        add(LoopSelectionItemToggleNameVisibilityEvent(hideName: shouldShowName));
        if (timer.tick == timerTicks) timer.cancel();
      },
    );
  }

  void _handleStopFlashingEvent(
      LoopSelectionItemStopFlashingEvent event,
      Emitter<LoopSelectionItemState> emit
  ) {
    _flashingTimer?.cancel();
    add(LoopSelectionItemToggleNameVisibilityEvent(hideName: false));
  }

  void _handleToggleNameVisibilityEvent(
      LoopSelectionItemToggleNameVisibilityEvent event,
      Emitter<LoopSelectionItemState> emit
  ) {
    if (isFlashingTimerActive) {
      if (event.hideName) {
        emit(state.copyWith(displayName: LoopaText.noText));
      } else {
        emit(state.copyWith(displayName: LoopaText.clear));
      }
    } else {
      emit(state.copyWith(
          displayName: mGetIt.get<ValueNotifier<Loopa>>().value.name,
          // displayMemoryCount: mGetIt.get<ValueNotifier<Loopa>>().value.memoryCountValue
      ));
    }
  }

  void _handleToggleMemoryIdAsteriskEvent(
      LoopSelectionItemToggleMemoryIdAsteriskEvent event,
      Emitter<LoopSelectionItemState> emit
  ) {
    emit(state.copyWith(
        // displayMemoryCount: mGetIt.get<ValueNotifier<Loopa>>().value.memoryCountValue
    ));
  }

  bool get isFlashingTimerActive => _flashingTimer?.isActive == true;
}