import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../utils/helper_methods/error.dart';
import '../../../generated/l10n.dart';

class StorageService {
  static Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        if (Platform.version.contains('13')) {
          // For Android 13 and above, request photos permission
          final photosStatus = await Permission.photos.request();
          if (photosStatus.isDenied) {
            ErrorUtils.showErrorSnackBar(S.current.mediaPermissionDenied);
            return false;
          }
          return photosStatus.isGranted;
        } else {
          // For Android 12 and below, request storage permission
          final storageStatus = await Permission.storage.request();
          if (storageStatus.isDenied) {
            ErrorUtils.showErrorSnackBar(S.current.storagePermissionDenied);
            return false;
          }
          return storageStatus.isGranted;
        }
      } else if (Platform.isIOS) {
        final photosStatus = await Permission.photos.request();
        if (photosStatus.isDenied) {
          ErrorUtils.showErrorSnackBar(S.current.mediaPermissionDenied);
          return false;
        }
        return photosStatus.isGranted;
      }
      return false;
    } catch (e) {
      ErrorUtils.showErrorSnackBar(S.current.permissionError);
      return false;
    }
  }
}
