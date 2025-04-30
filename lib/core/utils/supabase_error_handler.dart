import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorHandler {
  static String getMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';

    // Handle Supabase authentication errors
    if (error is AuthException) {
      return _handleAuthError(error);
    }

    // Handle PostgrestException for database errors
    if (error is PostgrestException) {
      return _handlePostgrestError(error);
    }

    return error.toString();
  }

  static String _handleAuthError(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return 'Invalid email or password';
      case 'Email not confirmed':
        return 'Please verify your email before logging in';
      case 'User already registered':
        return 'An account already exists with this email';
      case 'Password should be at least 6 characters':
        return 'Password must be at least 6 characters long';
      case 'Rate limit exceeded':
        return 'Too many attempts. Please try again later';
      default:
        return error.message;
    }
  }

  static String _handlePostgrestError(PostgrestException error) {
    if (error.message.contains('duplicate key')) {
      return 'This record already exists';
    }
    return error.message;
  }
}
