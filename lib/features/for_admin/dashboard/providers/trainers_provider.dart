import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trainers_model.dart';
import '../notifiers/trainers_notifier.dart';
import '../repositories/trainers_repository.dart';

final trainersRepositoryProvider = Provider<TrainersRepository>((ref) {
  return TrainersRepository(supabase: Supabase.instance.client);
});

final trainersNotifierProvider =
    AsyncNotifierProvider<TrainersNotifier, List<Trainer>>(() {
  return TrainersNotifier();
});
