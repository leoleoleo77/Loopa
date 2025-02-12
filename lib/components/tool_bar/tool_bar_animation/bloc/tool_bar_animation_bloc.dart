import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_event.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class ToolBarAnimationBloc extends Bloc<ToolBarAnimationEvent, ToolBarAnimationState> {
  static const double _fullyVisible = 1;
  static const double _fullyTransparent = 0;

  double? _maxWidth;
  Timer? _animationTimer;

  ToolBarAnimationBloc() : super(const ToolBarAnimationIdleState()) {
    on<ToolBarAnimationInitialEvent>(_handleInitialEvent);
    on<ToolBarAnimationLongPressStartedEvent>(_handleStartedEvent);
    on<ToolBarAnimationLongPressEndedEvent>(_handleEndedEvent);
    on<ToolBarAnimationDeleteCompletedEvent>(_handleDeleteCompletedEvent);
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
    double animationOpacity = _fullyTransparent;
    _animationTimer = Timer.periodic(
        LoopaDuration.clearAnimationTickDuration,
        (_) {
          if (animationWidth < maxWidth) {
            animationWidth += widthPerTick;
          } else {
            _animationTimer?.cancel();
            add(ToolBarAnimationDeleteCompletedEvent());
            return;
          }
          if (animationWidth > maxWidth / 3) {
            animationOpacity = _fullyVisible;
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
        animationInProgress: true));
  }

  Future<void> _handleEndedEvent(
      ToolBarAnimationLongPressEndedEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {

    if (!event.isCancelEvent) {
      mGetIt.get<ValueNotifier<Loopa>>().value.updateState();
    }

    if (mGetIt.get<ValueNotifier<Loopa>>().value.isStateInitialOrRecording) return;

    _animationTimer?.cancel();
    if (state.animationInProgress) {
      emit(const ToolBarAnimationIdleState());
    }
  }

  Future<void> _handleDeleteCompletedEvent(
      ToolBarAnimationDeleteCompletedEvent event,
      Emitter<ToolBarAnimationState> emit
  ) async {
    double? maxWidth = _maxWidth;
    if (maxWidth == null) return;
    mGetIt.get<ValueNotifier<Loopa>>().value.clearLoop();

    emit(ToolBarAnimationExpandingState(
        animationWidth: maxWidth,
        animationOpacity: _fullyVisible,
        animationDuration: LoopaDuration.loopClearAnimationFadeDuration,
        animationInProgress: false));

    // Wait a little before starting fade-out
    await Future.delayed(LoopaDuration.loopClearFlashAnimationDuration);

    // Emit fade-out state
    emit(ToolBarAnimationExpandingState(
      animationWidth: maxWidth,
      animationOpacity: _fullyTransparent,
      animationDuration: LoopaDuration.loopClearAnimationFadeDuration,
      animationInProgress: false));

    // Wait for animation to complete before setting to idle
    await Future.delayed(LoopaDuration.loopClearAnimationFadeDuration);

    // Now emit the idle state
    emit(const ToolBarAnimationIdleState());
  }

  double _getWidthPerTick(double maxWidth) {
    return maxWidth /
        (LoopaDuration.longPressDurationMilliseconds / LoopaConstants.clearAnimationTick);
  }

  Duration _getFadeDuration() {
    return const Duration(milliseconds: LoopaDuration.longPressDurationMilliseconds ~/ 2);
  }
}