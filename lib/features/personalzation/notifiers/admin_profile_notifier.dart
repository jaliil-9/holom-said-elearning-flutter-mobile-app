import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/utils/helper_methods/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/helper_methods/error.dart';
import '../../../core/utils/helper_methods/network.dart';
import '../../../generated/l10n.dart';
import '../providers/profile_providers.dart';
import '../repositories/admin_repository.dart';
import '../models/base_profile.dart';
import 'base_profile_notifier.dart';

class AdminProfileNotifier extends BaseProfileNotifier {
  late final AdminRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<BaseProfile?> build() async {
    _repository = ref.read(adminRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);
    return getCurrentProfile();
  }

  @override
  Future<BaseProfile?> getCurrentProfile() async {
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw const SocketException('No internet connection');
      }

      final adminId = AuthHelper.getCurrentUserId();
      if (adminId == null) return null;

      return await _repository.getUserById(adminId);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> saveProfileChanges({
    required String userId,
    String? firstName,
    String? lastName,
    String? profilePicture,
  }) async {
    state = await AsyncValue.guard(() async {
      try {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          throw SocketException(S.current.networkError);
        }

        await _repository.updateProfile(
          adminId: userId,
          firstName: firstName,
          lastName: lastName,
        );

        ErrorUtils.showSuccessSnackBar(S.current.profileUpdateSuccess);
        return getCurrentProfile();
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });
  }

  @override
  Future<String?> pickAndUploadImage(String userId) async {
    state = await AsyncValue.guard(() async {
      try {
        final currentProfilePicture = state.value?.profilePicture;

        // Upload image and get URL
        final imageUrl = await Helpers.uploadImage();
        if (imageUrl == null) return state.value;

        // Update profile with new image URL
        await _repository.updateProfilePicture(
          userId: userId,
          profilePictureUrl: imageUrl,
        );

        // Delete old profile picture if it exists
        if (currentProfilePicture != null && currentProfilePicture.isNotEmpty) {
          final uri = Uri.parse(currentProfilePicture);
          final filename = uri.pathSegments.last;
          await Supabase.instance.client.storage
              .from('profile-images')
              .remove([filename]);
        }

        // Get and return the updated profile
        final updatedProfile = await getCurrentProfile();
        ErrorUtils.showSuccessSnackBar(S.current.imageUploadSuccess);
        return updatedProfile;
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });

    return state.value?.profilePicture;
  }

  Future<void> deleteProfilePicture(String userId) async {
    state = await AsyncValue.guard(() async {
      try {
        final profilePictureUrl = state.value?.profilePicture;
        if (profilePictureUrl != null) {
          await _repository.deleteProfilePicture(userId, profilePictureUrl);
        }
        return getCurrentProfile();
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });
  }
}
