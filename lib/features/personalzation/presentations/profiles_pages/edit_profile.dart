// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/features/personalzation/models/base_profile.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../generated/l10n.dart';
import '../../providers/profile_providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final profileNotifier = ref.read(currentProfileProvider);
      final profile = profileNotifier.getCurrentProfile();
      profile.then((value) {
        if (value != null) {
          _firstNameController.text = value.firstname;
          _lastNameController.text = value.lastname;
        }
      });
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final storage = GetStorage();
    final isAdmin = storage.read('authType') == 'admin';
    final profileNotifier = isAdmin
        ? ref.watch(adminProfileProvider.notifier)
        : ref.watch(userProfileProvider.notifier);
    // ignore: invalid_use_of_protected_member
    final profile = ref.watch(currentProfileProvider.select((p) => p.state));

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).editProfile)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                          width: 4,
                        ),
                      ),
                      child: profile.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Icon(Iconsax.user, size: 50),
                        data: (user) => ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: user?.profilePicture != null &&
                                  user!.profilePicture.isNotEmpty
                              ? Image.network(user.profilePicture,
                                  fit: BoxFit.cover)
                              : const Icon(Iconsax.user, size: 50),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          if (profile.value != null) {
                            if (isAdmin) {
                              await ref
                                  .read(adminProfileProvider.notifier)
                                  .pickAndUploadImage(profile.value!.id);
                            } else {
                              await ref
                                  .read(userProfileProvider.notifier)
                                  .pickAndUploadImage(profile.value!.id);
                            }
                            // Invalidate both providers to refresh UI
                            ref.invalidate(userProfileProvider);
                            ref.invalidate(adminProfileProvider);
                            ref.invalidate(currentProfileProvider);
                          }
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: const Icon(
                            Iconsax.camera,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: profile.when(
                        data: (user) => user?.profilePicture != null &&
                                user!.profilePicture.isNotEmpty
                            ? InkWell(
                                onTap: () =>
                                    _showDeletePictureDialog(context, profile),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red,
                                  ),
                                  child: const Icon(
                                    Iconsax.trash,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: S.of(context).firstName,
                  prefixIcon: const Icon(Iconsax.user),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).requiredField;
                  }
                  return null;
                },
              ),

              const SizedBox(height: Sizes.spaceBtwItems),

              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: S.of(context).lastName,
                  prefixIcon: const Icon(Iconsax.user),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).requiredField;
                  }
                  return null;
                },
              ),

              const SizedBox(height: Sizes.spaceBtwSections * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        profile.value != null) {
                      profileNotifier.saveProfileChanges(
                        userId: profile.value!.id,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        profilePicture: profile.value!.profilePicture,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(S.of(context).save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletePictureDialog(
      BuildContext context, AsyncValue<BaseProfile?> profile) {
    final storage = GetStorage();
    final isAdmin = storage.read('authType') == 'admin';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteProfilePicture),
        content: Text(S.of(context).deleteProfilePictureConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (profile.value != null) {
                if (isAdmin) {
                  await ref
                      .read(adminProfileProvider.notifier)
                      .deleteProfilePicture(profile.value!.id);
                } else {
                  await ref
                      .read(userProfileProvider.notifier)
                      .deleteProfilePicture(profile.value!.id);
                }
                // Refresh the UI
                ref.invalidate(userProfileProvider);
                ref.invalidate(adminProfileProvider);
                ref.invalidate(currentProfileProvider);
              }
            },
            child: Text(
              S.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
