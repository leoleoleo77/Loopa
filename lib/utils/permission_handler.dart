import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  const PermissionHandler();

  Future<bool> requestAudioPermissions() async {
    // Request microphone permission
    PermissionStatus micStatus = await Permission.microphone.request();

    // Check if permissions are granted
    if (micStatus.isGranted) {
      return true;
    }

    // TODO: handle this better
    // Handle denied permissions
    if (micStatus.isPermanentlyDenied) {
      openAppSettings(); // Redirect user to app settings
    }

    return false;
  }
}