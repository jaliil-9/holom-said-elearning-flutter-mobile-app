import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/utils/helper_methods/helpers.dart';
import 'package:holom_said/features/personalzation/models/base_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../for_admin/exams/providers/exam_provider.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../models/user_exam_attempt.dart';
import '../providers/user_exam_provider.dart';
import '../repositories/user_exam_repository.dart';

class UserExamNotifier extends AsyncNotifier<UserExamAttempt?> {
  late final UserExamRepository _repository;
  late final NetworkService _networkService;
  late BaseProfile user;

  @override
  Future<UserExamAttempt?> build() async {
    _repository = ref.read(userExamRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);
    user = ref.read(userProfileProvider).value!;
    return null;
  }

  // Start exam method
  Future<void> startExam(String examId) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }

    final userId = AuthHelper.getCurrentUserId();
    if (userId == null) throw const AuthException('User not authenticated');

    state = await AsyncValue.guard(() async {
      return await _repository.startExamAttempt(examId, userId);
    });
  }

  // Submit answer method
  Future<void> submitAnswer(String questionId, String answerId) async {
    final currentAttempt = state.value;
    if (currentAttempt == null || !state.hasValue) {
      throw Exception(
          'No active exam attempt - please wait for exam to initialize');
    }

    state = await AsyncValue.guard(() async {
      await _repository.submitAnswer(currentAttempt.id, questionId, answerId);

      final updatedAnswers = Map<String, String>.from(currentAttempt.answers);
      updatedAnswers[questionId] = answerId;

      return currentAttempt.copyWith(answers: updatedAnswers);
    });
  }

  // Submit/ Complete exam
  Future<void> completeExam() async {
    final currentAttempt = state.value;
    if (currentAttempt == null) throw Exception('No active exam attempt');
    if (currentAttempt.isCompleted) throw Exception('Exam already completed');

    // Network and auth checks
    final isConnected = await _networkService.isConnected();
    if (!isConnected) throw const SocketException('No internet connection');

    final userId = AuthHelper.getCurrentUserId();
    if (userId == null) throw const AuthException('User not authenticated');

    state = await AsyncValue.guard(() async {
      // Calculate score first
      final score = await _calculateScore(currentAttempt);

      // Single operation that handles both attempt completion and stats update
      await _repository.completeExamAttempt(
        user,
        currentAttempt.id,
        score,
        currentAttempt.answers,
      );

      // Update local state with all fields
      return currentAttempt.copyWith(
        score: score,
        isCompleted: true,
        completedAt: DateTime.now(),
        answers: Map<String, String>.from(currentAttempt.answers),
      );
    });
  }

  Future<int> _calculateScore(UserExamAttempt attempt) async {
    // Get exam from repository to check correct answers
    final examRepository = ref.read(examRepositoryProvider);
    final exam = await examRepository.getExamById(attempt.examId);

    if (exam == null) throw Exception('Exam not found');

    int correctAnswers = 0;
    for (final question in exam.questions) {
      final userAnswer = attempt.answers[question.id];
      if (userAnswer == question.correctOptionId) {
        correctAnswers++;
      }
    }

    return (correctAnswers / exam.questions.length * 100).round();
  }
}
