
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_event.dart';
import 'package:loopa/components/waveform_item/bloc/waveform_state.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/log_utils/app_log.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:path_provider/path_provider.dart';

class WaveformBloc extends Bloc<WaveformEvent, WaveformState> {

  WaveformBloc() : super(WaveformEmptyState(emptyState: EmptyState.noAudio)) {
    on<WaveformErrorEvent>(_handleErrorEvent);
    on<WaveformUpdateEvent>(_handleUpdateEvent);
  }

  void init() async {
    final File audioFile = File(mGetIt.get<ValueNotifier<Loopa>>().value.audioPath);

    try {
      final Uint8List audioBytes = await audioFile.readAsBytes()
          .then((bytes) => bytes = bytes.buffer.asUint8List());

      final File audioFileAsBytes = await getTemporaryDirectory()
          .then((dir) => File("${dir.path}/bytes.txt"));

      await audioFileAsBytes.writeAsBytes(audioBytes);

      final File waveFile = await getTemporaryDirectory()
          .then((dir) => File("${dir.path}/waveform.wave"));

      final Stream<WaveformProgress> progressStream =
        JustWaveform.extract(audioInFile: audioFileAsBytes, waveOutFile: waveFile);

      progressStream.listen(
        (waveformSnapshot) {
          if (waveformSnapshot.waveform != null) {
            add(WaveformUpdateEvent(waveform: waveformSnapshot.waveform));
          }
        },
        onError: (e) {
          DebugLog.error(e);
          add(WaveformErrorEvent());
        }
      );
    } catch (e) {
      DebugLog.error(e);
      add(WaveformErrorEvent());
    }
  }

  void _handleUpdateEvent(
      WaveformUpdateEvent event,
      Emitter<WaveformState> emit,
  ) {
    final List<int>? waveformData = event.waveform?.data;
    if (waveformData == null) {
      emit(WaveformEmptyState(emptyState: EmptyState.error));
    } else {
      final List<double> byteArray =
        waveformData.map((e) => e.toDouble()).toList();
      emit(WaveformDisplayState(byteArray: byteArray));
    }
  }

  void _handleErrorEvent(
    WaveformErrorEvent event,
    Emitter<WaveformState> emit,
  ) {
    emit(WaveformEmptyState(emptyState: EmptyState.error));
  }
}