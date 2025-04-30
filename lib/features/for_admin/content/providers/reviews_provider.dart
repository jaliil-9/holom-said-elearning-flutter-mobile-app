import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';
import 'courses_provider.dart';

final courseReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, courseId) async {
  return ref.read(coursesNotifierProvider.notifier).getCourseReviews(courseId);
});

final courseAverageRatingProvider =
    FutureProvider.family<double, String>((ref, courseId) async {
  return ref
      .read(coursesNotifierProvider.notifier)
      .getCourseAverageRating(courseId);
});
