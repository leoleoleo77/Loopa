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
          LoopaConstants.loopaCount,
          (index) {
            return DropdownMenuItem<int>(
              value: index,
              child: LoopSelectionItem(id: index)
            );
          },
          growable: false
        ),
        onChanged: (id) => Loopa.handleOnLoopaChange(id),
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          width: 224,
          maxHeight: 444,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.lightGreenAccent.shade400),
          )
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 72 ,
        ),
      ),
    );
  }
}