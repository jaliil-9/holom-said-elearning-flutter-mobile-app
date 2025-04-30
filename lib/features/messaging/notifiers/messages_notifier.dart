import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/helper_methods/helpers.dart';
import '../../../core/utils/helper_methods/network.dart';
import '../models/message_model.dart';
import '../providers/messages_provider.dart';

class MessagesNotifier extends AsyncNotifier<List<Message>> {
  late final NetworkService _networkService;

  @override
  Future<List<Message>> build() async {
    _networkService = ref.read(networkServiceProvider);
    final repository = ref.read(messagesRepositoryProvider);
    final userId = AuthHelper.getCurrentUserId();
    if (userId == null) return [];

    return repository.getUserMessages(userId);
  }

  Future<void> sendMessage(Message message) async {
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      throw const SocketException('No internet connection');
    }
    final userId = AuthHelper.getCurrentUserId();
    if (userId == null) {
      throw AuthException('User not found');
    }

    state = await AsyncValue.guard(() async {
      final repository = ref.read(messagesRepositoryProvider);
      await repository.sendMessage(message);
      return repository.getUserMessages(message.senderId);
    });
  }

  Future<void> markAsRead(String messageId) async {
    final repository = ref.read(messagesRepositoryProvider);
    await repository.markAsRead(messageId);
  }

  Future<void> markAllAsRead(String userId) async {
    final repository = ref.read(messagesRepositoryProvider);
    await repository.markAllAsRead(userId);
  }
}
