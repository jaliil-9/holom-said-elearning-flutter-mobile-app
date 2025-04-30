import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/exam_repository.dart';
import '../notifiers/exam_notifier.dart';
import '../models/exam_model.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepository(supabase: Supabase.instance.client);
});

final examNotifierProvider =
    AsyncNotifierProvider<ExamNotifier, List<Exam>>(() {
  return ExamNotifier();
});

final examStatusFilterProvider = StateProvider<String?>((ref) => null);
final examSearchQueryProvider = StateProvider<String>((ref) => "");
