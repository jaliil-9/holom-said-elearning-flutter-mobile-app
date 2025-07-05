import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../personalzation/models/base_profile.dart';
import '../models/user_exam_attempt.dart';

class UserExamRepository {
  final SupabaseClient _client;

  UserExamRepository({required SupabaseClient supabase}) : _client = supabase;

  Future<List<UserExamAttempt>> getUserExamAttempts(String userId) async {
    try {
      final data = await _client
          .from('userexamattempt')
          .select()
          .eq('user_id', userId)
          .order('started_at', ascending: false);

      return data
          .map<UserExamAttempt>((json) => UserExamAttempt.fromJson(json))
          .toList();
    } on PostgrestException {
      throw PostgrestException(
          message: 'Failed to fetch user exam attempts from database');
    } catch (e) {
      throw Exception('Failed to fetch user exam attempts');
    }
  }

  Future<UserExamAttempt?> getUserExamAttemptByExamId(String examId) async {
    try {
      final data = await _client
          .from('userexamattempt')
          .select()
          .eq('exam_id', examId)
          .maybeSingle();

      if (data == null) return null;

      return UserExamAttempt.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(
          message: 'Failed to fetch user exam attempt from database');
    } catch (e) {
      throw Exception('Failed to fetch user exam attempt');
    }
  }

  Future<UserExamAttempt> startExamAttempt(String examId, String userId) async {
    try {
      // Check if user already has an active attempt
      final existingAttempt = await _client
          .from('userexamattempt')
          .select()
          .eq('exam_id', examId)
          .eq('user_id', userId)
          .eq('is_completed', false)
          .maybeSingle();

      if (existingAttempt != null) {
        return UserExamAttempt.fromJson(existingAttempt);
      }

      final attempt = UserExamAttempt(
        examId: examId,
        userId: userId,
        startedAt: DateTime.now(),
        answers: {},
      );

      final data = await _client
          .from('userexamattempt')
          .insert(attempt.toJson())
          .select()
          .single();

      return UserExamAttempt.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to insert exam attempt');
    } catch (e) {
      throw Exception('Failed to start exam attempt: $e');
    }
  }

  Future<void> submitAnswer(
      String attemptId, String questionId, String answerId) async {
    try {
      final attempt = await _client
          .from('userexamattempt')
          .select()
          .eq('id', attemptId)
          .single();

      final currentAnswers = Map<String, String>.from(attempt['answers'] ?? {});
      currentAnswers[questionId] = answerId;

      await _client
          .from('userexamattempt')
          .update({'answers': currentAnswers}).eq('id', attemptId);
    } on PostgrestException {
      throw PostgrestException(
          message: 'Failed to update answers in the database');
    } catch (e) {
      throw Exception('Failed to submit answer');
    }
  }

  Future<void> updateExamStats(
      BaseProfile user, String examId, int score) async {
    try {
      final examData =
          await _client.from('exams').select('stats').eq('id', examId).single();

      // Initialize stats if null or get existing
      Map<String, dynamic> currentStats = examData['stats'] ??
          {
            'participants': 0,
            'averageScore': 0,
            'results': [],
          };

      // Get existing results array or create new one
      List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(currentStats['results'] ?? []);

      // Add new result
      results.add({
        "user_name": "${user.firstname} ${user.lastname}",
        "score": score,
        "timestamp": DateTime.now().toIso8601String(),
      });

      // Calculate new stats
      int totalParticipants = (currentStats['participants'] as num).toInt() + 1;
      int currentAverage = (currentStats['averageScore'] as num).toInt();
      int newAverage = ((currentAverage * (totalParticipants - 1)) + score) ~/
          totalParticipants;

      // Update stats with all fields
      final updatedStats = {
        'participants': totalParticipants,
        'averageScore': newAverage,
        'results': results, // Use the accumulated results array
      };

      // Update exam stats in database
      await _client
          .from('exams')
          .update({'stats': updatedStats}).eq('id', examId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeExamAttempt(BaseProfile user, String attemptId,
      int score, Map<String, String> answers) async {
    try {
      // Get attempt data to get examId
      final attempt = await _client
          .from('userexamattempt')
          .select('exam_id')
          .eq('id', attemptId)
          .single();

      String isoNow = DateTime.now().toIso8601String();
      await _client
          .from('userexamattempt')
          .update({'completed_at': isoNow}).eq('id', attemptId);

      await _client
          .from('userexamattempt')
          .update({'is_completed': true}).eq('id', attemptId);

      await _client
          .from('userexamattempt')
          .update({'score': score}).eq('id', attemptId);

      await _client
          .from('userexamattempt')
          .update({'answers': answers}).eq('id', attemptId);

      // Update exam stats
      await updateExamStats(user, attempt['exam_id'], score);
    } on PostgrestException catch (e) {
      throw PostgrestException(
          message: 'Failed to complete exam attempt: ${e.message}');
    } catch (e) {
      throw Exception('Failed to complete exam attempt: $e');
    }
  }
}
