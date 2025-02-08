import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loopa/components/loop_selection/loop_selection_dropdown_item.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionDropdown extends StatelessWidget {
  final ValueNotifier<LoopaState> loopaStateNotifier;
  final Widget dropdownBuilder;

  const LoopSelectionDropdown({
    super.key,
    required this.dropdownBuilder,
    required this.loopaStateNotifier,
  });

  // Basically what's going here is that the drop down list
  // widget listens to the state of the current loopa and
  // is rebuilt everytime it changes.
  //
  // The way in which the loopas are sorted is the following:
  // playing -> recording/idle -> initial
  // loopas in the same category are sorted based
  // on their id in descending order

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ValueListenableBuilder<LoopaState>(
          valueListenable: loopaStateNotifier,
          builder: (context, loopaState, child) {
            // this shit works for some reason
            List<LoopSelectionItem> itemList = _getLoopSelectionItemList();

            return DropdownButton2(
                customButton: dropdownBuilder,
                items: _getListOfDropdownMenuItems(itemList),
                onChanged: (id) => _handleLoopaChange(id, itemList),
                dropdownStyleData: _getDropdownStyleData(),
                menuItemStyleData: _getMenuItemStyleData());
          }
      ),
    );
  }

  List<LoopSelectionItem> _getLoopSelectionItemList() {
    int playingCount = 0;
    int recordingAndIdleCount = 0;
    List<LoopSelectionItem> itemList = [];

    const int loopaCount = LoopaConstants.maxNumberOfLoopas;
    for (int key = 0; key < loopaCount; key++) {
      LoopSelectionItem item = LoopSelectionItem(id: key);

      switch(Loopa.getStateFromMap(key)) {
        case LoopaState.initial:
          itemList.add(item);
        case LoopaState.playing:
          itemList.insert(playingCount, item);
          playingCount++;
        default:
          int index = playingCount + recordingAndIdleCount;
          itemList.insert(index, item);
          recordingAndIdleCount++;
      }
    }
    return itemList;
  }

  List<DropdownMenuItem<int>>? _getListOfDropdownMenuItems(
      List<LoopSelectionItem> itemList
  ) {
    return List.generate(
        LoopaConstants.maxNumberOfLoopas,
        (index) {
          return DropdownMenuItem<int>(
              value: index,
              child: itemList[index]);
        },
        growable: false
    );
  }

  void _handleLoopaChange(
      int? key,
      List<LoopSelectionItem> itemList
  ) {
    if (key == null) return;
    Loopa.handleOnLoopaChange(itemList[key].id);
  }

  DropdownStyleData _getDropdownStyleData() {
    return DropdownStyleData(
        direction: DropdownDirection.left,
        width: LoopaSpacing.loopaSelectionDropDownWidth,
        maxHeight: LoopaSpacing.loopaSelectionMaxHeight,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(LoopaColors.neonGreen),
        )
    );
  }

  MenuItemStyleData _getMenuItemStyleData() {
    return const MenuItemStyleData(
      height: LoopaSpacing.loopaSelectionItemHeight,
    );
  }
}