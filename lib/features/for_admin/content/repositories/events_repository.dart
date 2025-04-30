import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../models/events_model.dart';

class EventsRepository {
  final SupabaseClient _client;

  EventsRepository({required SupabaseClient supabase}) : _client = supabase;

  Future<List<Event>> getAllEvents({
    int limit = 50,
    String sortBy = 'event_date',
    bool descending = true,
  }) async {
    try {
      final data = await _client
          .from('events')
          .select()
          .order(sortBy, ascending: !descending)
          .limit(limit);

      return data.map<Event>((json) => Event.fromJson(json)).toList();
    } on PostgrestException {
      throw Exception('Failed to fetch events');
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<Event> getEventById(String id) async {
    try {
      final data = await _client.from('events').select().eq('id', id).single();
      return Event.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Event not found');
    } catch (e) {
      throw Exception('Failed to fetch event: $e');
    }
  }

  Future<Event> addEvent(Event event) async {
    try {
      final eventData = event.toJson();
      // Add creator_id from current user
      eventData['creator_id'] = _client.auth.currentUser?.id;

      final data =
          await _client.from('events').insert(eventData).select().single();
      return Event.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to add event');
    } catch (e) {
      throw Exception('Failed to add event: $e');
    }
  }

  Future<Event> updateEvent(Event event) async {
    if (event.id == null) {
      throw Exception('Cannot update event without ID');
    }

    try {
      final eventData = event.toJson();
      final data = await _client
          .from('events')
          .update(eventData)
          .eq('id', event.id!)
          .select()
          .single();
      return Event.fromJson(data);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to update event');
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      final event = await getEventById(id);
      if (event.imageUrl != null) {
        await deleteEventImage(event.imageUrl!);
      }
      await _client.from('events').delete().eq('id', id);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to delete event');
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<String> uploadEventImage(File file) async {
    try {
      // Check if user is authenticated
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to upload images');
      }

      final fileExt = p.extension(file.path);
      final fileName = '${const Uuid().v4()}$fileExt';

      await _client.storage.from('event-images').upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      return _client.storage.from('event-images').getPublicUrl(fileName);
    } on PostgrestException {
      throw PostgrestException(message: 'Failed to upload event image');
    } on StorageException catch (e) {
      throw StorageException('Storage permission denied: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload event image: $e');
    }
  }

  Future<void> deleteEventImage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final filePath = uri.pathSegments.last;
      await _client.storage.from('event-images').remove([filePath]);
    } on StorageException {
      throw StorageException('Failed to delete event image');
    } catch (e) {
      throw Exception('Failed to delete event image: $e');
    }
  }
}
