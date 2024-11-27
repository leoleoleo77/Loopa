import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      precacheImage(AssetImage(LoopaImage.largePressed.path), context);
      precacheImage(AssetImage(LoopaImage.largeIdle.path), context);
      precacheImage(AssetImage(LoopaImage.smallPressed.path), context);
      precacheImage(AssetImage(LoopaImage.smallIdle.path), context);
    });
  }


  @override
  void dispose() {
    super.dispose();

    // Evict images if they are no longer needed
    imageCache.evict(AssetImage(LoopaImage.largePressed.path));
    imageCache.evict(AssetImage(LoopaImage.largeIdle.path));
    imageCache.evict(AssetImage(LoopaImage.smallPressed.path));
    imageCache.evict(AssetImage(LoopaImage.smallIdle.path));
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
            fit: BoxFit.fill
        )
      ),
    );
  }

  String _getImageAsset() {
    if (widget.largeState) {
      return isBeingPressed
          ? LoopaImage.largePressed.path
          : LoopaImage.largeIdle.path;
    } else {
      return isBeingPressed
          ? LoopaImage.smallPressed.path
          : LoopaImage.smallIdle.path;
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

enum LoopaImage {
  largePressed(path: 'assets/large_pressed.jpg'),
  largeIdle(path: 'assets/large_idle.jpg'),
  smallPressed(path: 'assets/small_pressed.jpg'),
  smallIdle(path: 'assets/small_idle.jpg');

  const LoopaImage({required this.path});

  final String path;
}