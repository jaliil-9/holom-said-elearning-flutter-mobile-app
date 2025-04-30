import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/user_form_notifier.dart';
import '../../personalzation/repositories/user_repository.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository());

final userFormProvider = AsyncNotifierProvider<UserFormNotifier, UserFormState>(
  UserFormNotifier.new,
);
