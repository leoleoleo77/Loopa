class ToolBarAnimationController {
  Function()? startExpanding;
  Function()? stopExpanding;

  ToolBarAnimationController({
    this.startExpanding,
    this.stopExpanding
  });

  // Cool shit 😎

  bool isInitialized() {
    bool startExpandingIsNull = startExpanding == null;
    bool stopExpandingIsNull = stopExpanding == null;
    return !startExpandingIsNull && !stopExpandingIsNull;
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
}