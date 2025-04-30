import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../dashboard/models/trainers_model.dart';
import '../../dashboard/repositories/trainers_repository.dart';
import '../models/courses_model.dart';
import '../models/review_model.dart';

class CoursesRepository {
  final SupabaseClient _client;
  final TrainersRepository _trainersRepository;

  CoursesRepository(
      {required SupabaseClient supabase,
      required TrainersRepository trainersRepository})
      : _client = supabase,
        _trainersRepository = trainersRepository;

  Future<List<Course>> getAllCourses({
    String? trainerId,
    int limit = 50,
    String sortBy = 'created_at',
    bool descending = true,
  }) async {
    try {
      final query = _client.from('courses').select('*, trainers(*)');

      // Add trainer filter if specified
      final data = trainerId != null
          ? await query
              .eq('trainer_id', trainerId)
              .order(sortBy, ascending: !descending)
              .limit(limit)
          : await query.order(sortBy, ascending: !descending).limit(limit);

      return data.map<Course>((json) {
        // Handle trainer data from the join
        final trainerData = json['trainers'];
        final trainer = trainerData != null
            ? Trainer.fromJson(trainerData as Map<String, dynamic>)
            : null;
        return Course.fromJson(json, trainer: trainer);
      }).toList();
    } on PostgrestException {
      throw PostgrestException(
          message: 'Failed to fetch courses from database');
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  // Method to get courses by category
  Future<Course> getCourseByCategory(String category) async {
    try {
      final data = await _client.from('courses').select('''
            *,
            trainers!inner (
              id,
              first_name,
              last_name,
              specialty,
              description,
              profile_picture_url,
              created_at,
              updated_at
            )
          ''').eq('category', category).single();

      final trainerJson = data['trainers'] as Map<String, dynamic>;
      final trainer = Trainer.fromJson(trainerJson);
      return Course.fromJson(data, trainer: trainer);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch course from database');
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  // Method to get courses by ID
  Future<Course> getCourseById(String id) async {
    try {
      final data = await _client.from('courses').select('''
            *,
            trainers!inner (
              id,
              first_name,
              last_name,
              specialty,
              description,
              profile_picture_url,
              created_at,
              updated_at
            )
          ''').eq('id', id).single();

      final trainerJson = data['trainers'] as Map<String, dynamic>;
      final trainer = Trainer.fromJson(trainerJson);
      return Course.fromJson(data, trainer: trainer);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch course from database');
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  // Add new course
  Future<Course> addCourse(Course course) async {
    try {
      // Verify trainer exists
      await _trainersRepository.getTrainerById(course.trainerId);

      final courseData = course.toJson();

      // Ensure updated_at is current
      courseData['updated_at'] = DateTime.now().toIso8601String();

      final data =
          await _client.from('courses').insert(courseData).select().single();

      // Return course with trainer data if available
      if (course.trainer != null) {
        return Course.fromJson(data, trainer: course.trainer);
      } else {
        try {
          final trainer =
              await _trainersRepository.getTrainerById(data['trainer_id']);
          return Course.fromJson(data, trainer: trainer);
        } catch (e) {
          return Course.fromJson(data);
        }
      }
    } on PostgrestException {
      throw PostgrestException(
          message: 'Failed to insert course into database');
    } catch (e) {
      throw Exception('Failed to add course: $e');
    }
  }

  // Update existing course
  Future<Course> updateCourse(Course course) async {
    if (course.id == null) {
      throw Exception('Cannot update course without ID');
    }

    try {
      // Verify trainer exists
      await _trainersRepository.getTrainerById(course.trainerId);

      final courseData = course.toJson();

      // Update the updated_at timestamp
      courseData['updated_at'] = DateTime.now().toIso8601String();

      final data = await _client
          .from('courses')
          .update(courseData)
          .eq('id', course.id!)
          .select()
          .single();

      // Return course with trainer data if available
      if (course.trainer != null) {
        return Course.fromJson(data, trainer: course.trainer);
      } else {
        try {
          final trainer =
              await _trainersRepository.getTrainerById(data['trainer_id']);
          return Course.fromJson(data, trainer: trainer);
        } catch (e) {
          return Course.fromJson(data);
        }
      }
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to update course in database');
    } on StorageException {
      throw Exception('Storage permission denied');
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  // Delete course
  Future<void> deleteCourse(String id) async {
    try {
      // Get the course to access the thumbnail URL
      final course = await getCourseById(id);

      // Delete thumbnail if it exists
      if (course.thumbnailUrl!.isNotEmpty) {
        await deleteThumbnail(course.thumbnailUrl);
      }

      // Delete the course
      await _client.from('courses').delete().eq('id', id);
    } on PostgrestException {
      throw PostgrestException(
          message: 'Failed to delete course from database');
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  // Upload thumbnail image and return URL
  Future<String> uploadThumbnail(File file) async {
    try {
      // Check if user is authenticated
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to upload thumbnails');
      }

      final fileExt = p.extension(file.path);
      final fileName = '${const Uuid().v4()}$fileExt';

      await _client.storage.from('course-thumbnail').upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      final fileUrl =
          _client.storage.from('course-thumbnail').getPublicUrl(fileName);

      return fileUrl;
    } on StorageException {
      throw Exception('Storage permission denied');
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to upload thumbnail');
    } catch (e) {
      throw Exception('Failed to upload thumbnail: $e');
    }
  }

  // Delete thumbnail from storage
  Future<void> deleteThumbnail(String? thumbnailUrl) async {
    try {
      final uri = Uri.parse(thumbnailUrl!);
      final filePath = uri.pathSegments.last;

      await _client.storage.from('course-thumbnail').remove([filePath]);
    } on StorageException {
      throw Exception('Storage permission denied');
    } catch (e) {
      throw Exception('Failed to delete thumbnail: $e');
    }
  }

  // Get reviews for a course
  Future<List<Review>> getCourseReviews(String courseId) async {
    try {
      final data = await _client
          .from('course_reviews')
          .select()
          .eq('course_id', courseId)
          .order('created_at', ascending: false);

      return data.map<Review>((json) => Review.fromJson(json)).toList();
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch reviews');
    } catch (e) {
      throw Exception('Failed to fetch reviews');
    }
  }

  // Add a review
  Future<Review> addReview(Review review) async {
    try {
      final data = await _client
          .from('course_reviews')
          .insert(review.toJson())
          .select()
          .single();

      return Review.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to add review');
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  // Update a review
  Future<void> updateReview(Review review) async {
    try {
      await _client
          .from('course_reviews')
          .update(review.toJson())
          .eq('id', review.id!)
          .select();
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to update review');
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _client.from('course_reviews').delete().eq('id', reviewId);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to delete review');
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  // Get course average rating
  Future<double> getCourseAverageRating(String courseId) async {
    try {
      final response = await _client
          .from('course_reviews')
          .select('rating')
          .eq('course_id', courseId);

      if (response.isEmpty) return 0.0;

      final ratings = response.map((r) => r['rating'] as num).toList();
      return ratings.reduce((a, b) => a + b) / ratings.length;
    } catch (e) {
      return 0.0;
    }
  }
}
