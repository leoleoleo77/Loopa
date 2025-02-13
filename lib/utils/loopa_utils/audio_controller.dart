import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/misc_utils/app_log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioController {
  static const _nullPath = "NULL_PATH";

  final Loopa _loopa;
  AudioPlayer? _audioPlayer;
  AudioRecorder? _audioRecorder;
  String? _path;

  AudioController(this._loopa) {
    _initController();
  }

  void _initController() async {
    _path = await _getPath;
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
    if (_useExternalStorage) _initPlayer();
  }

  bool get _useExternalStorage => _loopa.isSaved;

  String? get path => _path;

  Future<void> startRecording() async {
    try {
      await _audioRecorder?.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: _path ?? _nullPath,
      );
    } catch(e) {
      AppLog.error(e);
    }
  }

  Future<void> beginLooping() async {
    await clearRecording();
    await _initPlayer();
    startPlaying();
  }

  Future<void> clearRecording() async {
    await _audioRecorder?.stop();
    // _audioRecorder.dispose();
  }

  Future<void> _initPlayer() async {
    try {
      await _audioPlayer?.setFilePath(_path ?? _nullPath);
      await _audioPlayer?.setLoopMode(LoopMode.one);
    } catch (e) {
      AppLog.error(e);
    }
  }

  void startPlaying() {
    _audioPlayer?.play();
  }

  void clearPlayer() {
    _audioPlayer?.stop();
    // _audioPlayer?.dispose();
  }

  void stopPlayer() {
    _audioPlayer?.stop();
    _audioPlayer?.seek(const Duration(seconds: 0)); // TODO
  }

  Future<void> updatePath() async {
    _path = await _getPath;
  }

  Future<String?> get _getPath async {
    if (_useExternalStorage) {
      if (Platform.isAndroid) return _getPathFromDir(await _androidExternalDir);
      if (Platform.isIOS) return _getPathFromDir(await _iOSExternalDir);
    } else {
      return _getPathFromDir(await _temporaryDir);
    }
    return null;
  }


  Future<Directory?> get _temporaryDir async {
    try {
      return await getTemporaryDirectory();
    } catch (e) {
      AppLog.error(e);
      return null;
    }
  }

  Future<Directory?> get _androidExternalDir async {
    try {
      return await getExternalStorageDirectory();
    } catch (e) {
      AppLog.error(e);
      return _temporaryDir;
    }
  }

  Future<Directory?> get _iOSExternalDir async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      AppLog.error(e);
      return _temporaryDir;
    }
  }

  String? _getPathFromDir(Directory? dir) {
    if (dir == null) {
      AppLog.warning("Failed to get Directory for ${_loopa.name}");
      return null;
    } else {
      AppLog.info("${_loopa.name} saved at ${dir.path}/${_loopa.name}.wav");
      return "${dir.path}/${_loopa.name}.wav";
    }
  }

}

