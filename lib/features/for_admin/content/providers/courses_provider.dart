import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../dashboard/providers/trainers_provider.dart';
import '../models/courses_model.dart';
import '../notifiers/courses_notifier.dart';
import '../repositories/courses_repository.dart';

final coursesRepositoryProvider = Provider<CoursesRepository>((ref) {
  final trainersRepository = ref.watch(trainersRepositoryProvider);
  return CoursesRepository(
    supabase: Supabase.instance.client,
    trainersRepository: trainersRepository,
  );
});

final coursesNotifierProvider =
    AsyncNotifierProvider<CoursesNotifier, List<Course>>(() {
  return CoursesNotifier();
});
