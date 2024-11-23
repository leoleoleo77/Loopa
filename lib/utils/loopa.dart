import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loopa/utils/audio_controller.dart';
import 'package:loopa/utils/long_press_listener.dart';
import 'package:loopa/utils/loop_clear_controller.dart';
import 'package:loopa/utils/permission_handler.dart';
import 'package:loopa/utils/tool_bar_animation_controller.dart';

class Loopa {
  static int _count = 0;
  static const PermissionHandler _permissionHandler = PermissionHandler();

  late String _name;
  late final int _id;
  late final ValueNotifier<LoopaState> _stateNotifier;
  late final LongPressListener _longPressListener;
  late final LoopClearController _loopClearController;
  late final AudioController _audioController;

  Loopa() {
    _id = _count;
    _name = _initialiseName();
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _longPressListener = LongPressListener(onFinish: _clearLoop);
    _loopClearController = LoopClearController();
    _audioController = AudioController(loopName: _name);
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
    if (_stateNotifier.value == LoopaState.initial) return;

    _longPressListener.onClearComplete();
    _loopClearController.onClearComplete();
    if (_stateNotifier.value == LoopaState.recording) {
      // recording cleared
    } else {
      //_audioController.clearPlayer();
    }
    _stateNotifier.value = LoopaState.initial;
  }

  /// - Start public methods -


  /// updateState is called whenever when the pan gesture ends,
  /// during which if the loop was cleared then _clearLoop was called
  /// and _loopWasCleared was set to true, meaning that the state
  /// has already been updated and updateState needs to simply
  /// reset the _loopWasCleared flag.

  //TODO: fix small state bug
  void updateState() {

    if (_loopClearController.wasCleared()) {
      _stateNotifier.value = LoopaState.initial;
      _loopClearController.setWasCleared(false);
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
        _stateNotifier.value = LoopaState.recording;
        _loopClearController.stopFlashing();
        //_audioController.initPlayer();
        break;
      case LoopaState.recording:
        _stateNotifier.value = LoopaState.playing;
        break;
      case LoopaState.playing:
        _stateNotifier.value = LoopaState.idle;
        //_audioController.stopPlayer();
        break;
      case LoopaState.idle:
        //_audioPlayer.play();
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

  static void requestPermissions() {
    _permissionHandler.requestAudioPermissions();
  }
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}