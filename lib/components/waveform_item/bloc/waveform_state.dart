
abstract class WaveformState{
  final EmptyState? emptyState;

  WaveformState({this.emptyState});
}

class WaveformEmptyState extends WaveformState{
  WaveformEmptyState({
    required super.emptyState,
  });
}

class WaveformDisplayState extends WaveformState{
  final List<double> byteArray;

  WaveformDisplayState({required this.byteArray});
}

enum EmptyState {
  noAudio,
  loading,
  error
}