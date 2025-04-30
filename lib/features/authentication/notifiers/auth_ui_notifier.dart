import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

typedef AuthUiState = ({
  bool isPasswordVisible,
  bool isConfirmPasswordVisible,
  bool rememberMe,
  bool isLoading,
  String? error
});

class AuthUiNotifier extends StateNotifier<AuthUiState> {
  AuthUiNotifier()
      : super((
          isPasswordVisible: false,
          isConfirmPasswordVisible: false,
          rememberMe: false,
          isLoading: false,
          error: null,
        ));

  void togglePasswordVisibility() {
    state = (
      isPasswordVisible: !state.isPasswordVisible,
      isConfirmPasswordVisible: state.isConfirmPasswordVisible,
      rememberMe: state.rememberMe,
      isLoading: state.isLoading,
      error: state.error,
    );
  }

  void toggleRememberMe() {
    state = (
      isPasswordVisible: state.isPasswordVisible,
      isConfirmPasswordVisible: state.isConfirmPasswordVisible,
      rememberMe: !state.rememberMe,
      isLoading: state.isLoading,
      error: state.error,
    );
  }

  void toggleConfirmPasswordVisibility() {
    state = (
      isPasswordVisible: state.isPasswordVisible,
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
      rememberMe: state.rememberMe,
      isLoading: state.isLoading,
      error: state.error,
    );
  }

  // Method to store email based on rememberMe flag.
  void updateRememberedEmail(String email) {
    final box = GetStorage();
    if (state.rememberMe) {
      box.write('rememberedEmail', email);
    } else {
      box.remove('rememberedEmail');
    }
  }
}
