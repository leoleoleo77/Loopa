abstract class SaveLoopaButtonState {
  final bool? isLoopaSaved;
  SaveLoopaButtonState({this.isLoopaSaved});
}

class SaveLoopaButtonInitialState extends SaveLoopaButtonState {
  SaveLoopaButtonInitialState({super.isLoopaSaved});
}

class SaveLoopaButtonPopulateState extends SaveLoopaButtonState{
  SaveLoopaButtonPopulateState({super.isLoopaSaved});
}