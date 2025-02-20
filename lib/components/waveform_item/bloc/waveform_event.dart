import 'package:just_waveform/just_waveform.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

abstract class WaveformEvent{}

class WaveformInitializeEvent extends WaveformEvent{}

class WaveformErrorEvent extends WaveformEvent{}

class WaveformDisplayEvent extends WaveformEvent{
  final Waveform? waveform;

  WaveformDisplayEvent({required this.waveform});
}

class WaveformLoopaStateChangedEvent extends WaveformEvent{
  final LoopaState loopaState;

  WaveformLoopaStateChangedEvent({required this.loopaState});
}