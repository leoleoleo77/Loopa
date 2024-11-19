class ToolBarAnimationController {
  Function()? startExpanding;
  Function()? stopExpanding;
  Function()? onComplete;

  ToolBarAnimationController({
    this.startExpanding,
    this.stopExpanding,
    this.onComplete
  });

  // Cool shit 😎

  bool isInitialized() {
    bool startExpandingIsNull = startExpanding == null;
    bool stopExpandingIsNull = stopExpanding == null;
    bool onCompleteIsNull = onComplete == null;
    return !startExpandingIsNull &&
        !stopExpandingIsNull &&
        !onCompleteIsNull;
  }

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