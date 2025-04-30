import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../for_admin/content/models/courses_model.dart';
import '../../../for_admin/content/providers/courses_provider.dart';
import '../presentations/subscription_verification_page.dart';

final userCoursesProvider =
    FutureProvider.family<List<Course>, String>((ref, category) async {
  final repository = ref.watch(coursesRepositoryProvider);
  final networkService = ref.watch(networkServiceProvider);

  try {
    // Check connectivity before fetching
    final isConnected = await networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }
    // If this is the family category, check subscription first
    if (category == 'family') {
      final isSubscribed = ref.watch(subscriptionVerifiedProvider);

      // If not subscribed, return empty list
      if (!isSubscribed) {
        return [];
      }
    }

    final allCourses = await repository.getAllCourses();
    return allCourses.where((course) => course.category == category).toList();
  } catch (error) {
    rethrow;
  }
});
