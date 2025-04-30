import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../generated/l10n.dart';
import '../../../for_admin/content/providers/courses_provider.dart';
import '../../../for_admin/content/providers/events_provider.dart';
import '../../../for_admin/dashboard/providers/trainers_provider.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../for_admin/content/models/courses_model.dart';
import '../../../for_admin/content/models/events_model.dart';
import '../../../for_admin/dashboard/models/trainers_model.dart';

final homeDataProvider = FutureProvider((ref) async {
  final coursesRepo = ref.watch(coursesRepositoryProvider);
  final eventsRepo = ref.watch(eventsRepositoryProvider);
  final trainersRepo = ref.watch(trainersRepositoryProvider);
  final networkService = ref.watch(networkServiceProvider);

  try {
    final isConnected = await networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
      throw const SocketException('No internet connection');
    }

    // Fetch all data concurrently
    final results = await Future.wait([
      coursesRepo.getAllCourses(limit: 2, descending: false),
      eventsRepo.getAllEvents(limit: 3),
      trainersRepo.getAllTrainers(limit: 3),
    ]);

    // Return structured data
    return HomeData(
      courses: results[0] as List<Course>,
      events: results[1] as List<Event>,
      trainers: results[2] as List<Trainer>,
    );
  } catch (e) {
    rethrow;
  }
});

// Data class to hold all home screen data
class HomeData {
  final List<Course> courses;
  final List<Event> events;
  final List<Trainer> trainers;

  const HomeData({
    required this.courses,
    required this.events,
    required this.trainers,
  });
}
