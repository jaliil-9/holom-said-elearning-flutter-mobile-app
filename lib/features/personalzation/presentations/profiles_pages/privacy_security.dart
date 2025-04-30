import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/features/authentication/providers/auth_state_providers.dart';
import 'package:holom_said/features/personalzation/presentations/profiles_pages/setting_builds.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/utils/validators.dart';

class PrivacySecurity extends ConsumerWidget {
  const PrivacySecurity({super.key});

  // Change password dialog
  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    String? currentPasswordError;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(S.of(context).changePassword),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: S.of(context).enterCurrentPassword,
                        errorText: currentPasswordError,
                      ),
                      validator: (value) =>
                          Validators.validateEmptyPassword(context, value)),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: S.of(context).enterNewPassword,
                      ),
                      validator: (value) =>
                          Validators.validateNewPassword(context, value)),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: S.of(context).confirmNewPassword,
                      ),
                      validator: (value) => Validators.validateConfirmPassword(
                          context, value, passwordController.text)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () async {
                  // Run validations
                  if (!formKey.currentState!.validate()) {
                    final isValid = await Validators.validateCurrentPassword(
                        context, ref, currentPasswordController.text);

                    if (isValid != null) {
                      // Password validation failed
                      setState(() {
                        currentPasswordError = isValid;
                      });
                      return; // Stop form submission
                    }
                  }

                  await ref
                      .read(authStateNotifierProvider.notifier)
                      .changePassword(passwordController.text,
                          currentPasswordController.text);
                  Navigator.pop(context);
                },
                child: Text(S.of(context).continueText),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).privacySecurity),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Security Section
            SettingBuilds.buildSection(
              context,
              S.of(context).accountSecurity,
              [
                SettingBuilds.buildTile(
                  context,
                  Iconsax.password_check,
                  S.of(context).changePassword,
                  onTap: () => _showChangePasswordDialog(context, ref),
                ),
                SettingBuilds.buildTile(
                  context,
                  Iconsax.user_remove,
                  S.of(context).deleteAccount,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/re-authentication'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
