abstract class LoopSelectionItemEvent{}

class LoopSelectionItemOpenKeyboardEvent
    extends LoopSelectionItemEvent {
  LoopSelectionItemOpenKeyboardEvent();
}

class LoopSelectionItemCloseKeyboardEvent
    extends LoopSelectionItemEvent {
  LoopSelectionItemCloseKeyboardEvent();
}

class LoopSelectionItemKeyboardInputEvent
    extends LoopSelectionItemEvent {

  final String text;
  LoopSelectionItemKeyboardInputEvent({required this.text});
}

class LoopSelectionItemStartFlashingEvent
    extends LoopSelectionItemEvent {
  LoopSelectionItemStartFlashingEvent();
}

class LoopSelectionItemStopFlashingEvent
    extends LoopSelectionItemEvent {
  LoopSelectionItemStopFlashingEvent();
}

class LoopSelectionItemToggleNameVisibilityEvent
    extends LoopSelectionItemEvent {

  final bool hideName;
  LoopSelectionItemToggleNameVisibilityEvent({
    required this.hideName
  });
}

class LoopSelectionItemToggleMemoryIdAsteriskEvent
    extends LoopSelectionItemEvent {
  LoopSelectionItemToggleMemoryIdAsteriskEvent();
}


