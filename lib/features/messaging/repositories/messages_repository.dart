import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';

class MessagesRepository {
  final SupabaseClient _client;

  MessagesRepository({required SupabaseClient supabase}) : _client = supabase;

  Future<List<Message>> getUserMessages(String userId) async {
    try {
      final data = await _client
          .from('messages')
          .select()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .order('created_at', ascending: false);

      return data.map<Message>((json) => Message.fromJson(json)).toList();
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch messages');
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  Future<List<Message>> getAdminMessages() async {
    try {
      final data = await _client
          .from('messages')
          .select()
          .or('is_admin_sender.eq.true,receiver_id.is.null')
          .order('created_at', ascending: false);

      return data.map<Message>((json) => Message.fromJson(json)).toList();
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch admin messages');
    } catch (e) {
      throw Exception('Failed to fetch admin messages: $e');
    }
  }

  Future<List<Message>> getUnreadMessages(String userId) async {
    try {
      final data = await _client
          .from('messages')
          .select()
          .eq('receiver_id', userId)
          .eq('status', MessageStatus.sent.name)
          .order('created_at', ascending: false);

      return data.map<Message>((json) => Message.fromJson(json)).toList();
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to fetch unread messages');
    } catch (e) {
      throw Exception('Failed to fetch unread messages: $e');
    }
  }

  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _client
          .from('messages')
          .select('id')
          .eq('receiver_id', userId)
          .eq('status', MessageStatus.sent.name)
          .eq('is_admin_sender', false)
          .count();

      return response.count;
    } catch (e) {
      return 0;
    }
  }

  Future<Message> sendMessage(Message message) async {
    try {
      final data = await _client
          .from('messages')
          .insert({
            'sender_id': message.senderId,
            'receiver_id': message.receiverId,
            'content': message.content,
            'subject': message.subject,
            'type': message.type.name,
            'status': MessageStatus.sent.name,
            'sender_name': message.senderName,
            'sender_profile_url': message.senderProfileUrl,
            'is_admin_sender': message.isAdminSender,
          })
          .select()
          .single();

      return Message.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to send message');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _client
          .from('messages')
          .update({'status': MessageStatus.read.name}).eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await _client
          .from('messages')
          .update({'status': MessageStatus.read.name})
          .eq('receiver_id', userId)
          .eq('status', MessageStatus.sent.name);
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  Stream<List<Message>> streamUserMessages(String userId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) {
          final messages =
              data.map<Message>((json) => Message.fromJson(json)).toList();

          // Sort messages by date and filter relevant ones
          messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return messages
              .where((message) =>
                  message.senderId == userId ||
                  message.receiverId == userId ||
                  message.type == MessageType.broadcast)
              .toList();
        });
  }

  Stream<List<Message>> streamAdminMessages() {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((data) => data
            .map<Message>((json) => Message.fromJson(json))
            .where((message) =>
                message.receiverId == null || // Messages to admin
                message.isAdminSender || // Messages from admin
                message.type == MessageType.broadcast) // Broadcast messages
            .toList());
  }
}
