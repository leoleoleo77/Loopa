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
    _name = _getDefaultName(id);
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _longPressListener = LongPressListener(onFinish: _clearLoop);
    _loopClearController = LoopClearController();
    _audioController = AudioController(loopName: _name);
    _map[id] = this;
  }

  /// - Start private methods -

  /// _clearLoop is called whenever when _longPressTimer finishes
  /// and has three cases
  /// either. The state of the loop is initial so there is no loop to clear
  /// or.     The state of the loop is either playing or idle
  ///         so clear the loop and inform the user

  void _clearLoop() {
    cancelLongPressListener();
    if (_stateNotifier.value == LoopaState.initial) return;

    _longPressListener.onClearComplete();
    _loopClearController.onClearComplete();
    _audioController.clearPlayer();
    _name = _getDefaultName(id);
  }

  bool _stateIsInitialOrRecording() {
    return _stateNotifier.value == LoopaState.initial
        || _stateNotifier.value == LoopaState.recording;
  }

  bool _isRecording() {
    return _stateNotifier.value == LoopaState.recording;
  }

  void _cancelRecording() {
    if (_isRecording()) {
      _audioController.clearRecording();
      _stateNotifier.value = LoopaState.initial;
    }
  }

  /// - Start public methods -


  /// updateState is called whenever when the pan gesture ends,
  /// during which if the loop was cleared then _clearLoop was called
  /// and _loopWasCleared was set to true, meaning that the state
  /// has already been updated and updateState needs to simply
  /// reset the _loopWasCleared flag.

  void updateState() {

    if (_loopClearController.loopWasCleared == true) {
      _stateNotifier.value = LoopaState.initial;
      _loopClearController.loopWasCleared = false;
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
        _stateNotifier.value = LoopaState.recording;
        LoopClearController.stopFlashing();
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
    if (_stateIsInitialOrRecording()) return;
    _longPressListener.start();
  }

  void cancelLongPressListener() {
    if (_stateIsInitialOrRecording()) return;
    _longPressListener.cancel();
  }

  ToolBarAnimationController getToolBarAnimationController() {
    return LongPressListener.toolBarAnimationController;
  }

  ValueNotifier<LoopaState> getStateNotifier() => _stateNotifier;

  String getName() => _name;

  void setName(String name) => _name = name;

  /// - Start static methods -
  
  static void setStartFlashingMethod(Function() function) {
    LoopClearController.startFlashing = function;
  }

  static void setStopFlashingMethod(Function() function) {
    LoopClearController.stopFlashing = function;
  }

  static String _getDefaultName(int i) {
    return "LOOP_$i";
  }

  static String getNameFromMap(int key) {
    return _map[key]?._name ?? _getDefaultName(key);
  }

  static LoopaState getStateFromMap(int key) {
    return _map[key]?.getStateNotifier().value ?? LoopaState.initial;
  }

  static void setLoopaNotifier(ValueNotifier<Loopa> loopaNotifier) {
    _loopaNotifier = loopaNotifier;
  }

  static void handleOnLoopaChange(int? id) {
    if (id == null) return;

    if (_loopaNotifier.value.id == id) return;

    _loopaNotifier.value._cancelRecording();
    LoopClearController.stopFlashing();

    _loopaNotifier.value = _map[id] ?? Loopa(id: id);
  }
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}