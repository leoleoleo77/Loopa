import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioController {
  final String loopName;
  late final AudioPlayer _audioPlayer;
  late final AudioRecorder _audioRecorder;
  late InitState _playerInitState;
  late InitState _recorderInitState;
  static const nullPath = "NULL_PATH";

  AudioController({
    required this.loopName,
  }) {

    _initPlayer();
  }

  Future<void> _initRecorder() async {
    _audioRecorder = AudioRecorder();

  }

  Future<void> _initPlayer() async {
    _playerInitState = InitState.pending;
    _audioPlayer = AudioPlayer();
    final String audioPath = await _getPath();
    try {
      await _audioPlayer.setFilePath(audioPath);
      _playerInitState = InitState.complete;
    } catch (e) {
      // TODO: handle error case
      _playerInitState = InitState.failed;
    }
  }

  void playAudio() {
    _audioPlayer.play();
  }

  void clearPlayer() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }

  void stopPlayer() {
    _audioPlayer.stop();
  }

  // TODO: get the temp or external dir
  Future<String> _getPath() async {
    try {
      return await getTemporaryDirectory()
          .then((tempDir) => "$tempDir/$loopName.wav");
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

