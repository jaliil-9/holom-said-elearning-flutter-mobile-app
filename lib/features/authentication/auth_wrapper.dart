// auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers/auth_state_notifier.dart';
import 'providers/auth_state_providers.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to state changes for redirection.
    ref.listen<AuthState>(authStateNotifierProvider, (previous, next) {
      if (next is AuthAuthenticatedAdmin) {
        Navigator.pushReplacementNamed(context, '/admin-home-page');
      } else if (next is AuthAuthenticatedUser) {
        Navigator.pushReplacementNamed(context, '/user-home-page');
      } else if (next is AuthUnauthenticated) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });

    final authState = ref.watch(authStateNotifierProvider);
    if (authState is AuthLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // A splash or placeholder screen.
    return const Scaffold(
      body: Center(child: Text('Loading...')),
    );
  }
}
