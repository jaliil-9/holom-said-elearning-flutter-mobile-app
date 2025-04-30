import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/validators.dart';
import 'package:holom_said/features/authentication/providers/auth_state_providers.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../generated/l10n.dart';

class ReAuthentication extends ConsumerWidget {
  ReAuthentication({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).reAuthentication),
        ),
        body: Padding(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Column(children: [
              const SizedBox(height: Sizes.spaceBtwSections),
              const Icon(Iconsax.lock, size: 80),
              const SizedBox(height: Sizes.spaceBtwSections),
              Text(
                S.of(context).reAuthenticationMessage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _emailController,
                      validator: (value) =>
                          Validators.validateEmail(context, value),
                      decoration: InputDecoration(
                        labelText: S.of(context).email,
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                          Validators.validateEmptyPassword(context, value),
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: Sizes.defaultSpace),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Call the re-authentication method
                            ref
                                .read(authStateNotifierProvider.notifier)
                                .deleteAccount(_emailController.text,
                                    _passwordController.text);
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          }
                        },
                        child: Text(S.of(context).deleteAccount),
                      ),
                    )
                  ]))
            ])));
  }
}
