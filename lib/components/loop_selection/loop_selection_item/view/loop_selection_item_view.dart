import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/components/loop_selection/loop_selection_dropdown.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_bloc.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_event.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/bloc/loop_selection_item_state.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/misc_utils/custom_selection_controls.dart';

class LoopSelectionView extends StatelessWidget {
  final bool isCompactView;

  const LoopSelectionView({
    super.key,
    this.isCompactView = true,
  });

  @override
  Widget build(BuildContext context) {
    return LoopSelectionDropdown(dropdownContainer: _getLoopSelectionItem());
  }

  Widget _getLoopSelectionItem() {
    return BlocProvider.value(
      value: mGetIt.get<LoopSelectionItemBloc>(),
      child: BlocBuilder<LoopSelectionItemBloc, LoopSelectionItemState>(
        builder: (context, state) {
          return GestureDetector(
            onLongPress: () => mGetIt.get<LoopSelectionItemBloc>()
                .add(LoopSelectionItemOpenKeyboardEvent()),
            child: AbsorbPointer(
              child: Row(
                children: [
                  _getNameDisplay(state),
                  _getMemoryInfoText(state),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _getNameDisplay(LoopSelectionItemState state) {
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
                onTapOutside: (_) => mGetIt.get<LoopSelectionItemBloc>()
                    .add(LoopSelectionItemCloseKeyboardEvent()),
                onEditingComplete: () => mGetIt.get<LoopSelectionItemBloc>()
                    .add(LoopSelectionItemCloseKeyboardEvent()),
                onChanged: (text) => mGetIt.get<LoopSelectionItemBloc>()
                    .add(LoopSelectionItemKeyboardInputEvent(text: text)),
                textAlign: TextAlign.center,
                focusNode: state.textFieldFocusNode,
                controller: TextEditingController(
                    text: state.displayName ?? mGetIt.get<ValueNotifier<Loopa>>().value.name),
                selectionControls: NoTextSelectionControls(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: LoopaTextStyle.loopaSelection,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMemoryInfoText(LoopSelectionItemState state) {
    if (isCompactView) return const SizedBox.shrink();

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
              _getGradientText(
                  state.displayMemoryCount
                      ?? mGetIt.get<ValueNotifier<Loopa>>().value.memoryCountValue,
                  LoopaTextStyle.memoryCount),
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
    bool loopaStateIsInitial =
        mGetIt.get<ValueNotifier<Loopa>>().value.isStateInitial;
    bool isFlashing =
        mGetIt.get<LoopSelectionItemBloc>().isFlashingTimerActive;

    if (loopaStateIsInitial && !isFlashing) {
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
}


