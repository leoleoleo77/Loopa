import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_event.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class ToolBarAnimationBloc extends Bloc<ToolBarAnimationEvent, ToolBarAnimationState> {
  static const double _fullOpacity = 1;

  double? _maxWidth;
  Timer? _animationTimer;

  ToolBarAnimationBloc() : super(const ToolBarAnimationIdleState()) {
    on<ToolBarAnimationInitialEvent>(_handleInitialEvent);
    on<ToolBarAnimationLongPressStartedEvent>(_handleStartedEvent);
    on<ToolBarAnimationLongPressCanceledEvent>(_handleCanceledEvent);
    on<ToolBarAnimationLongPressCompletedEvent>(_handleCompletedEvent);
    on<ToolBarAnimationOnTickEvent>(_handleOnTickEvent);
  }

  Future<void> _handleInitialEvent(
      ToolBarAnimationInitialEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {
    _maxWidth = event.maxWidth;
    emit(const ToolBarAnimationIdleState());
  }

  Future<void> _handleStartedEvent(
      ToolBarAnimationLongPressStartedEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {
    if (mGetIt.get<ValueNotifier<Loopa>>().value.isStateInitialOrRecording) return;

    double? maxWidth = _maxWidth;
    if (maxWidth == null) return;

    final double widthPerTick = _getWidthPerTick(maxWidth);
    double animationWidth = 0;
    double animationOpacity = 0;
    _animationTimer = Timer.periodic(
        LoopaDuration.clearAnimationTickDuration,
        (_) {
          if (animationWidth < maxWidth) {
            animationWidth += widthPerTick;
          } else {
            _animationTimer?.cancel();
            add(ToolBarAnimationLongPressCompletedEvent());
            return;
          }
          if (animationWidth > maxWidth / 3) {
            animationOpacity = _fullOpacity;
          }
          add(ToolBarAnimationOnTickEvent(
              animationWidth: animationWidth,
              animationOpacity: animationOpacity));
        }
    );
  }

  Future<void> _handleOnTickEvent(
      ToolBarAnimationOnTickEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {
    emit(ToolBarAnimationExpandingState(
        animationWidth: event.animationWidth,
        animationOpacity: event.animationOpacity,
        animationDuration: _getFadeDuration(),
        animationInProgress: true
    ));
  }

  Future<void> _handleCanceledEvent(
      ToolBarAnimationLongPressCanceledEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {
    if (mGetIt.get<ValueNotifier<Loopa>>().value.isStateInitialOrRecording) return;

    _animationTimer?.cancel();
    if (state.animationInProgress) {
      emit(const ToolBarAnimationIdleState());
    }
  }

  Future<void> _handleCompletedEvent(
      ToolBarAnimationLongPressCompletedEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {
    double? maxWidth = _maxWidth;
    if (maxWidth == null) return;

    mGetIt.get<ValueNotifier<Loopa>>().value.clearLoop();

    emit(ToolBarAnimationExpandingState(
        animationWidth: maxWidth,
        animationOpacity: _fullOpacity,
        animationDuration: LoopaDuration.loopClearAnimationFadeDuration,
        animationInProgress: false
    ));
    await Future.delayed(LoopaDuration.loopClearFlashAnimationDuration)
        .whenComplete(() => emit(const ToolBarAnimationIdleState()));
  }

  double _getWidthPerTick(double maxWidth) {
    return maxWidth /
        (LoopaDuration.longPressDurationMilliseconds / LoopaConstants.clearAnimationTick);
  }

  Duration _getFadeDuration() {
    return const Duration(milliseconds: LoopaDuration.longPressDurationMilliseconds ~/ 2);
  }
}