import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import '../models/base_profile.dart';
import '../notifiers/admin_profile_notifier.dart';
import '../notifiers/user_profile_notifier.dart';
import '../notifiers/base_profile_notifier.dart';
import '../repositories/admin_repository.dart';
import '../repositories/user_repository.dart';

final adminRepositoryProvider =
    Provider<AdminRepository>((ref) => AdminRepository());

final adminProfileProvider =
    AsyncNotifierProvider<AdminProfileNotifier, BaseProfile?>(
  AdminProfileNotifier.new,
);

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository());

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, BaseProfile?>(
  UserProfileNotifier.new,
);

// Provider to choose the current provider to use based on the user type
// (admin or user)
final currentProfileProvider = Provider<BaseProfileNotifier>((ref) {
  final storage = GetStorage();
  final isAdmin = storage.read('authType') == 'admin';

  if (isAdmin) {
    return ref.watch(adminProfileProvider.notifier);
  } else {
    return ref.watch(userProfileProvider.notifier);
  }
});
