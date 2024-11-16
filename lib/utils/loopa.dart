import 'package:flutter/foundation.dart';
import 'package:loopa/utils/long_press_listener.dart';
import 'package:loopa/utils/tool_bar_animation_controller.dart';

class Loopa {
  static int _count = 0;

  late String _name;
  late int _id;
  late ValueNotifier<LoopaState> _stateNotifier;
  late LongPressListener _longPressListener;
  late bool _loopWasCleared;

  Loopa() {
    _id = _count;
    _name = _initialiseName();
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _longPressListener = LongPressListener(onFinish: _clearLoop);
    _loopWasCleared = false;
    _count++;
  }

  // TODO
  String _initialiseName() {
    if (_id < 10) {
      return "LOOP_0$_id";
    } else {
      return "LOOP_$_id";
    }
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

    _loopWasCleared = true;
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

    if (_loopWasCleared) {
      _loopWasCleared = false;
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
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
    _longPressListener.start();
  }

  void cancelLongPressListener() {
    _longPressListener.cancel();
  }

  ToolBarAnimationController getToolBarAnimationController() {
    return _longPressListener.toolBarAnimationController;
  }

  ValueNotifier<LoopaState> getStateNotifier() => _stateNotifier;

  String getName() => _name;
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}