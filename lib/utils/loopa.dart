import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loopa/utils/long_press_listener.dart';
import 'package:loopa/utils/loop_clear_controller.dart';
import 'package:loopa/utils/tool_bar_animation_controller.dart';

class Loopa {
  static int _count = 0;
  late String _name;
  late int _id;
  late ValueNotifier<LoopaState> _stateNotifier;
  late LongPressListener _longPressListener;
  late LoopClearController _loopClearController;

  Loopa() {
    _id = _count;
    _name = _initialiseName();
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _longPressListener = LongPressListener(onFinish: _clearLoop);
    _loopClearController = LoopClearController();
    _count++;
  }

  // TODO
  String _initialiseName() {
    return "LOOP_$_id";
  }

  /// _clearLoop is called whenever when _longPressTimer finishes
  /// and has three cases
  /// case 1. The state of the loop is initial so there is no loop to clear
  /// case 2. The state of the loop is recording so TODO: stop the recording
  /// case 3. The state of the loop is either playing or idle
  ///         so TODO: inform the user that the loop has been deleted

  void _clearLoop() {
    cancelLongPressListener();
    if (_stateNotifier.value == LoopaState.initial) {
      return;
    }
    _longPressListener.onClearComplete();
    _loopClearController.onStartFlashing();
    if (_stateNotifier.value == LoopaState.recording) {
      // recording cleared
    } else {
      // loop cleared
    }
    _stateNotifier.value = LoopaState.initial;
  }

  /// - Start public methods -


  /// updateState is called whenever when the pan gesture ends,
  /// during which if the loop was cleared then _clearLoop was called
  /// and _loopWasCleared was set to true, meaning that the state
  /// has already been updated and updateState needs to simply
  /// reset the _loopWasCleared flag.

  void updateState() {

    if (_loopClearController.wasCleared()) {
      _stateNotifier.value = LoopaState.initial;
      _loopClearController.setWasCleared(false);
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
        _loopClearController.onStopFlashing();
        _stateNotifier.value = LoopaState.recording;
        break;
      case LoopaState.recording:
        _stateNotifier.value = LoopaState.playing;
        break;
      case LoopaState.playing:
        _stateNotifier.value = LoopaState.idle;
        break;
      case LoopaState.idle:
        _stateNotifier.value = LoopaState.playing;
        break;
    }
  }

  void startLongPressListener() {
    if (_stateNotifier.value == LoopaState.initial) return;
    _longPressListener.start();
  }

  void cancelLongPressListener() {
    if (_stateNotifier.value == LoopaState.initial) return;
    _longPressListener.cancel();
  }

  ToolBarAnimationController getToolBarAnimationController() {
    return LongPressListener.toolBarAnimationController;
  }

  ValueNotifier<LoopaState> getStateNotifier() => _stateNotifier;
  String getName() => _name;
  LoopClearController getClearListener() => _loopClearController;
  
  void setStartFlashingMethod(Function() function) {
    _loopClearController.startFlashing = function;
  }

  void setStopFlashingMethod(Function() function) {
    _loopClearController.stopFlashing = function;
  }
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}