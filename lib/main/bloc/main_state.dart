abstract class MainState {
  final bool expandedState;

  MainState({required this.expandedState});
}

class MainLoadingState extends MainState {
  MainLoadingState({
    super.expandedState = false
  });
}

class MainDisplayState extends MainState {
  MainDisplayState({
    required super.expandedState
  });
}