import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../../generated/l10n.dart';
import '../providers/subscribers_provider.dart';
import '../repositories/subscribers_repository.dart';

class AdminsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  late final SubscribersRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<List<Map<String, dynamic>>> build() async {
    _repository = ref.read(subscribersRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    final admins = await _repository.fetchAdmins();
    // Filter out the current admin
    final currentAdminId = Supabase.instance.client.auth.currentUser?.id;
    return currentAdminId != null
        ? admins
            .where((admin) => admin['id'].toString() != currentAdminId)
            .toList()
        : admins;
  }
}

class UsersNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  late final SubscribersRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<List<Map<String, dynamic>>> build() async {
    _repository = ref.read(subscribersRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    return _repository.fetchUsers();
  }
}
