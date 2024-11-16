import 'package:flutter/foundation.dart';

class Loopa {
  static int count = 0;

  late String name;
  late int id;
  late ValueNotifier<LoopaState> _stateNotifier;

  Loopa() {
    id = count;
    name = _initialiseName();
    _stateNotifier = ValueNotifier(LoopaState.initial);
    count++;
  }

  void updateState() {
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

  ValueNotifier<LoopaState> getStateNotifier() => _stateNotifier;

  String _initialiseName() {
    if (id < 10) {
      return "LOOP_0$id";
    } else {
      return "LOOP_$id";
    }
  }
}

enum LoopaState {
  initial,
  recording,
  playing,
  idle
}