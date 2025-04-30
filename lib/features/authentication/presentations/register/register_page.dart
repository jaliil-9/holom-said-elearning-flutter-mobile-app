import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/google_sign_in_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/utils/widgets/loading_overlay.dart';
import '../../../../generated/l10n.dart';
import '../../notifiers/auth_state_notifier.dart';
import '../../providers/auth_state_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Removed ref.listen from here.
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateNotifierProvider, (previous, next) {
      if (next is AuthAuthenticatedUser) {
        Navigator.pushNamed(context, '/user_form');
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    final registerState = ref.watch(authUiStateProvider);
    final registerNotifier = ref.read(authUiStateProvider.notifier);

    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcoming message
              Text(S.of(context).welcomeMessage,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: Sizes.spaceBtwItems),

              Text(
                S.of(context).createAccount,
                style: Theme.of(context).textTheme.bodyLarge,
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
                        hintText: S.of(context).emailHint,
                        prefixIcon: const Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !registerState.isPasswordVisible,
                      validator: (value) =>
                          Validators.validateNewPassword(context, value),
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                        hintText: S.of(context).passwordHint,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              registerNotifier.togglePasswordVisibility(),
                          icon: Icon(
                            registerState.isPasswordVisible
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !registerState.isConfirmPasswordVisible,
                      validator: (value) => Validators.validateConfirmPassword(
                          context, value, passwordController.text),
                      decoration: InputDecoration(
                        labelText: S.of(context).confirmPassword,
                        hintText: S.of(context).confirmPasswordHint,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          onPressed: () => registerNotifier
                              .toggleConfirmPasswordVisibility(),
                          icon: Icon(
                            registerState.isConfirmPasswordVisible
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            await ref
                                .read(authStateNotifierProvider.notifier)
                                .register(email, password);
                          }
                        },
                        child: Text(S.of(context).continueText),
                      ),
                    ),
                    SizedBox(
                      height: Sizes.spaceBtwItems,
                    ),
                    // Register option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${S.of(context).hasAccount} '),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(S.of(context).login,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    // Divider
                    const SizedBox(height: Sizes.spaceBtwSections),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(),
                          ),
                          const SizedBox(width: Sizes.spaceBtwItems),
                          Text(
                            S.of(context).or,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: Sizes.spaceBtwItems),
                          Expanded(
                            child: Divider(),
                          )
                        ],
                      ),
                    ),

                    // Social Sign in
                    const SizedBox(height: Sizes.spaceBtwSections),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GoogleSignInCard(
                        onTap: () async {
                          await ref
                              .read(authStateNotifierProvider.notifier)
                              .googleSignIn();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (ref.watch(authStateNotifierProvider) is AuthLoading)
          const LoadingOverlay()
      ]),
    );
  }
}
