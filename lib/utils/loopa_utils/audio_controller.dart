import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:loopa/utils/general_utils/permission_handler.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/log_utils/app_log.dart';
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
    if (_loopa.isStateIdle) await _initPlayer();
  }

  String get path => _path ?? _nullPath;

  Future<void> startRecording() async {
    try {
      await _audioRecorder?.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: _path ?? _nullPath,
      );
    } catch(e) {
      DebugLog.error(e);
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
      await _audioPlayer?.setFilePath(path);
      await _audioPlayer?.setLoopMode(LoopMode.one);
    } catch (e) {
      DebugLog.error(e);
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
    if (await PermissionHandler.canUseExternalStorage) {
      if (Platform.isAndroid) return _getPathFromDir(await _androidExternalDir);
      if (Platform.isIOS) return _getPathFromDir(await _iOSExternalDir);
      DebugLog.warning("Unsupported platform: ${Platform.operatingSystem}");
    } else {
      return _getPathFromDir(await _temporaryDir);
    }
    return null;
  }


  Future<Directory?> get _temporaryDir async {
    try {
      return await getTemporaryDirectory();
    } catch (e) {
      DebugLog.error(e);
      return null;
    }
  }

  Future<Directory?> get _androidExternalDir async {
    try {
      return await getExternalStorageDirectory();
    } catch (e) {
      DebugLog.error(e);
      return _temporaryDir;
    }
  }

  Future<Directory?> get _iOSExternalDir async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      DebugLog.error(e);
      return _temporaryDir;
    }
  }

  String? _getPathFromDir(Directory? dir) {
    if (dir == null) {
      DebugLog.warning("Failed to get Directory for ${_loopa.name}");
      return null;
    } else {
      DebugLog.info("${_loopa.name} saved at ${dir.path}/${_loopa.name}.wav");
      return "${dir.path}/${_loopa.name}.wav";
    }
  }

}

