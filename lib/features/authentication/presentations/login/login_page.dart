import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/google_sign_in_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holom_said/core/utils/widgets/loading_overlay.dart'; // Added import

import '../../../../core/utils/validators.dart';
import '../../../../generated/l10n.dart';
import '../../notifiers/auth_state_notifier.dart';
import '../../providers/auth_state_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final rememberedEmail = GetStorage().read('rememberedEmail') ?? "";
    emailController.text = rememberedEmail;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes for navigation and error handling
    ref.listen(authStateNotifierProvider, (previous, state) {
      if (state is AuthAuthenticatedUser) {
        Navigator.pushReplacementNamed(context, '/user-home-page');
      } else if (state is AuthAuthenticatedAdmin) {
        Navigator.pushReplacementNamed(context, '/admin-home-page');
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });

    final loginState = ref.watch(authUiStateProvider);
    final loginNotifier = ref.read(authUiStateProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // Main login content
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
                  S.of(context).appSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: Sizes.spaceBtwSections),

                // Email textfield
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

                      const SizedBox(height: Sizes.spaceBtwItems),

                      // Password textfield
                      TextFormField(
                        controller: passwordController,
                        obscureText: !loginState.isPasswordVisible,
                        validator: (value) =>
                            Validators.validateEmptyPassword(context, value),
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          hintText: S.of(context).passwordHint,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                loginNotifier.togglePasswordVisibility(),
                            icon: Icon(
                              loginState.isPasswordVisible
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash,
                            ),
                          ),
                        ),
                      ),

                      // Remember me & Forgot Password
                      Row(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: loginState.rememberMe,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (_) =>
                                    loginNotifier.toggleRememberMe(),
                              ),
                              Text(S.of(context).rememberMe),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, '/forgot-password'),
                            child: Text(
                              S.of(context).forgotPassword,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: Sizes.spaceBtwItems,
                      ),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              loginNotifier.updateRememberedEmail(email);
                              await ref
                                  .read(authStateNotifierProvider.notifier)
                                  .login(email, password);
                            }
                          },
                          child: Text(S.of(context).login),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: Sizes.spaceBtwItems,
                ),

                // Register option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${S.of(context).noAccount} '),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: Text(S.of(context).createNewAccount,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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
          // Loading overlay when signing in
          if (ref.watch(authStateNotifierProvider) is AuthLoading)
            const LoadingOverlay()
        ],
      ),
    );
  }
}
