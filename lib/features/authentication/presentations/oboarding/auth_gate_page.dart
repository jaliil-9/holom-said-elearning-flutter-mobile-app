import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/utils/clippers/wave_clipper.dart';
import '../../../../generated/l10n.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Top section with animated illustration
          Container(
            height: size.height * 0.55,
            width: double.infinity,
            color: theme.scaffoldBackgroundColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated circles
                _buildAnimatedCircle(
                  top: size.height * 0.1,
                  left: size.width * 0.1,
                  size: 100,
                  color: theme.primaryColor.withValues(alpha: 0.2),
                  duration: const Duration(seconds: 5),
                ),
                _buildAnimatedCircle(
                  top: size.height * 0.05,
                  right: size.width * 0.2,
                  size: 60,
                  color: Colors.orange.withValues(alpha: 0.15),
                  duration: const Duration(seconds: 7),
                ),
                _buildAnimatedCircle(
                  bottom: size.height * 0.1,
                  right: size.width * 0.05,
                  size: 80,
                  color: Colors.blue.withValues(alpha: 0.15),
                  duration: const Duration(seconds: 6),
                ),

                // Logo and illustration
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/happy_dream_logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),

                    // Learning illustration
                    Container(
                      width: size.width * 0.7,
                      height: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusLg),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    theme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(Sizes.borderRadiusLg),
                                  bottomRight:
                                      Radius.circular(Sizes.borderRadiusLg),
                                ),
                              ),
                            ),
                          ),

                          // Stylized people silhouettes
                          Positioned(
                            bottom: 30,
                            left: size.width * 0.1,
                            child: _buildPersonIcon(
                              color: theme.primaryColor,
                              size: 50,
                              icon: Iconsax.teacher,
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: size.width * 0.3,
                            child: _buildPersonIcon(
                              color: Colors.orange,
                              size: 40,
                              icon: Iconsax.user,
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            right: size.width * 0.2,
                            child: _buildPersonIcon(
                              color: Colors.blue,
                              size: 45,
                              icon: Iconsax.user,
                            ),
                          ),

                          // Knowledge sharing visualization
                          Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildThoughtBubble(theme.primaryColor),
                                const SizedBox(width: 8),
                                _buildThoughtBubble(Colors.orange),
                                const SizedBox(width: 8),
                                _buildThoughtBubble(Colors.blue),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom wave section with auth buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: size.height * 0.6,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.defaultSpace,
                    70,
                    Sizes.defaultSpace,
                    Sizes.defaultSpace,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).welcomeMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Text(
                        S.of(context).appSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceBtwSections * 1.5),

                      // Join button with animation
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: Text(S.of(context).createAccount),
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceBtwItems),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login'),
                          child: Text(S.of(context).login),
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    required Color color,
    required Duration duration,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1.2),
        duration: duration,
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          );
        },
        onEnd: () {},
      ),
    );
  }

  Widget _buildPersonIcon({
    required Color color,
    required double size,
    required IconData icon,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildThoughtBubble(Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Iconsax.book,
        color: color,
        size: 16,
      ),
    );
  }
}
