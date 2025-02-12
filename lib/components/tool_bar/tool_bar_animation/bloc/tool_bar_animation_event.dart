abstract class ToolBarAnimationEvent{}

class ToolBarAnimationInitialEvent extends ToolBarAnimationEvent {
  final double maxWidth;
  ToolBarAnimationInitialEvent({required this.maxWidth});
}

class ToolBarAnimationLongPressStartedEvent
    extends ToolBarAnimationEvent {

  ToolBarAnimationLongPressStartedEvent();
}

class ToolBarAnimationLongPressEndedEvent
    extends ToolBarAnimationEvent {
  final bool isCancelEvent;

  ToolBarAnimationLongPressEndedEvent({
    this.isCancelEvent = false
  });
}

class ToolBarAnimationDeleteCompletedEvent
    extends ToolBarAnimationEvent {

  ToolBarAnimationDeleteCompletedEvent();
}

class ToolBarAnimationOnTickEvent extends ToolBarAnimationEvent {
  final double animationWidth;
  final double animationOpacity;

  ToolBarAnimationOnTickEvent({
    required this.animationWidth,
    required this.animationOpacity
  });
}

