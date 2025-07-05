import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../utils/helper_methods/error.dart';
import '../../../generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:holom_said/core/utils/permission_dialog.dart';

class StorageService {
  static Future<bool> requestStoragePermission(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final sdkVersion = androidInfo.version.sdkInt;

        if (sdkVersion >= 33) {
          // Android 13 or higher
          return await PermissionManager.requestPermissionWithDialog(
            context,
            permission: Permission.photos,
            title: S.of(context).mediaPermissionTitle,
            content: S.of(context).mediaPermissionBody,
          );
        } else {
          return await PermissionManager.requestPermissionWithDialog(
            context,
            permission: Permission.storage,
            title: S.of(context).storagePermissionTitle,
            content: S.of(context).storagePermissionBody,
          );
        }
      } else if (Platform.isIOS) {
        return await PermissionManager.requestPermissionWithDialog(
          context,
          permission: Permission.photos,
          title: S.of(context).mediaPermissionTitle,
          content: S.of(context).mediaPermissionBody,
        );
      }
      return false;
    } catch (e) {
      ErrorUtils.showErrorSnackBar(S.current.permissionError);
      return false;
    }
  }
}
