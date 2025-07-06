import 'dart:async';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:holom_said/core/utils/helper_methods/helpers.dart';
import 'package:holom_said/core/utils/helper_methods/network.dart';
import 'package:holom_said/features/personalzation/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/utils/helper_methods/error.dart';
import '../../../generated/l10n.dart';
import '../../personalzation/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Authentication states representing different user authentication scenarios.
/// Each state represents a distinct authentication status in the application.
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticatedAdmin extends AuthState {
  final User user;
  const AuthAuthenticatedAdmin(this.user);
}

class AuthAuthenticatedUser extends AuthState {
  final User user;
  const AuthAuthenticatedUser(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthAdminPreviewUser extends AuthState {
  final User user;
  const AuthAdminPreviewUser(this.user);
}

/// A state notifier that manages authentication state and operations.
///
/// This notifier handles:
/// * User authentication (login, register, social auth)
/// * Session management
/// * Password operations
/// * Account management
/// * Admin/User role switching
///
/// It maintains different authentication states:
/// * [AuthInitial] - Initial state
/// * [AuthLoading] - During authentication operations
/// * [AuthAuthenticatedAdmin] - Logged in as admin
/// * [AuthAuthenticatedUser] - Logged in as regular user
/// * [AuthUnauthenticated] - Not logged in
/// * [AuthError] - Authentication error
/// * [AuthAdminPreviewUser] - Admin previewing as user
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository = UserRepository();
  final box = GetStorage();
  StreamSubscription<User?>? _authSubscription;
  final NetworkService _networkService = NetworkService();
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthNotifier({required this.authRepository}) : super(const AuthInitial()) {
    // Initialize auth state
    checkAuthState();
    // Convert User? stream to AuthState using the helper method
    _authSubscription = authRepository.authStateChanges().listen((user) {
      state = _determineAuthState(user);
    });
  }

  // Handle state determination
  AuthState _determineAuthState(User? user) {
    if (user == null) {
      return const AuthUnauthenticated();
    }

    final authType = box.read('authType');
    switch (authType) {
      case 'admin':
        return AuthAuthenticatedAdmin(user);
      case 'user':
        return AuthAuthenticatedUser(user);
      case 'preview':
        return AuthAdminPreviewUser(user);
      default:
        return const AuthUnauthenticated();
    }
  }

  Future<void> checkAuthState() async {
    final currentUser = authRepository.currentUser;
    if (currentUser == null) {
      state = const AuthUnauthenticated();
      await box.remove('authType');
      await box.remove('userProfile');
      await box.remove('adminProfile');
      return;
    }

    state = _determineAuthState(currentUser);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw const SocketException('No internet connection');
      }

      final response =
          await authRepository.loginWithEmailAndPassword(email, password);
      final user = response.user;
      if (user == null) throw Exception('User not found');

      final adminDomain = dotenv.env['ADMIN_EMAIL_DOMAIN'] ?? '';
      // Check email domain for role determination.
      if (user.email != null && user.email!.endsWith('@$adminDomain')) {
        state = AuthAuthenticatedAdmin(user);
        box.write('authType', 'admin');
      } else {
        state = AuthAuthenticatedUser(user);
        box.write('authType', 'user');
      }
    } catch (e) {
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  Future<void> register(String email, String password) async {
    state = const AuthLoading();
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw const SocketException('No internet connection');
      }

      final response =
          await authRepository.registerWithEmailAndPassword(email, password);
      final user = response.user;
      if (user == null) {
        throw AuthException('Registration failed');
      }

      final currentUser = AuthHelper.getCurrentUserId();
      final newUser = UserModel(
        id: currentUser!,
        firstname: '',
        lastname: '',
        email: email,
        profilePicture: '',
        phoneNumber: '',
        birthDate: DateTime.now(),
        maritalStatus: '',
      );

      await userRepository.saveUserRecord(newUser);

      // Registration flow for users only.
      state = AuthAuthenticatedUser(user);
      box.write('authType', 'user');
    } catch (e) {
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  Future<void> googleSignIn() async {
    state = const AuthLoading();
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw const SocketException('No internet connection');
      }

      final response = await authRepository.loginWithGoogle();
      final user = response.user;
      if (user == null) throw AuthException('Google sign in failed');

      // Check if user record exists first
      final existingUser = await userRepository.getUserById(user.id);

      // Only create new user record if one doesn't exist
      if (existingUser == null) {
        final newUser = UserModel(
          id: user.id,
          firstname: user.userMetadata?['full_name']?.split(' ').first ?? '',
          lastname: user.userMetadata?['full_name']?.split(' ').last ?? '',
          email: user.email!,
          profilePicture: user.userMetadata?['avatar_url'] ?? '',
          phoneNumber: '',
          birthDate: DateTime.now(),
          maritalStatus: '',
        );
        await userRepository.saveUserRecord(newUser);
      }

      state = AuthAuthenticatedUser(user);
      box.write('authType', 'user');
    } catch (e) {
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw SocketException(S.current.networkError);
      }

