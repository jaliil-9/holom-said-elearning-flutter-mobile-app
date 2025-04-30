import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../core/utils/helper_methods/helpers.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../../generated/l10n.dart';
import '../models/exam_model.dart';
import '../providers/exam_provider.dart';
import '../repositories/exam_repository.dart';

class ExamNotifier extends AsyncNotifier<List<Exam>> {
  late final ExamRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<List<Exam>> build() async {
    _repository = ref.read(examRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);

    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }

    return _repository.getAllExams();
  }

  Future<void> addExam(Exam exam) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    state = await AsyncValue.guard(() async {
      await _repository.addExam(exam);
      ErrorUtils.showSuccessSnackBar(S.current.examAddSuccess);
      return _repository.getAllExams();
    });
  }

  Future<void> updateExam(Exam exam) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }
    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    state = await AsyncValue.guard(() async {
      await _repository.updateExam(exam);
      ErrorUtils.showSuccessSnackBar(S.current.examUpdateSuccess);
      return _repository.getAllExams();
    });
  }

  Future<void> deleteExam(String id) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    state = await AsyncValue.guard(() async {
      await _repository.deleteExam(id);
      ErrorUtils.showSuccessSnackBar(S.current.examDeleteSuccess);
      return _repository.getAllExams();
    });
  }
}
