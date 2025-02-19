
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_bloc.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_state.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/screen_size.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';

class WaveFormView extends StatelessWidget {
  const WaveFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mGetIt.get<WaveformBloc>()..init(),
      child: BlocBuilder<WaveformBloc, WaveformState>(
        builder: (context, state) {
          return Padding(
            padding: LoopaPadding.horizontal16,
            child: Container(
              width: double.infinity,
              height: 164,
              color: Colors.black,
              child: Builder(
                builder: (context) {
                  if (state is WaveformDisplayState) {
                    return RectangleWaveform(
                        samples: state.byteArray,
                        height: 100,
                        width: ScreenDimensions.width - 64);
                  } else {
                    return Text("${state.emptyState}", style: TextStyle(color: Colors.white),);
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
