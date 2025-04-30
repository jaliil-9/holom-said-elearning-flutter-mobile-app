import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/utils/helper_methods/helpers.dart';
import '../../../core/utils/helper_methods/error.dart';
import '../../../core/utils/helper_methods/network.dart';
import '../../../generated/l10n.dart';
import '../../personalzation/models/user_model.dart';
import '../../personalzation/repositories/user_repository.dart';
import '../providers/user_form_provider.dart';

class UserFormState {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime? birthDate;
  final String maritalStatus;
  final bool acceptedPrivacyPolicy;

  UserFormState({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.birthDate,
    this.maritalStatus = '',
    this.acceptedPrivacyPolicy = false,
  });

  UserFormState copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? birthDate,
    String? maritalStatus,
    bool? acceptedPrivacyPolicy,
  }) {
    return UserFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      acceptedPrivacyPolicy:
          acceptedPrivacyPolicy ?? this.acceptedPrivacyPolicy,
    );
  }
}

class UserFormNotifier extends AsyncNotifier<UserFormState> {
  late final UserRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<UserFormState> build() async {
    _repository = ref.read(userRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);
    return UserFormState();
  }

  // Safe state updates using AsyncValue
  void _updateState(UserFormState Function(UserFormState) update) {
    state = AsyncValue.data(update(state.value ?? UserFormState()));
  }

  // Update methods using safe state update
  void updateFirstName(String value) =>
      _updateState((state) => state.copyWith(firstName: value));
  void updateLastName(String value) =>
      _updateState((state) => state.copyWith(lastName: value));
  void updatePhoneNumber(String value) =>
      _updateState((state) => state.copyWith(phoneNumber: value));
  void updateBirthDate(DateTime value) =>
      _updateState((state) => state.copyWith(birthDate: value));
  void updateMaritalStatus(String value) =>
      _updateState((state) => state.copyWith(maritalStatus: value));
  void updatePrivacyPolicyAcceptance(bool value) =>
      _updateState((state) => state.copyWith(acceptedPrivacyPolicy: value));

  Future<void> submitUserForm() async {
    state = await AsyncValue.guard(() async {
      try {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          ErrorUtils.showErrorSnackBar(S.current.networkError);
        }

        final currentUser = AuthHelper.getCurrentUserId();
        final currentUserEmail = AuthHelper.getCurrentUserEmail();
        if (currentUser == null) {
          ErrorUtils.showErrorSnackBar(S.current.authError);
        }

        final formState = state.value;
        if (formState == null) {
          ErrorUtils.showErrorSnackBar(S.current.authError);
          throw Exception('Form state is null');
        }

        final newUser = UserModel(
          id: currentUser!,
          firstname: formState.firstName,
          lastname: formState.lastName,
          email: currentUserEmail!,
          profilePicture: '',
          phoneNumber: formState.phoneNumber,
          birthDate: formState.birthDate,
          maritalStatus: formState.maritalStatus,
        );

        await _repository.updateUserRecord(newUser);
        ErrorUtils.showSuccessSnackBar(S.current.userFormSubmitted);
        return formState;
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });
  }
}
