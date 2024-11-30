import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopButton extends StatefulWidget {
  final bool largeState;
  final Loopa loopa;

  const LoopButton({
    super.key,
    this.largeState = true,
    required this.loopa
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
      child: GestureDetector(
        onPanStart: (_) => _handlePanStart(),
        onPanEnd: (_) => _handlePanEnd(),
        onPanCancel: () => _handlePanCancel(),
        child: Image.asset(
            _getImageAsset(),
            width: double.infinity,
            fit: BoxFit.fill,
            semanticLabel: LoopaLabels.loopButton,
        )
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
    setState(() {
      isBeingPressed = true;
    });
    if (widget.largeState) widget.loopa.startLongPressListener(); // TODO: handle this better
  }

  void _handlePanEnd() {
    if (widget.largeState) widget.loopa.cancelLongPressListener(); // ++
    widget.loopa.updateState();
    setState(() {
      isBeingPressed = false;
    });
  }

  void _handlePanCancel() {
    if (widget.largeState) widget.loopa.cancelLongPressListener(); // ++
    setState(() {
      isBeingPressed = false;
    });
  }
}