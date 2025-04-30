import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/subscribers_repository.dart';
import '../notifiers/subscribers_notifier.dart';

final subscribersRepositoryProvider = Provider<SubscribersRepository>((ref) {
  final client = Supabase.instance.client;
  return SubscribersRepository(client);
});

final adminsSubsProvider =
    AsyncNotifierProvider<AdminsNotifier, List<Map<String, dynamic>>>(() {
  return AdminsNotifier();
});

final usersSubsProvider =
    AsyncNotifierProvider<UsersNotifier, List<Map<String, dynamic>>>(() {
  return UsersNotifier();
});
