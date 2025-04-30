import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/features/for_admin/content/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../core/utils/helper_methods/helpers.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../../generated/l10n.dart';
import '../models/courses_model.dart';
import '../providers/courses_provider.dart';
import '../repositories/courses_repository.dart';

class CoursesNotifier extends AsyncNotifier<List<Course>> {
  late final CoursesRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<List<Course>> build() async {
    _repository = ref.read(coursesRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }

    return _repository.getAllCourses();
  }

  Future<void> addCourse(Course course, {File? thumbnailFile}) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);

      throw const SocketException('No internet connection');
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    String thumbnailUrl = course.thumbnailUrl!;
    if (thumbnailFile != null) {
      thumbnailUrl = await _repository.uploadThumbnail(thumbnailFile);
    }

    state = await AsyncValue.guard(() async {
      final updatedCourse = course.copyWith(thumbnailUrl: thumbnailUrl);
      await _repository.addCourse(updatedCourse);

      ErrorUtils.showSuccessSnackBar(S.current.courseAddSuccess);

      return _repository.getAllCourses();
    });
  }

  Future<void> updateCourse(Course course, {File? thumbnailFile}) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    String thumbnailUrl = course.thumbnailUrl!;
    if (thumbnailFile != null) {
      if (course.thumbnailUrl!.isNotEmpty) {
        await _repository.deleteThumbnail(course.thumbnailUrl);
      }
      thumbnailUrl = await _repository.uploadThumbnail(thumbnailFile);
    }
    state = await AsyncValue.guard(() async {
      final updatedCourse = course.copyWith(
        thumbnailUrl: thumbnailUrl,
        updatedAt: DateTime.now(),
      );

      await _repository.updateCourse(updatedCourse);

      ErrorUtils.showSuccessSnackBar(S.current.courseUpdateSuccess);

      return _repository.getAllCourses();
    });
  }

  Future<void> deleteCourse(String id) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    state = await AsyncValue.guard(() async {
      await _repository.deleteCourse(id);

      ErrorUtils.showSuccessSnackBar(S.current.courseDeleteSuccess);

      return _repository.getAllCourses();
    });
  }

  Future<void> changeCourseStatus(Course course, CourseStatus newStatus) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    state = await AsyncValue.guard(() async {
      final updatedCourse = course.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      await _repository.updateCourse(updatedCourse);

      ErrorUtils.showSuccessSnackBar(S.current.courseStatusUpdateSuccess);

      return _repository.getAllCourses();
    });
  }

  Future<void> addReview(Review review) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
      throw const SocketException('No internet connection');
    }

    final currentUser = AuthHelper.getCurrentUserId();
    if (currentUser == null) {
      throw const AuthException('User not authenticated');
    }

    state = await AsyncValue.guard(() async {
      await _repository.addReview(review);
      ErrorUtils.showSuccessSnackBar(S.current.reviewAddSuccess);
      return _repository.getAllCourses();
    });
  }

  Future<void> updateReview(Review review) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
      throw const SocketException('No internet connection');
    }

    state = await AsyncValue.guard(() async {
      await _repository.updateReview(review);
      ErrorUtils.showSuccessSnackBar(S.current.reviewUpdateSuccess);
      return _repository.getAllCourses();
    });
  }

  Future<void> deleteReview(String reviewId) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
      throw const SocketException('No internet connection');
    }

    state = await AsyncValue.guard(() async {
      await _repository.deleteReview(reviewId);
      ErrorUtils.showSuccessSnackBar(S.current.reviewDeleteSuccess);
      return _repository.getAllCourses();
    });
  }

  Future<List<Review>> getCourseReviews(String courseId) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
      throw const SocketException('No internet connection');
    }

    return await _repository.getCourseReviews(courseId);
  }

  Future<double> getCourseAverageRating(String courseId) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      return 0.0;
    }

    return await _repository.getCourseAverageRating(courseId);
  }
}
