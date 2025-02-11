import 'package:flutter/material.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class SaveLoopaButton extends StatelessWidget {

  const SaveLoopaButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: mGetIt.get<ValueNotifier<Loopa>>().value.saveNotifier,
      builder: (context, isSaved, child) {
        return Container(
          width: LoopaSpacing.saveButtonWidth,
          height: LoopaSpacing.saveButtonHeight,
          decoration: _getBordersDecoration(isSaved),
          child: InkWell(
            onTap: mGetIt.get<ValueNotifier<Loopa>>().value.handleSave,
            child: Center(
              child: Text(
                  isSaved ? LoopaText.saved : LoopaText.save,
                  style: isSaved
                      ? LoopaTextStyle.savedLabel : LoopaTextStyle.saveLabel
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _getBordersDecoration(bool isSaved) {
    return BoxDecoration(
        gradient: _getButtonGradient(isSaved),
        border: _getButtonBorders(isSaved));
  }

  LinearGradient _getButtonGradient(bool isSaved) {
    if (isSaved) {
      return const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: LoopaColors.savedButtonGradient);
    } else {
      return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: LoopaColors.saveButtonGradient);
    }
  }

  Border _getButtonBorders(bool isSaved) {
    if (isSaved) {
      return LoopaBorders.savedButtonBorders;
    } else {
      return LoopaBorders.saveButtonBorders;
    }
  }
}
