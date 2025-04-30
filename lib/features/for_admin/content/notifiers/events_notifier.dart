import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../../generated/l10n.dart';
import '../models/events_model.dart';
import '../providers/events_provider.dart';
import '../repositories/events_repository.dart';

class EventsNotifier extends AsyncNotifier<List<Event>> {
  late final EventsRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<List<Event>> build() async {
    _repository = ref.read(eventsRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }
    return _repository.getAllEvents();
  }

  Future<void> addEvent(Event event, {File? imageFile}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          ErrorUtils.showErrorSnackBar(S.current.networkError);
        }

        String? imageUrl;
        if (imageFile != null) {
          imageUrl = await _repository.uploadEventImage(imageFile);
        }

        final updatedEvent = event.copyWith(imageUrl: imageUrl);
        await _repository.addEvent(updatedEvent);

        ErrorUtils.showSuccessSnackBar(S.current.eventAddSuccess);

        return _repository.getAllEvents();
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));

        rethrow;
      }
    });
  }

  Future<void> updateEvent(Event event, {File? imageFile}) async {
    state = const AsyncLoading();

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    state = await AsyncValue.guard(() async {
      String? imageUrl = event.imageUrl;
      if (imageFile != null) {
        if (imageUrl != null) {
          await _repository.deleteEventImage(imageUrl);
        }
        imageUrl = await _repository.uploadEventImage(imageFile);
      }

      final updatedEvent = event.copyWith(
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      await _repository.updateEvent(updatedEvent);
      return _repository.getAllEvents();
    });
  }

  Future<void> deleteEvent(String id) async {
    state = const AsyncLoading();

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    state = await AsyncValue.guard(() async {
      await _repository.deleteEvent(id);
      return _repository.getAllEvents();
    });
  }
}
