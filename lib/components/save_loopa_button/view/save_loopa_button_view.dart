import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/components/save_loopa_button/bloc/save_loopa_button_bloc.dart';
import 'package:loopa/components/save_loopa_button/bloc/save_loopa_button_event.dart';
import 'package:loopa/components/save_loopa_button/bloc/save_loopa_button_state.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class SaveLoopaButton extends StatelessWidget {

  const SaveLoopaButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mGetIt.get<SaveLoopaButtonBloc>(),
      child: BlocBuilder<SaveLoopaButtonBloc, SaveLoopaButtonState>(
        builder: (context, state) {
          bool isLoopaSaved = state.isLoopaSaved
              ?? mGetIt.get<ValueNotifier<Loopa>>().value.saveNotifier.value;

          return Container(
            width: LoopaSpacing.saveButtonWidth,
            height: LoopaSpacing.saveButtonHeight,
            decoration: _getBordersDecoration(isLoopaSaved),
            child: InkWell(
              onTap: () => mGetIt.get<SaveLoopaButtonBloc>()
                  .add(SaveLoopaButtonSaveLoopaEvent()),
              child: Center(
                child: Text(
                    isLoopaSaved ? LoopaText.saved : LoopaText.save,
                    style: isLoopaSaved
                        ? LoopaTextStyle.savedLabel : LoopaTextStyle.saveLabel
                ),
              ),
            ),
          );
        },
      ),
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
