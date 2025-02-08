import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioController {
  final String loopName;
  late final AudioPlayer _audioPlayer;
  late final AudioRecorder _audioRecorder;
  late InitState _playerInitState; // might be redundant
  late Future<String> audioPath;
  static const nullPath = "NULL_PATH";

  AudioController({
    required this.loopName,
  }) {
    audioPath = _getAudioPath(); // might be redundant

    // temporary
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
  }

  Future<void> startRecording() async {
    // _audioRecorder = AudioRecorder();
    try {
      await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav
          ),
          path: await audioPath,
      );
    } catch(e) {
      // TODO
    }
  }

  Future<void> beginLooping() async {
    await clearRecording();
    await _initPlayer();
    startPlaying();
  }

  Future<void> clearRecording() async {
    await _audioRecorder.stop();
    // _audioRecorder.dispose();
  }

  Future<void> _initPlayer() async {
    _playerInitState = InitState.pending;
    // _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setFilePath(await audioPath);
      await _audioPlayer.setLoopMode(LoopMode.one);
      _playerInitState = InitState.complete;
    } catch (e) {
      // TODO: handle error case
      _playerInitState = InitState.failed;
    }
  }

  void startPlaying() {
    _audioPlayer.play();
  }

  void clearPlayer() {
    _audioPlayer.stop();
    // _audioPlayer.dispose();
  }

  void stopPlayer() {
    _audioPlayer.stop();
    _audioPlayer.seek(const Duration(seconds: 0)); // TODO
  }

  // TODO: get the temp or external dir
  Future<String> _getAudioPath() async {
    try {
      return await getTemporaryDirectory()
          .then((tempDir) => "${tempDir.path}/$loopName.wav");
    } catch (e) {
      // TODO: handle error case
      return nullPath;
    }
  }
}

enum InitState {
  complete,
  failed,
  pending
}

