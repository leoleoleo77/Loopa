abstract class ToolBarAnimationEvent{}

class ToolBarAnimationInitialEvent extends ToolBarAnimationEvent {
  final double maxWidth;
  ToolBarAnimationInitialEvent({required this.maxWidth});
}

class ToolBarAnimationLongPressStartedEvent
    extends ToolBarAnimationEvent {

  ToolBarAnimationLongPressStartedEvent();
}

class ToolBarAnimationLongPressCanceledEvent
    extends ToolBarAnimationEvent {

  ToolBarAnimationLongPressCanceledEvent();
}

class ToolBarAnimationLongPressCompletedEvent
    extends ToolBarAnimationEvent {

  ToolBarAnimationLongPressCompletedEvent();
}

class ToolBarAnimationOnTickEvent extends ToolBarAnimationEvent {
  final double animationWidth;
  final double animationOpacity;

  ToolBarAnimationOnTickEvent({
    required this.animationWidth,
    required this.animationOpacity
  });
}