      // Clear auth type first
      await box.remove('authType');
      await box.remove('userProfile');
      await box.remove('adminProfile');

      // Then sign out from auth providers
      await authRepository.logout();

      // Reset state to unauthenticated
      state = AuthUnauthenticated();

      // Cancel any existing auth subscription and recreate it
      await _authSubscription?.cancel();
      _authSubscription = authRepository.authStateChanges().listen((user) {
        if (user == null) {
          state = AuthUnauthenticated();
        }
      });
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  void switchToUserPreview() async {
    try {
      if (state is AuthAuthenticatedAdmin) {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          throw const SocketException('No internet connection');
        }

        final adminUser = (state as AuthAuthenticatedAdmin).user;

        // Clear any existing user data before preview
        box.remove('userProfile');

        // Set preview state
        state = AuthAdminPreviewUser(adminUser);
        box.write('authType', 'preview');
      }
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  void exitUserPreview() async {
    try {
      if (state is AuthAdminPreviewUser) {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          throw const SocketException('No internet connection');
        }

        final adminUser = (state as AuthAdminPreviewUser).user;

        // Clear preview data
        box.remove('userProfile');

        // Restore admin state
        state = AuthAuthenticatedAdmin(adminUser);
        box.write('authType', 'admin');
      }
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw SocketException(S.current.networkError);
      }
      await authRepository.sendPasswordResetEmail(email);
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  Future<void> changePassword(
      String newPassword, String currentPassword) async {
    state = const AuthLoading();
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw SocketException(S.current.networkError);
      }

      final email = authRepository.currentUser?.email;
      if (email == null) {
        throw Exception(S.current.authError);
      }

      final isReauthenticated =
          await authRepository.reauthenticate(email, currentPassword);
      if (!isReauthenticated) {
        ErrorUtils.showErrorSnackBar(S.current.passwordIncorrect);
        return;
      }

      await authRepository.changePassword(newPassword);
      ErrorUtils.showSuccessSnackBar(S.current.passwordChanged);
      // Return to previous auth state after successful password change
      checkAuthState();
    } catch (e) {
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      state = AuthError(ErrorUtils.getErrorMessage(e));
    }
  }

  Future<void> deleteAccount(String email, String currentPassword) async {
    state = const AuthLoading();
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw SocketException(S.current.networkError);
      }

      // Get the current auth provider
      final provider =
          _supabase.auth.currentUser?.appMetadata['provider'] as String?;

      // Only perform password reauthentication for email provider
      if (provider != 'google') {
        final isReauthenticated =
            await authRepository.reauthenticate(email, currentPassword);
        if (!isReauthenticated) {
          state = const AuthError('Authentication failed');
          ErrorUtils.showErrorSnackBar(S.current.passwordIncorrect);
          return;
        }
      }

      // Delete account
      await authRepository.deleteAccount();

      // Clear local storage
      await box.remove('authType');
      await box.remove('userProfile');
      await box.remove('adminProfile');

      state = const AuthUnauthenticated();
      ErrorUtils.showSuccessSnackBar(S.current.accountDeleted);
    } catch (error) {
      state = AuthError(ErrorUtils.getErrorMessage(error));
      ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
    }
  }

  Future<bool> reauthenticate(String email, String currentPassword) async {
    try {
      final isConnected = await _networkService.isConnected();
      if (!isConnected) {
        throw SocketException(S.current.networkError);
      }

      return await authRepository.reauthenticate(email, currentPassword);
    } catch (error) {
      return false;
    }
  }
}
