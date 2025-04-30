import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/exam_model.dart';

class ExamRepository {
  final SupabaseClient _client;

  ExamRepository({required SupabaseClient supabase}) : _client = supabase;

  // Method to fetch all exams from the database
  // with optional filters for category, limit, and sorting
  Future<List<Exam>> getAllExams({
    String? category,
    int limit = 50,
    String sortBy = 'created_at',
    bool descending = true,
  }) async {
    try {
      final query = _client.from('exams').select('*');

      if (category != null) {
        query.eq('category', category);
      }

      final data =
          await query.order(sortBy, ascending: !descending).limit(limit);
      return data.map<Exam>((json) => Exam.fromJson(json)).toList();
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch exams from database');
    } catch (e) {
      throw Exception('Failed to fetch exams: $e');
    }
  }

  // Method to fetch a single exam by its ID
  Future<Exam?> getExamById(String id) async {
    try {
      final data = await _client.from('exams').select().eq('id', id).single();
      return Exam.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch exam from database');
    } catch (e) {
      throw Exception('Failed to fetch exam: $e');
    }
  }

  Future<Exam> addExam(Exam exam) async {
    try {
      final examData = exam.toJson();
      final data =
          await _client.from('exams').insert(examData).select().single();

      return Exam.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to insert exam into database');
    } catch (e) {
      throw Exception('Failed to add exam: $e');
    }
  }

  Future<Exam> updateExam(Exam exam) async {
    try {
      final examData = exam.toJson();
      final data = await _client
          .from('exams')
          .update(examData)
          .eq('id', exam.id)
          .select()
          .single();

      return Exam.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to update exam in database');
    } catch (e) {
      throw Exception('Failed to update exam: $e');
    }
  }

  Future<void> deleteExam(String id) async {
    try {
      await _client.from('exams').delete().eq('id', id);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to delete exam from database');
    } catch (e) {
      throw Exception('Failed to delete exam: $e');
    }
  }

  Future<void> publishExam(String id) async {
    try {
      await _client.from('exams').update({'is_published': true}).eq('id', id);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to publish exam in database');
    } catch (e) {
      throw Exception('Failed to publish exam: $e');
    }
  }
}
