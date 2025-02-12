import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loopa/components/tool_bar/tool_bar_animation/bloc/tool_bar_animation_event.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/keyboard_controller.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

import 'tool_bar/tool_bar_animation/bloc/tool_bar_animation_bloc.dart';

class LoopButton extends StatefulWidget {
  final bool largeState;
  // final bool isKeyboardActive;

  const LoopButton({
    super.key,
    this.largeState = true,
    // required this.isKeyboardActive
  });

  @override
  State<LoopButton> createState() => _LoopButtonState();
}

class _LoopButtonState extends State<LoopButton> {
  bool isBeingPressed = false;

  @override
  void initState() {
    super.initState();

    // Defer precaching until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage(LoopaAssets.largePressed), context);
      precacheImage(const AssetImage(LoopaAssets.largeIdle), context);
      precacheImage(const AssetImage(LoopaAssets.smallPressed), context);
      precacheImage(const AssetImage(LoopaAssets.smallIdle), context);
    });
  }


  @override
  void dispose() {
    super.dispose();

    // Evict images if they are no longer needed
    imageCache.evict(const AssetImage(LoopaAssets.largePressed));
    imageCache.evict(const AssetImage(LoopaAssets.largeIdle));
    imageCache.evict(const AssetImage(LoopaAssets.smallPressed));
    imageCache.evict(const AssetImage(LoopaAssets.smallIdle));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics.fromProperties(
        properties: LoopaSemantics.loopButtonSemantics,
        child: AbsorbPointer(
          absorbing: mGetIt.get<KeyboardController>().isKeyboardActive,
          child: GestureDetector(
            onPanStart: (_) => _handlePanStart(),
            onPanEnd: (_) => _handlePanEnd(),
            onPanCancel: () => _handlePanCancel(),
            child: Image.asset(
                _getImageAsset(),
                width: double.infinity,
                fit: BoxFit.fill,
            )
          ),
        ),
      ),
    );
  }

  String _getImageAsset() {
    if (widget.largeState) {
      return isBeingPressed
          ? LoopaAssets.largePressed
          : LoopaAssets.largeIdle;
    } else {
      return isBeingPressed
          ? LoopaAssets.smallPressed
          : LoopaAssets.smallIdle;
    }
  }

  void _handlePanStart() {
    setState(() => isBeingPressed = true);

    mGetIt.get<ToolBarAnimationBloc>()
      .add(ToolBarAnimationLongPressStartedEvent());
  }

  void _handlePanEnd() {
    setState(() => isBeingPressed = false);

    mGetIt.get<ToolBarAnimationBloc>()
        .add(ToolBarAnimationLongPressEndedEvent());
  }

  void _handlePanCancel() {
    setState(() => isBeingPressed = false);

    mGetIt.get<ToolBarAnimationBloc>()
        .add(ToolBarAnimationLongPressEndedEvent(isCancelEvent: true));
  }
}