import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../for_admin/exams/models/exam_model.dart';
import '../../../for_admin/exams/providers/exam_provider.dart';
import '../repositories/user_exam_repository.dart';
import '../notifiers/user_exam_notifier.dart';
import '../models/user_exam_attempt.dart';

final userExamRepositoryProvider = Provider<UserExamRepository>((ref) {
  return UserExamRepository(supabase: Supabase.instance.client);
});

final activeExamAttemptProvider =
    AsyncNotifierProvider<UserExamNotifier, UserExamAttempt?>(() {
  return UserExamNotifier();
});

final userExamAttemptsProvider =
    FutureProvider<List<UserExamAttempt>>((ref) async {
  final repository = ref.watch(userExamRepositoryProvider);
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];
  return repository.getUserExamAttempts(user.id);
});

final userExamAttemptDetailsProvider =
    FutureProvider.family<UserExamAttempt?, String>((ref, examId) async {
  final repository = ref.watch(userExamRepositoryProvider);
  return repository.getUserExamAttemptByExamId(examId);
});

final activeExamsProvider = FutureProvider<List<Exam>>((ref) async {
  final repository = ref.watch(examRepositoryProvider);
  return repository.getAllExams(
    sortBy: 'created_at',
    descending: true,
  );
});

final examDetailsProvider =
    FutureProvider.family<Exam?, String>((ref, examId) async {
  final repository = ref.watch(examRepositoryProvider);
  return repository.getExamById(examId);
});

final currentExamProvider = StateProvider<Exam?>((ref) => null);
