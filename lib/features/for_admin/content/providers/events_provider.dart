import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/events_model.dart';
import '../notifiers/events_notifier.dart';
import '../repositories/events_repository.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository(supabase: Supabase.instance.client);
});

final eventsNotifierProvider =
    AsyncNotifierProvider<EventsNotifier, List<Event>>(() {
  return EventsNotifier();
});
