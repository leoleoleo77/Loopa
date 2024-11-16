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

  late final Image largePressed;
  late final Image largeIdle;
  late final Image smallPressed;
  late final Image smallIdle;

  @override
  void initState() {
    super.initState();

    largePressed = Image.asset('assets/large_pressed.jpg', width: double.infinity, fit: BoxFit.fill);
    largeIdle = Image.asset('assets/large_idle.jpg', width: double.infinity, fit: BoxFit.fill);
    smallPressed = Image.asset('assets/small_pressed.jpg', width: double.infinity, fit: BoxFit.fill);
    smallIdle = Image.asset('assets/small_idle.jpg', width: double.infinity, fit: BoxFit.fill);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(largePressed.image, context);
    precacheImage(largeIdle.image, context);
    precacheImage(smallPressed.image, context);
    precacheImage(smallIdle.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onPanStart: (_) => _handlePanStart(),
        onPanEnd: (_) => _handlePanEnd(),
        onPanCancel: () => _handlePanCancel(),
        child: _getImage()
      ),
    );
  }

  Image _getImage() {
    if (widget.largeState) {
      return isBeingPressed
          ? largePressed
          : largeIdle;
    } else {
      return isBeingPressed
          ? smallPressed
          : smallIdle;
    }
  }

  void _handlePanStart() {
    setState(() {
      isBeingPressed = true;
    });
    widget.loopa.startLongPressListener();
  }

  void _handlePanEnd() {
    widget.loopa.cancelLongPressListener();
    widget.loopa.updateState();
    setState(() {
      isBeingPressed = false;
    });
  }

  void _handlePanCancel() {
    widget.loopa.cancelLongPressListener();
    setState(() {
      isBeingPressed = false;
    });
  }
}