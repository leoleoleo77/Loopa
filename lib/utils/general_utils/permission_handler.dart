import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  const PermissionHandler();

  static Future<void> _requestAudioPermissions() async {
    // Request microphone permission
    PermissionStatus micStatus = await Permission.microphone.request();

    // Check if permissions are granted
    if (micStatus.isGranted) {
      return;
    }

    // TODO: handle this better
    // Handle denied permissions
    if (micStatus.isPermanentlyDenied) {
      openAppSettings(); // Redirect user to app settings
    }

    return;
  }

  static Future<void> requestPermissions() async {
    _requestAudioPermissions();
  }
}