import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/base_profile.dart';

abstract class BaseProfileNotifier extends AsyncNotifier<BaseProfile?> {
  Future<BaseProfile?> getCurrentProfile();
  Future<String?> pickAndUploadImage(String userId);
  Future<void> saveProfileChanges({
    required String userId,
    String? firstName,
    String? lastName,
    String? profilePicture,
  });
}
