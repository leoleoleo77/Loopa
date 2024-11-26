import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:loopa/components/loop_selection/loop_selection_item/loop_selection_item.dart';

import 'loop_selection_item/loop_selection_item_model.dart';

class LoopSelectionDropdown extends StatelessWidget {
  final Widget dropdownBuilder;
  final List<LoopSelectionItemModel> models;

  const LoopSelectionDropdown({
    super.key,
    required this.dropdownBuilder,
    required this.models
  });

  // TODO: fix the ripple effect
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: dropdownBuilder,
        items: models.map(
            (model) => DropdownMenuItem<LoopSelectionItemModel>(
              value: model,
              child: LoopSelectionItem(model: model),
             ),
          ).toList(),
        onChanged: (value) {},
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          width: 264,
          maxHeight: 444,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.lightGreenAccent.shade400,),
          )
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 80,
        ),
      ),
    );
  }
}