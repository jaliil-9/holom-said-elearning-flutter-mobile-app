import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<User?> authStateChanges() =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user);

  User? get currentUser => _client.auth.currentUser;

  Future<AuthResponse> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final response =
          await _client.auth.signUp(email: email, password: password);
      if (response.user == null) {
        throw AuthException('Registration failed. Please try again.');
      }
      return response;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<AuthResponse> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      if (response.session == null) {
        throw AuthException('Unable to establish session. Please try again.');
      }
      return response;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<AuthResponse> loginWithGoogle() async {
    try {
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

      final GoogleSignIn googleSignIn =
          GoogleSignIn(clientId: iosClientId, serverClientId: webClientId);

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Google authentication failed. Please try again.');
      }

      final response = await _client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken);

      return response;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> logout() async {
    try {
      // Sign out from Google if signed in
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Sign out from Supabase and clear session
      await _client.auth.signOut(scope: SignOutScope.global);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception("Something went wrong, please try again");
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      // Get the current auth provider
      final provider =
          _client.auth.currentUser?.appMetadata['provider'] as String?;

      if (provider == 'google') {
        throw Exception(
            'Password cannot be changed for Google-authenticated accounts');
      }

      await _client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Get the current user ID
      final userId = _client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('No authenticated user found');
      }

      // First, delete the user record from the 'users' table
      await _client.from('users').delete().eq('id', userId);

      // Then, mark account for deletion by adding to deleted_accounts
      await _client.from('deleted_accounts').insert({'user_id': userId});

      // Sign out the user
      await _client.auth.signOut();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<bool> reauthenticate(String email, String currentPassword) async {
    try {
      // Get the current auth provider
      final provider =
          _client.auth.currentUser?.appMetadata['provider'] as String?;

      if (provider == 'google') {
        // For Google users, we can't reauthenticate with password
        // Instead, check if they have a valid session
        final session = _client.auth.currentSession;
        return session != null && !session.isExpired;
      } else {
        // For email users, reauthenticate with password
        await _client.auth.signInWithPassword(
          email: email,
          password: currentPassword,
        );

        final session = _client.auth.currentSession;
        return session != null && !session.isExpired;
      }
    } catch (error) {
      throw AuthException(error.toString());
    }
  }
}
