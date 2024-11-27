import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loopa/utils/audio_controller.dart';
import 'package:loopa/utils/long_press_listener.dart';
import 'package:loopa/utils/loop_clear_controller.dart';
import 'package:loopa/utils/tool_bar_animation_controller.dart';

class Loopa {
  static final Map<int, Loopa> _map = {};
  static late ValueNotifier<Loopa> _loopaNotifier;

  late final int id;
  late String _name;
  late final ValueNotifier<LoopaState> _stateNotifier;
  late final LongPressListener _longPressListener;
  late final LoopClearController _loopClearController;
  late final AudioController _audioController;

  Loopa({
    required this.id,
  }) {
    _name = _initialiseName();
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _longPressListener = LongPressListener(onFinish: _clearLoop);
    _loopClearController = LoopClearController();
    _audioController = AudioController(loopName: _name);
    _map[id] = this;
  }

  // TODO
  String _initialiseName() {
    return "LOOP_$id";
  }

  /// _clearLoop is called whenever when _longPressTimer finishes
  /// and has three cases
  /// case 1. The state of the loop is initial so there is no loop to clear
  /// case 2. The state of the loop is recording so stop the recording
  /// case 3. The state of the loop is either playing or idle
  ///         so clear the loop and inform the user

  void _clearLoop() {
    cancelLongPressListener();
    if (_stateNotifier.value == LoopaState.initial) return;

    _longPressListener.onClearComplete();
    _loopClearController.onClearComplete();
    if (_stateNotifier.value == LoopaState.recording) {
      _audioController.clearRecording();
    } else {
      _audioController.clearPlayer();
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
        _stateNotifier.value = LoopaState.recording;
        _loopClearController.stopFlashing();
        _audioController.startRecording();
        break;
      case LoopaState.recording:
        _stateNotifier.value = LoopaState.playing;
        _audioController.beginLooping();
        break;
      case LoopaState.playing:
        _stateNotifier.value = LoopaState.idle;
        _audioController.stopPlayer();
        break;
      case LoopaState.idle:
        _stateNotifier.value = LoopaState.playing;
        _audioController.startPlaying();
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

  static String getNameFromMap(int key) {
    return _map[key]?._name ?? "LOOP_$key";
  }

  static LoopaState getStateFromMap(int key) {
    return _map[key]?.getStateNotifier().value ?? LoopaState.initial;
  }

  static void setLoopaNotifier(ValueNotifier<Loopa> loopaNotifier) {
    _loopaNotifier = loopaNotifier;
  }

  LoopClearController getClearListener() => _loopClearController;
  
  void setStartFlashingMethod(Function() function) {
    _loopClearController.startFlashing = function;
  }

  void setStopFlashingMethod(Function() function) {
    _loopClearController.stopFlashing = function;
  }

  static void handleOnLoopaChange(int? id) {
    if (id == null) return;
    if (_loopaNotifier.value.id == id) return;

    _loopaNotifier.value = _map[id] ?? Loopa(id: id);
  }
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}