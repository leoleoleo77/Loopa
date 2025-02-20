
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_bloc.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_event.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_state.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/screen_size.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';

class WaveFormView extends StatelessWidget {
  const WaveFormView({ super.key });

  @override
  Widget build(context) {
    return BlocProvider.value(
      value: mGetIt.get<WaveformBloc>()
        ..add(WaveformInitializeEvent()),
      child: BlocBuilder<WaveformBloc, WaveformState>(
        builder: (context, state) {
          return Padding(
            padding: LoopaPadding.horizontal16,
            child: Container(
              width: double.infinity,
              height: 180,
              padding: LoopaPadding.vertical8,
              color: Colors.black,
              child: Builder(
                builder: (context) {
                  if (state is WaveformDisplayState) {
                    return RectangleWaveform(
                      // maxDuration: ,
                      // elapsedDuration: ,
                      samples: state.byteArray,
                      height: 164,
                      width: ScreenDimensions.width - 48,
                      borderWidth: 0,
                      isCentered: true,
                      activeColor: LoopaColors.neonGreen,
                      inactiveColor: LoopaColors.neonGreen,
                      activeBorderColor: LoopaColors.neonGreen,
                      inactiveBorderColor: LoopaColors.neonGreen,
                    ); //todo
                  } else {
                    return Text("${state.emptyState}",
                      style: TextStyle(color: Colors.white),);
                  }
                }
              ),
            ),
          );
        }
      ),
    );
  }
}
