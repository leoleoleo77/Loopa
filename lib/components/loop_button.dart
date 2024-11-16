import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoopButton extends StatefulWidget {
  final bool largeState;
  final VoidCallback updateLoopaState;

  const LoopButton({
    super.key,
    this.largeState = true,
    required this.updateLoopaState
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
        onPanStart: (_) {
          setState(() {
            isBeingPressed = true;
          });
        },
        onPanEnd: (_) {
          setState(() {
            isBeingPressed = false;
          });
          widget.updateLoopaState();
        },
        onPanCancel: () {
          setState(() {
            isBeingPressed = false;
          });
        },
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
}