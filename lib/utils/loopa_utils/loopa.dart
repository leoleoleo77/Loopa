import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loopa/utils/misc_utils/app_log.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/memory_manager.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/audio_controller.dart';
import 'package:loopa/utils/loopa_utils/loop_clear_controller.dart';

class Loopa {
  static final Map<int, Loopa> _map = {};

  late final int id;
  late String _name;
  late final ValueNotifier<LoopaState> _stateNotifier;
  late final ValueNotifier<bool> _saveNotifier;
  late final LoopClearController _loopClearController;
  late final AudioController _audioController;
  bool _wasLoopaCleared = false;

  Loopa({
    required this.id,
  }) {
    _name = _getDefaultName(id);
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _saveNotifier = ValueNotifier(false);
    _loopClearController = LoopClearController();
    _audioController = AudioController(loopName: _name);
    _map[id] = this;
  }

  bool get isStateInitialOrRecording {
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

  void clearLoop() {
    if (_stateNotifier.value == LoopaState.initial) return;

    _loopClearController.onClearComplete();
    _audioController.clearPlayer();
    _name = getNameFromMap(id);
    _wasLoopaCleared = true;
    _stateNotifier.value = LoopaState.initial;
  }

  void updateState() {
    if (_wasLoopaCleared) {
      _wasLoopaCleared = false;
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
        _stateNotifier.value = LoopaState.recording;
        LoopClearController.stopFlashing();
        _audioController.startRecording();
        return;
      case LoopaState.recording:
        _stateNotifier.value = LoopaState.playing;
        _audioController.beginLooping();
        return;
      case LoopaState.playing:
        _stateNotifier.value = LoopaState.idle;
        _audioController.stopPlayer();
        return;
      case LoopaState.idle:
        _stateNotifier.value = LoopaState.playing;
        _audioController.startPlaying();
        return;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      LoopaJson.name: _name,
    };
  }

  Future<void> handleSave() async {
    if (_saveNotifier.value == false) {
      _saveNotifier.value = await MemoryManager.saveLoopa(this);
      AppLog.info("Saved Loopa ${getName()} = ${_saveNotifier.value}");
    } else {
      _saveNotifier.value = !await MemoryManager.deleteLoopa(this);
      AppLog.info("Deleted Loopa ${getName()} = ${!_saveNotifier.value}");
    }
  }

  void setValuesFromMemory(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    saveNotifier.value = true;

    setName(json[LoopaJson.name]);
  }

  ValueNotifier<LoopaState> getStateNotifier() => _stateNotifier;

  String getName() => _name;

  void setName(String name) => _name = name;

  void setDefaultName() => _name = _getDefaultName(id);

  ValueNotifier<bool> get saveNotifier => _saveNotifier;

  bool get isSaved => _saveNotifier.value;

  String get memoryCountValue {
    return isSaved ? "$id*" : "$id";
  }

  bool get wasLoopaCleared => _wasLoopaCleared;

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

  static String getMemoryCountValueFromMap(int key) {
    return _map[key]?.memoryCountValue ?? key.toString();
  }

  static void handleOnLoopaChange(int? id) {
    if (id == null || id == mGetIt.get<ValueNotifier<Loopa>>().value.id) return;

    mGetIt.get<ValueNotifier<Loopa>>().value._cancelRecording();
    LoopClearController.stopFlashing();

    mGetIt.get<ValueNotifier<Loopa>>().value = _map[id] ?? Loopa(id: id);
    MemoryManager.saveLastVisitedKey(id.toString()); // todo: temp
  }

  static Loopa getLoopaFromMap(int key) {
    return _map[key] ?? Loopa(id: key);
  }

  static void initializeLoopas() {
    for (int key = 0; key < LoopaConstants.maxNumberOfLoopas; key++) {
      String? loopaInfo = MemoryManager.getLoopaInfo(key);
      if (loopaInfo != null) {
        Loopa(id: key).setValuesFromMemory(loopaInfo);
      }
    }
  }

  static int get getLastVisitedLoopaKey {
    if (MemoryManager.getLastVisitedKey == null) {
      return 0;
    } else {
      try {
        return int.parse(MemoryManager.getLastVisitedKey as String);
      } catch (e) {
        AppLog.error(e);
        return 0;
      }
    }
  }
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}