import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/log_utils/app_log.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  const PermissionHandler();

  static Future<void> requestPermissions() async {
    await _requestAudioPermissions();
    await _requestStoragePermissions();
  }

  static Future<bool> get canUseExternalStorage async {
    if (await _shouldHaveStoragePermissions) {
      return Permission.storage.isGranted;
    } else {
      return true;
    }
  }

  static Future<void> _requestAudioPermissions() async {
    await Permission.microphone.request().then(
            (status) => _handlePermissionRequest(status, LoopaConstants.microphone));
  }

  static Future<void> _requestStoragePermissions() async {
    if (await _shouldHaveStoragePermissions) {
      await Permission.storage.request().then(
              (status) => _handlePermissionRequest(status, LoopaConstants.storage));
    } else {
      DebugLog.info("No ${LoopaConstants.storage} permission needed");
    }
  }

  static void _handlePermissionRequest(
      PermissionStatus status,
      String permissionName
  ) {
    switch (status) {
      case PermissionStatus.granted:
        DebugLog.info("$permissionName permission granted");
        break;
      case PermissionStatus.denied:
        DebugLog.info("$permissionName permission denied");
        break;
      case PermissionStatus.permanentlyDenied:
        DebugLog.info("$permissionName permission permanently denied");
        openAppSettings();
        break;
      case PermissionStatus.restricted:
        DebugLog.info("$permissionName permission restricted");
        break;
      case PermissionStatus.limited:
        DebugLog.info("$permissionName permission limited");
        break;
      case PermissionStatus.provisional:
        DebugLog.info("$permissionName permission provisional");
    }
  }

  static Future<bool> get _shouldHaveStoragePermissions async {
    if (Platform.isAndroid == false) return false;

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.version.sdkInt <= LoopaConstants.androidSdkVersionThreshold;
  }
}