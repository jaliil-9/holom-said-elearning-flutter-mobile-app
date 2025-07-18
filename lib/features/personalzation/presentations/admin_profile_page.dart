import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/providers/locale_provider.dart';
import 'package:holom_said/core/utils/clippers/curved_border_clipper.dart';
import 'package:holom_said/core/utils/widgets/language_setting_tile.dart';
import 'package:holom_said/core/utils/widgets/profile_setting_tile.dart';
import 'package:holom_said/core/utils/widgets/toggle_setting_tile.dart';
import 'package:iconsax/iconsax.dart';
import 'package:holom_said/core/utils/widgets/custom_shimmer.dart';
import 'package:holom_said/generated/l10n.dart';
import '../../../core/utils/helper_methods/helpers.dart';
import '../../../core/utils/widgets/circular_container.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/utils/widgets/loading_overlay.dart';
import '../../authentication/notifiers/auth_state_notifier.dart';
import '../../authentication/providers/auth_state_providers.dart';
import '../providers/profile_providers.dart';
import '../../../core/providers/notification_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final notificationsEnabled = ref.watch(notificationProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    ref.listen(adminProfileProvider, (previous, next) {
      if (previous == null) {
        ref.read(adminProfileProvider.notifier).getCurrentProfile();
      }
    });

    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Section
                ClipPath(
                  clipper: CurvedBorderClipper(),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withAlpha(180),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -220,
                          right: -200,
                          child: CircularContainer(),
                        ),
                        Positioned(
                          top: 60,
                          right: -120,
                          child: CircularContainer(),
                        ),
                        Center(
                          child: ref.watch(adminProfileProvider).when(
                              data: (data) {
                                return Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).padding.top),
                                    // Profile Picture
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: data != null
                                            ? DecorationImage(
                                                image: Helpers.getImageProvider(
                                                    data.profilePicture),
                                                fit: BoxFit.cover,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/user.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Full Name
                                    Text(
                                      data != null
                                          ? '${data.firstname} ${data.lastname}'
                                          : S.of(context).admin,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Email
                                    Text(
                                      data != null
                                          ? data.email
                                          : 'mail@example.com',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => ProfileHeaderSectionShimmer(),
                              error: (error, stack) =>
                                  ProfileHeaderSectionShimmer()),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Info Section
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: Sizes.sm),
                          Text(S.of(context).accountInfo,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusLg),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.md),
                          child: Column(
                            children: [
                              ProfileSettingTile(
                                icon: Iconsax.user,
                                title: S.of(context).editProfile,
                                subtitle: S.of(context).personalInfo,
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/edit-profile'),
                              ),
                              const Divider(),
                              ProfileSettingTile(
                                icon: Iconsax.security_card,
                                title: S.of(context).privacySecurity,
                                subtitle: '',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/privacy-security'),
                              ),
                              const Divider(),
                              ToggleSettingTile(
                                icon: Iconsax.notification,
                                title: S.of(context).notifications,
                                value: notificationsEnabled,
                                onChanged: (value) => ref
                                    .read(notificationProvider.notifier)
                                    .toggleNotifications(context),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceBtwSections),

                      // App Settings Section
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: Sizes.sm),
                          Text(S.of(context).appSettings,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusLg),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.md),
                          child: Column(
                            children: [
                              ToggleSettingTile(
                                icon: isDarkMode ? Iconsax.moon : Iconsax.sun_1,
                                title: S.of(context).darkMode,
                                value: isDarkMode,
                                onChanged: (value) => ref
                                    .read(themeProvider.notifier)
                                    .toggleTheme(),
                              ),
                              const Divider(),
                              LanguageSettingTile(
                                context: context,
                                currentLocale: locale,
                                onChanged: (languageCode) {
                                  if (languageCode != null) {
                                    ref
                                        .read(localeProvider.notifier)
                                        .setLocale(languageCode);
                                  }
                                },
                              ),
                              const Divider(),
                              ProfileSettingTile(
                                icon: Icons.swap_horiz_rounded,
                                title: S.of(context).switchToUser,
                                subtitle: '',
                                onTap: () {
                                  ref
                                      .read(authStateNotifierProvider.notifier)
                                      .switchToUserPreview();
                                  Navigator.pushNamed(
                                      context, '/user-home-page');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceBtwSections),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(S.of(context).logoutConfirmation),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(S.of(context).cancel),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(S.of(context).logout,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              // Just call logout - it now handles all cleanup
                              await ref
                                  .read(authStateNotifierProvider.notifier)
                                  .logout();
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                          },
                          icon: const Icon(Iconsax.logout, color: Colors.red),
                          label: Text(
                            S.of(context).logout,
                            style: const TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (ref.watch(authStateNotifierProvider) is AuthLoading)
          const LoadingOverlay()
      ]),
    );
  }
}

class ProfileHeaderSectionShimmer extends StatelessWidget {
  const ProfileHeaderSectionShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        // Shimmer for profile picture
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const CustomShimmer(
            width: 120,
            height: 120,
            shapeBorder: CircleBorder(),
          ),
        ),
        const SizedBox(height: 16),
        // Shimmer for full name
        CustomShimmer(
          width: 200,
          height: 28,
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Shimmer for email
        CustomShimmer(
          width: 180,
          height: 16,
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
