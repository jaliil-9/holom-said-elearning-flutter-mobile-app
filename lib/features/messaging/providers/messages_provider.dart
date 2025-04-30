import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/helper_methods/helpers.dart';
import '../models/message_model.dart';
import '../notifiers/messages_notifier.dart';
import '../repositories/messages_repository.dart';

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return MessagesRepository(supabase: Supabase.instance.client);
});

final messagesNotifierProvider =
    AsyncNotifierProvider<MessagesNotifier, List<Message>>(() {
  return MessagesNotifier();
});

final unreadMessagesCountAdminProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(messagesRepositoryProvider);
  final userId = AuthHelper.getCurrentUserId();
  if (userId == null) return Stream.value(0);

  // Listen to message changes
  return repository.streamAdminMessages().map((messages) {
    return messages
        .where((m) => !m.isAdminSender && m.status == MessageStatus.sent)
        .length;
  });
});

final unreadMessagesCountUserProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(messagesRepositoryProvider);
  final userId = AuthHelper.getCurrentUserId();
  if (userId == null) return Stream.value(0);

  // Listen to message changes
  return repository.streamUserMessages(userId).map((messages) {
    return messages.where((m) => m.status == MessageStatus.sent).length;
  });
});

final adminMessagesProvider = StreamProvider<List<Message>>((ref) {
  final repository = ref.watch(messagesRepositoryProvider);
  return repository.streamAdminMessages();
});

final userMessagesProvider = StreamProvider<List<Message>>((ref) {
  final repository = ref.watch(messagesRepositoryProvider);
  final userId = AuthHelper.getCurrentUserId();
  if (userId == null) return Stream.value([]);
  return repository.streamUserMessages(userId);
});
