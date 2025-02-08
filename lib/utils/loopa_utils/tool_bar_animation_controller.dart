class ToolBarAnimationController {
  Function()? startExpanding;
  Function()? stopExpanding;
  Function()? onComplete;

  ToolBarAnimationController({
    this.startExpanding,
    this.stopExpanding,
    this.onComplete
  }) {
    startExpanding = () {};
    stopExpanding = () {};
    onComplete = () {};
  }

  // Cool shit 😎

  ToolBarAnimationController setStartExpanding(
      Function() function
  ) {
    startExpanding = function;
    return this;
  }

  ToolBarAnimationController setStopExpanding(
      Function() function
  ) {
    stopExpanding = function;
    return this;
  }

  ToolBarAnimationController setOnComplete(
      Function() function
  ) {
    onComplete = function;
    return this;
  }
}