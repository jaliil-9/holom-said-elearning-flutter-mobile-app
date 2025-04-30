import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/generated/l10n.dart';

import '../../features/authentication/providers/auth_state_providers.dart';

class Validators {
  static String? validateEmptyField(context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).thisFieldIsRequired;
    }
    return null;
  }

  static String? validateEmail(context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterEmail;
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value)) {
      return S.of(context).pleaseEnterValidEmail;
    }
    return null;
  }

  static Future<String?> validateCurrentPassword(
      BuildContext context, WidgetRef ref, String? value) async {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterPassword;
    }

    // Get email from the auth state
    final authState = ref.read(authRepositoryProvider);
    final email = authState.currentUser?.email;
    if (email == null) {
      return S.of(context).authError;
    }

    // Get auth notifier to check password
    final authNotifier = ref.read(authStateNotifierProvider.notifier);
    final isValid = await authNotifier.reauthenticate(email, value);

    if (!isValid) {
      return S.of(context).passwordIncorrect;
    }

    return null;
  }

  static String? validateEmptyPassword(context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enterCurrentPassword;
    }
    return null;
  }

  static String? validateNewPassword(context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).newPasswordCannotBeEmpty;
    }
    if (value.length < 6) {
      return S.of(context).newPasswordMustBeAtLeast6CharactersLong;
    }
    return null;
  }

  static String? validateConfirmPassword(
      context, String? value, String? newPassword) {
    if (value != newPassword) {
      return S.of(context).confirmPasswordMustMatch;
    }
    return null;
  }
}
