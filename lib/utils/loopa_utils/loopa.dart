import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_bloc.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_event.dart';
import 'package:loopa/utils/log_utils/app_log.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/memory_manager.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/log_utils/log_helper.dart';
import 'package:loopa/utils/loopa_utils/audio_controller.dart';

class Loopa {
  static final Map<int, Loopa> _map = {};

  late final int id;
  late String name;
  late final ValueNotifier<LoopaState> _stateNotifier;
  late final AudioController _audioController;
  bool _wasLoopaCleared = false;

  Loopa({
    required this.id,
  }) {
    name = _getDefaultName(id);
    _stateNotifier = ValueNotifier(LoopaState.initial);
    _audioController = AudioController(this);
    _map[id] = this;
  }

  Loopa.fromMemory({
    required this.id,
    required Map<String, dynamic> jsonData
  }) {
    name = (jsonData[LoopaJson.name]);
    _stateNotifier = ValueNotifier(LoopaState.idle);
    // _saveNotifier = ValueNotifier(true);
    _audioController = AudioController(this);
    _map[id] = this;
  }

  bool get isStateInitial => _stateNotifier.value == LoopaState.initial;

  bool get isStateRecording => _stateNotifier.value == LoopaState.recording;

  bool get isStateIdle => _stateNotifier.value == LoopaState.idle;

  bool get isStateInitialOrRecording => isStateInitial || isStateRecording;

  void _cancelRecording() {
    if (isStateRecording) {
      _audioController.clearRecording();
      _stateNotifier.value = LoopaState.initial;
    }
  }

  void clearLoop() {
    if (_stateNotifier.value == LoopaState.initial) return;

    mGetIt.get<LoopSelectionItemBloc>()
        .add(LoopSelectionItemStartFlashingEvent());
    _audioController.clearPlayer();
    name = getNameFromMap(id);
    _wasLoopaCleared = true;
    _stateNotifier.value = LoopaState.initial;
    DebugLog.info("$name state: initial");
    _deleteLoopa();
  }

  void updateState() {

    if (_wasLoopaCleared) {
      _wasLoopaCleared = false;
      DebugLog.info("$name state: ${stateNotifier.value}");
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
        _stateNotifier.value = LoopaState.recording;
        _audioController.startRecording();
        mGetIt.get<LoopSelectionItemBloc>()
            .add(LoopSelectionItemStopFlashingEvent());
        DebugLog.info("$name state: initial -> recording");
        return;
      case LoopaState.recording:
        _stateNotifier.value = LoopaState.playing;
        _audioController.beginLooping();
        DebugLog.info("$name state: recording -> playing");
        _saveLoopa();
        return;
      case LoopaState.playing:
        _stateNotifier.value = LoopaState.idle;
        _audioController.stopPlayer();
        DebugLog.info("$name state: playing -> idle");
        return;
      case LoopaState.idle:
        _stateNotifier.value = LoopaState.playing;
        _audioController.startPlaying();
        DebugLog.info("$name state: idle -> playing");
        return;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      LoopaJson.name: name,
    };
  }

  Future<void> _saveLoopa() async {
    await MemoryManager.saveLoopa(this)
        .then((result) => DebugLog.info("Saved Loopa $name: $result") );
  }

  Future<void> _deleteLoopa() async {
    await MemoryManager.deleteLoopa(this)
        .then((result) => DebugLog.info("Deleted Loopa $name: $result") );
  }

  ValueNotifier<LoopaState> get stateNotifier => _stateNotifier;

  void setDefaultName() => name = _getDefaultName(id);

  bool get wasLoopaCleared => _wasLoopaCleared;

  /// - Start static methods -

  static String _getDefaultName(int i) {
    return "LOOP_$i";
  }

  static String getNameFromMap(int key) {
    return _map[key]?.name ?? _getDefaultName(key);
  }

  static LoopaState getStateFromMap(int key) {
    return _map[key]?.stateNotifier.value ?? LoopaState.initial;
  }

  static Loopa getLoopaFromMap({required int key}) {
    return _map[key] ?? Loopa(id: key);
  }

  static void handleOnLoopaChange(int? id) {
    if (id == null || id == mGetIt.get<ValueNotifier<Loopa>>().value.id) return;

    mGetIt.get<ValueNotifier<Loopa>>().value._cancelRecording();
    mGetIt.get<LoopSelectionItemBloc>().add(LoopSelectionItemStopFlashingEvent());
    mGetIt.get<ValueNotifier<Loopa>>().value = getLoopaFromMap(key: id); // change
    MemoryManager.saveLastVisitedKey(id.toString()); // todo: temp
    Log.logLoopaChange(
      loopaId: id, 
      loopaState: getStateFromMap(id)
    );
  }

  static Loopa getLoopaFromMemory({required int key}) {
    String? loopaInfo = MemoryManager.getLoopaData(key);
    if (loopaInfo != null) {
      return Loopa.fromMemory(
          id: key,
          jsonData: jsonDecode(loopaInfo));
    } else {
      return Loopa(id: key);
    }
  }

  static void initializeLoopasFromMemory() {
    for (int key = 0; key < LoopaConstants.maxNumberOfLoopas; key++) {
      String? loopaInfo = MemoryManager.getLoopaData(key);
      if (loopaInfo != null && key != getLastVisitedLoopaKey) {
        Loopa.fromMemory(
            id: key,
            jsonData: jsonDecode(loopaInfo));
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
        DebugLog.error(e);
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