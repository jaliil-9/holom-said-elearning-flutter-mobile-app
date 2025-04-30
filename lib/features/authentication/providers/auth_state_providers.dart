import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/features/authentication/notifiers/auth_ui_notifier.dart';

import '../notifiers/auth_state_notifier.dart';
import '../repositories/auth_repository.dart';

final authUiStateProvider =
    StateNotifierProvider<AuthUiNotifier, AuthUiState>((ref) {
  return AuthUiNotifier();
});

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final authStateNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository: repo);
});
