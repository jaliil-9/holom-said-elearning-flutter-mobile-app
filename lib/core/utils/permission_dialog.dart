
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:holom_said/generated/l10n.dart';

/// A utility class to handle permission requests with a pre-request dialog.
class PermissionManager {
  /// Shows a dialog to explain why a permission is needed, then requests the permission if the user agrees.
  ///
  /// [context]: The BuildContext from the widget calling this.
  /// [permission]: The permission to request (e.g., Permission.storage).
  /// [title]: The title for the explanation dialog.
  /// [content]: The detailed explanation for why the permission is required.
  ///
  /// Returns `true` if the permission is granted, `false` otherwise.
  static Future<bool> requestPermissionWithDialog(
    BuildContext context, {
    required Permission permission,
    required String title,
    required String content,
  }) async {
    // First, show the explanation dialog.
    final bool didAgree = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  child: Text(S.of(dialogContext).cancel),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false); // User did not agree
                  },
                ),
                TextButton(
                  child: Text(S.of(dialogContext).allow),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true); // User agreed
                  },
                ),
              ],
            );
          },
        ) ??
        false; // If dialog is dismissed, treat as disagreement

    // If the user agreed, then request the actual system permission.
    if (didAgree) {
      final PermissionStatus status = await permission.request();
      return status.isGranted;
    }

    // If the user did not agree, do not request permission.
    return false;
  }
}

