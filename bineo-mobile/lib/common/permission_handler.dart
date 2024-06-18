import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  PermissionHandler._();

  static Future<bool> requestLocationPermission() async {
    // Check if location services are enabled
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!locationServiceEnabled) return false;

    // Check for location permission
    LocationPermission permissionStatus = await Geolocator.checkPermission();

    if (!PermissionHandler._hasLocationPermission(permissionStatus)) {
      // If the app doesn't have location permission, request it
      permissionStatus = await Geolocator.requestPermission();

      if (PermissionHandler._hasLocationPermission(permissionStatus)) {
        return true;
      } else {
        return false;
      }
    }

    return true;
  }

  static Future<bool> requestNotificationsPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isProvisional || status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static bool _hasLocationPermission(LocationPermission permission) {
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  //camera permission
  static Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
