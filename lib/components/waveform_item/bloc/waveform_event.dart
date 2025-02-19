import 'package:just_waveform/just_waveform.dart';

abstract class WaveformEvent{}

class WaveformErrorEvent extends WaveformEvent{}

class WaveformUpdateEvent extends WaveformEvent{
  final Waveform? waveform;

  WaveformUpdateEvent({required this.waveform});
}