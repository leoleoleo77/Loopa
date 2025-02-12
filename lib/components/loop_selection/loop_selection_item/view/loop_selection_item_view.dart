import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loopa/components/loop_selection/loop_selection_dropdown.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/misc_utils/custom_selection_controls.dart';

class LoopSelectionView extends StatefulWidget {
  // final Loopa loopa;
  final bool compactView;
  final VoidCallback toggleKeyboardNotifier;

  const LoopSelectionView({
    super.key,
    // required this.loopa,
    this.compactView = true,
    required this.toggleKeyboardNotifier,
  });

  @override
  State<LoopSelectionView> createState() => _LoopSelectionViewState();
}

class _LoopSelectionViewState extends State<LoopSelectionView> {
  // todo: add bloc
  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  bool _nameChanged = false;
  bool _textIsVisible = true;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    Loopa.setStartFlashingMethod(_startFlashing);
    Loopa.setStopFlashingMethod(_stopFlashing);
    //_textEditingController.text = _getDisplayText();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return LoopSelectionDropdown(
      dropdownBuilder: _getNameDisplayItem(),
      loopaStateNotifier: mGetIt.get<ValueNotifier<Loopa>>().value.getStateNotifier(),
    );
  }

  Widget _getNameDisplayItem() {
    return GestureDetector(
      onLongPress: () => _openKeyboard(),
      child: AbsorbPointer(
        child: Row(
          children: [
            _getNameDisplay(),
            _getMemoryInfoText(),
          ],
        ),
      ),
    );
  }

  Widget _getNameDisplay() {
    _textEditingController.text = _getDisplayText();
    return Container(
      width: LoopaSpacing.loopaSelectionCompactViewWidth,
      height: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: LoopaPadding.left2,
        child: Center(
          child: Transform.scale(
            scaleY: LoopaConstants.loopSelectionTextStretchY,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: _shaderCallback,
              child: TextField(
                onTapOutside: (_) => _closeKeyboard(),
                onEditingComplete: () => _closeKeyboard(),
                textAlign: TextAlign.center,
                focusNode: _textFieldFocusNode,
                controller: _textEditingController,
                selectionControls: NoTextSelectionControls(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: LoopaTextStyle.loopaSelection,
                onChanged: _handleOnChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMemoryInfoText() {
    if (widget.compactView) return const SizedBox.shrink();

    return Container(
      width: LoopaSpacing.loopaSelectionMemoryInfoWidth,
      height: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: LoopaPadding.right4,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getGradientText(
                LoopaText.memory,
                LoopaTextStyle.memory,
              ),
              ValueListenableBuilder(
                valueListenable: mGetIt.get<ValueNotifier<Loopa>>().value.saveNotifier,
                builder: (BuildContext context, bool value, Widget? child) {
                  return _getGradientText(
                      mGetIt.get<ValueNotifier<Loopa>>().value.memoryCountValue,
                      LoopaTextStyle.memoryCount);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getGradientText(
      String text,
      TextStyle textStyle,
  ) {
    return Transform.scale(
      scaleY: LoopaConstants.loopSelectionTextStretchY,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: _shaderCallback,
        child: Text(text, style: textStyle),
      ),
    );
  }

  List<Color> _getGradientColor() {
    bool loopaStateIsInitial = mGetIt.get<ValueNotifier<Loopa>>().value.getStateNotifier().value == LoopaState.initial;
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

  void _handleOnChanged(String text) {
    if (_nameChanged) {
      mGetIt.get<ValueNotifier<Loopa>>().value.setName(text);
      return;
    }

    bool changeWasBackspace = mGetIt.get<ValueNotifier<Loopa>>().value.getName().length > text.length;
    if (changeWasBackspace) {
      setState(() {
        mGetIt.get<ValueNotifier<Loopa>>().value.setName(LoopaText.noText);
      });
    } else {
      String firstLetter = text.substring(text.length - 1, text.length);
      setState(() {
        mGetIt.get<ValueNotifier<Loopa>>().value.setName(firstLetter);
      });
    }
    _nameChanged = true;
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

  void _closeKeyboard() {
    if (mGetIt.get<ValueNotifier<Loopa>>().value.getName() == LoopaText.noText) {
      setState(() {
        mGetIt.get<ValueNotifier<Loopa>>().value.setDefaultName();
      });
    }

    FocusScope.of(context).unfocus();
    widget.toggleKeyboardNotifier();
    _nameChanged = false;
  }

  String _getDisplayText() {
    if (_flashTimer?.isActive == true) {
      if (_textIsVisible) {
        return LoopaText.clear;
      } else {
        return LoopaText.noText;
      }
    } else {
      return mGetIt.get<ValueNotifier<Loopa>>().value.getName();
    }
  }
}


