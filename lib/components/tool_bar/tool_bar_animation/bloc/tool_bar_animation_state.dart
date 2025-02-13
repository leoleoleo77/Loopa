abstract class ToolBarAnimationState{
  final double animationWidth;
  final double animationOpacity;
  final Duration animationDuration;
  final bool animationInProgress;

  const ToolBarAnimationState({
    required this.animationWidth,
    required this.animationOpacity,
    required this.animationDuration,
    required this.animationInProgress
  });
}

class ToolBarAnimationIdleState extends ToolBarAnimationState {
  const ToolBarAnimationIdleState({
    super.animationWidth = 0,
    super.animationOpacity = 0,
    super.animationDuration = Duration.zero,
    super.animationInProgress = false
  });
}

class ToolBarAnimationExpandingState extends ToolBarAnimationState {
  const ToolBarAnimationExpandingState({
    required super.animationWidth,
    required super.animationOpacity,
    required super.animationDuration,
    required super.animationInProgress
  });
}