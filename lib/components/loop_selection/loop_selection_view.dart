import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_dropdown.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionView extends StatefulWidget {
  final Loopa loopa;
  final bool compactView;
  final VoidCallback toggleKeyboardNotifier;

  const LoopSelectionView({
    super.key,
    required this.loopa,
    this.compactView = true,
    required this.toggleKeyboardNotifier,
  });

  @override
  State<LoopSelectionView> createState() => _LoopSelectionViewState();
}

class _LoopSelectionViewState extends State<LoopSelectionView> {

  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool _textIsVisible = true;
  Timer? _flashTimer;

  void _startFlashing() {
    _toggleDisplayTextVisibility();
    _flashTimer = Timer.periodic(
      LoopaDuration.milliseconds500,
      (timer) {
        _toggleDisplayTextVisibility();
        if (timer.tick == 7) {
          timer.cancel();
          _stopFlashing();
        }
      },
    );
  }

  void _stopFlashing() {
    if (_flashTimer == null) return;
    _flashTimer?.cancel();
    setState(() {
      _textIsVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Loopa.setStartFlashingMethod(_startFlashing);
    Loopa.setStopFlashingMethod(_stopFlashing);
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LoopaPadding.vertical12,
      child: LoopSelectionDropdown(
        dropdownBuilder: _getNameDisplayItem(),
      )
    );
  }

  Widget _getNameDisplayItem() {
    return GestureDetector(
      onLongPress: () => _openKeyboard(),
      child: AbsorbPointer(
        child: Row(
          children: [
            Container(
              width: 132,
              height: double.infinity,
              color: Colors.black,
              child: Center(
                child: Transform.scale(
                  scaleY: 1.5,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: _shaderCallback,
                    child: TextField(
                      onTapOutside: _closeKeyboard,
                      textAlign: TextAlign.center,
                      focusNode: _textFieldFocusNode,
                      controller: TextEditingController(text: _getDisplayText()),
                      selectionControls: NoTextSelectionControls(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: LoopaTextStyle.loopaSelection
                    ),
                  ),
                ),
              ),
            ),
            _getMemoryInfoText(),
          ],
        ),
      ),
    );
  }

  Widget _getMemoryInfoText() {
    if (widget.compactView) return const SizedBox.shrink();

    return Container(
      width: 68,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getGradientText(
              LoopaText.memory,
              LoopaFontSize.fontSize18,
            ),
            _getGradientText(
                widget.loopa.id.toString(),
                LoopaFontSize.fontSize20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getGradientText(
      String text,
      double fontSize,
  ) {
    return Transform.scale(
      scaleY: 1.5,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: _getGradientColor()
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        child: Text(
            text,
            style: TextStyle(
                fontFamily: LoopaFontFamily.retro,
                fontSize: fontSize,
                height: 1
            ),
        ),
      ),
    );
  }

  List<Color> _getGradientColor() {
    bool loopaStateIsInitial = widget.loopa.getStateNotifier().value == LoopaState.initial;
    bool isFlashing = !(_flashTimer?.isActive == true);

    if (loopaStateIsInitial && isFlashing) {
      return LoopaColors.idleGreenGradient;
    } else {
      return LoopaColors.activeGreenGradient;
    }
  }

  Shader _shaderCallback(Rect bounds) {
    return LinearGradient(colors: _getGradientColor())
        .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    );
  }

  void _toggleDisplayTextVisibility() {
    setState(() {
      _textIsVisible = !_textIsVisible;
    });
  }

  void _openKeyboard() {
    _textFieldFocusNode.requestFocus();
    widget.toggleKeyboardNotifier();
  }

  void _closeKeyboard(PointerDownEvent e) {
    FocusScope.of(context).unfocus();
    widget.toggleKeyboardNotifier();
  }

  String _getDisplayText() {
    if (_flashTimer?.isActive == true) {
      if (_textIsVisible) {
        return LoopaText.clear;
      } else {
        return LoopaText.noText;
      }
    } else {
      return widget.loopa.getName();
    }
  }
}


class NoTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(
      BuildContext context,
      TextSelectionHandleType type,
      double textHeight,
      [void Function()? onTap]
  ) {
    return Container();
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return Size.zero; // No size for the handle
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return Offset.zero; // No anchor needed
  }
}


