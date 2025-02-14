import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_bloc.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_event.dart';
import 'package:loopa/components/save_loopa_button/bloc/save_loopa_button_bloc.dart';
import 'package:loopa/components/save_loopa_button/bloc/save_loopa_button_event.dart';
import 'package:loopa/utils/misc_utils/app_log.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/memory_manager.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/audio_controller.dart';

class Loopa {
  static final Map<int, Loopa> _map = {};

  late final int id;
  late String name;
  late final ValueNotifier<LoopaState> _stateNotifier;
  // late final ValueNotifier<bool> _saveNotifier;
  late final AudioController _audioController;
  bool _wasLoopaCleared = false;

  Loopa({
    required this.id,
  }) {
    name = _getDefaultName(id);
    _stateNotifier = ValueNotifier(LoopaState.initial);
    // _saveNotifier = ValueNotifier(false);
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

  bool get isStateInitialOrRecording {
    return _stateNotifier.value == LoopaState.initial
        || _stateNotifier.value == LoopaState.recording;
  }

  bool get isStateInitial => _stateNotifier.value == LoopaState.initial;

  bool get isStateRecording => _stateNotifier.value == LoopaState.recording;

  bool get isStateIdle => _stateNotifier.value == LoopaState.idle;

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
    AppLog.info("$name state: initial");
    _deleteLoopa();
  }

  void updateState() {

    if (_wasLoopaCleared) {
      _wasLoopaCleared = false;
      AppLog.info("$name state: ${stateNotifier.value}");
      return;
    }

    switch(_stateNotifier.value) {
      case LoopaState.initial:
        _stateNotifier.value = LoopaState.recording;
        _audioController.startRecording();
        mGetIt.get<LoopSelectionItemBloc>()
            .add(LoopSelectionItemStopFlashingEvent());
        AppLog.info("$name state: initial -> recording");
        return;
      case LoopaState.recording:
        _stateNotifier.value = LoopaState.playing;
        _audioController.beginLooping();
        AppLog.info("$name state: recording -> playing");
        _saveLoopa();
        return;
      case LoopaState.playing:
        _stateNotifier.value = LoopaState.idle;
        _audioController.stopPlayer();
        AppLog.info("$name state: playing -> idle");
        return;
      case LoopaState.idle:
        _stateNotifier.value = LoopaState.playing;
        _audioController.startPlaying();
        AppLog.info("$name state: idle -> playing");
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
        .then((result) =>AppLog.info("Saved Loopa $name: $result") );
  }

  Future<void> _deleteLoopa() async {
    await MemoryManager.deleteLoopa(this)
        .then((result) =>AppLog.info("Deleted Loopa $name: $result") );
  }
  // Future<void> handleSave() async {
  //   if (_saveNotifier.value == false) {
  //     _saveNotifier.value = await MemoryManager.saveLoopa(this);
  //     AppLog.info("Saved Loopa $name = ${_saveNotifier.value}");
  //   } else {
  //     _saveNotifier.value = !await MemoryManager.deleteLoopa(this);
  //     AppLog.info("Deleted Loopa $name = ${!_saveNotifier.value}");
  //   }
  //   await _audioController.updatePath();
  //   mGetIt.get<LoopSelectionItemBloc>()
  //       .add(LoopSelectionItemToggleMemoryIdAsteriskEvent());
  // }

  ValueNotifier<LoopaState> get stateNotifier => _stateNotifier;

  void setDefaultName() => name = _getDefaultName(id);

  // ValueNotifier<bool> get saveNotifier => _saveNotifier;
  //
  // bool get isSaved => _saveNotifier.value;

  // String get memoryCountValue {
  //   return isSaved ? "$id*" : "$id";
  // }

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

  // static String getMemoryCountValueFromMap(int key) {
  //   return _map[key]?.memoryCountValue ?? key.toString();
  // }

  static void handleOnLoopaChange(int? id) {
    if (id == null || id == mGetIt.get<ValueNotifier<Loopa>>().value.id) return;

    // before changing
    mGetIt.get<ValueNotifier<Loopa>>().value._cancelRecording();
    mGetIt.get<LoopSelectionItemBloc>().add(LoopSelectionItemStopFlashingEvent());

    mGetIt.get<ValueNotifier<Loopa>>().value = getLoopaFromMap(key: id); // change

    // after changing
    // mGetIt.get<SaveLoopaButtonBloc>().add(SaveLoopaButtonLoopaChangedEvent());
    MemoryManager.saveLastVisitedKey(id.toString()); // todo: temp
  }

  static Loopa getLoopaFromMap({required int key}) {
    return _map[key] ?? Loopa(id: key);
  }

  static Loopa getLoopaFromMemory({required int key}) {
    String? loopaInfo = MemoryManager.getLoopaInfo(key);
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
      String? loopaInfo = MemoryManager.getLoopaInfo(key);
      if (loopaInfo != null && key != getLastVisitedLoopaKey) {
        getLoopaFromMemory(key: key);
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