import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../generated/l10n.dart';

class ErrorUtils {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get _context => navigatorKey.currentContext;

  /// Shows a snackbar with an error message
  static void showErrorSnackBar(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'X',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Shows a success snackbar
  static void showSuccessSnackBar(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'x',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Gets the localized error message
  static String getErrorMessage(Object error) {
    if (_context == null) return error.toString();

    if (error is SocketException ||
        error.toString().contains('SocketException') ||
        error.toString().contains('No internet connection')) {
      return S.of(_context!).networkError;
    } else if (error is StorageException) {
      return S.of(_context!).storageError;
    } else if (error is AuthException) {
      return S.of(_context!).authError;
    } else if (error is PostgrestException) {
      return S.of(_context!).databaseError;
    } else {
      return S.of(_context!).unknownError;
    }
  }
}
