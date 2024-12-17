import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loopa/components/loop_selection/loop_selection_item.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionDropdown extends StatelessWidget {
  final Widget dropdownBuilder;

  const LoopSelectionDropdown({
    super.key,
    required this.dropdownBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: dropdownBuilder,
        items: List.generate(
          LoopaConstants.maxNumberOfLoopas,
          _dropdownMenuItemGenerator,
          growable: false
        ),
        onChanged: (id) => Loopa.handleOnLoopaChange(id),
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          width: LoopaSpacing.loopaSelectionDropDownWidth,
          maxHeight: LoopaSpacing.loopaSelectionMaxHeight,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(LoopaColors.neonGreen),
          )
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: LoopaSpacing.loopaSelectionItemHeight,
        ),
      ),
    );
  }

  DropdownMenuItem<int> _dropdownMenuItemGenerator(int index) {
    return DropdownMenuItem<int>(
        value: index,
        child: LoopSelectionItem(id: index)
    );
  }
}