import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/validators.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../generated/l10n.dart';
import '../../providers/auth_state_providers.dart';

class ForgotPasswordPage extends ConsumerWidget {
  ForgotPasswordPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).forgotPasswordTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            Text(
              S.of(context).forgotPasswordMessage,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (value) =>
                        Validators.validateEmail(context, value),
                    decoration: InputDecoration(
                      labelText: S.of(context).email,
                      prefixIcon: const Icon(Iconsax.direct_right),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        ref
                            .read(authStateNotifierProvider.notifier)
                            .sendPasswordResetEmail(emailController.text);
                        Navigator.pushNamed(context, '/reset-success');
                      },
                      child: Text(S.of(context).sendResetLink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
