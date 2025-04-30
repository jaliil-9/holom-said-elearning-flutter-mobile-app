import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../models/trainers_model.dart';

class TrainersRepository {
  final SupabaseClient _supabase;

  TrainersRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // Get all trainers
  Future<List<Trainer>> getAllTrainers({int limit = 50}) async {
    try {
      final data = await _supabase
          .from('trainers')
          .select()
          .order('last_name')
          .limit(limit);

      return data.map<Trainer>((json) => Trainer.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch trainers: $e');
    }
  }

  // Get trainer by ID
  Future<Trainer> getTrainerById(String id) async {
    try {
      final data =
          await _supabase.from('trainers').select().eq('id', id).single();

      return Trainer.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch trainer: $e');
    }
  }

  // Add new trainer
  Future<Trainer> addTrainer(Trainer trainer) async {
    try {
      final trainerData = trainer.toJson();

      // Ensure updated_at is current
      trainerData['updated_at'] = DateTime.now().toIso8601String();

      final data = await _supabase
          .from('trainers')
          .insert(trainerData)
          .select()
          .single();

      return Trainer.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add trainer: $e');
    }
  }

  // Update existing trainer
  Future<Trainer> updateTrainer(Trainer trainer) async {
    if (trainer.id == null) {
      throw Exception('Cannot update trainer without ID');
    }

    try {
      final trainerData = trainer.toJson();

      // Update the updated_at timestamp
      trainerData['updated_at'] = DateTime.now().toIso8601String();

      final data = await _supabase
          .from('trainers')
          .update(trainerData)
          .eq('id', trainer.id!)
          .select()
          .single();

      return Trainer.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update trainer: $e');
    }
  }

  // Delete trainer
  Future<void> deleteTrainer(String id) async {
    try {
      await _supabase.from('trainers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete trainer: $e');
    }
  }

  // Upload profile picture and return URL
  Future<String> uploadProfilePicture(File file) async {
    try {
      final fileExt = p.extension(file.path);
      final fileName = 'trainers/${const Uuid().v4()}$fileExt';

      await _supabase.storage.from('trainer-images').upload(fileName, file);

      final fileUrl =
          _supabase.storage.from('trainer-images').getPublicUrl(fileName);

      return fileUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  // Delete profile picture
  Future<void> deleteProfilePicture(String pictureUrl) async {
    try {
      final uri = Uri.parse(pictureUrl);
      final filePath = uri.pathSegments.last;

      await _supabase.storage.from('profiles').remove(['trainers/$filePath']);
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }

  // Get courses by trainer ID
  Future<List<Map<String, dynamic>>> getCoursesByTrainerId(
      String trainerId) async {
    try {
      final data =
          await _supabase.from('courses').select().eq('trainer_id', trainerId);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception('Failed to fetch trainer courses: $e');
    }
  }
}
