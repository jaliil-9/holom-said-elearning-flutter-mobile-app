import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../core/utils/helper_methods/network.dart';
import '../../../../generated/l10n.dart';
import '../models/trainers_model.dart';
import '../providers/trainers_provider.dart';
import '../repositories/trainers_repository.dart';

class TrainersNotifier extends AsyncNotifier<List<Trainer>> {
  late final TrainersRepository _repository;
  late final NetworkService _networkService;

  @override
  Future<List<Trainer>> build() async {
    _repository = ref.read(trainersRepositoryProvider);
    _networkService = ref.read(networkServiceProvider);

    // Check connectivity
    final isConnected = await _networkService.isConnected();
    if (!isConnected) {
      ErrorUtils.showErrorSnackBar(S.current.networkError);
    }

    return _repository.getAllTrainers();
  }

  Future<void> addTrainer(Trainer trainer, {File? profilePictureFile}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          ErrorUtils.showErrorSnackBar(S.current.networkError);
        }

        String? profilePictureUrl;
        if (profilePictureFile != null) {
          profilePictureUrl =
              await _repository.uploadProfilePicture(profilePictureFile);
        }

        final updatedTrainer =
            trainer.copyWith(profilePictureUrl: profilePictureUrl);
        await _repository.addTrainer(updatedTrainer);

        ErrorUtils.showSuccessSnackBar(S.current.trainerAddSuccess);
        return _repository.getAllTrainers();
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });
  }

  Future<void> updateTrainer(Trainer trainer,
      {File? profilePictureFile}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          throw const SocketException('No internet connection');
        }

        String? profilePictureUrl = trainer.profilePictureUrl;
        if (profilePictureFile != null) {
          if (profilePictureUrl != null) {
            await _repository.deleteProfilePicture(profilePictureUrl);
          }
          profilePictureUrl =
              await _repository.uploadProfilePicture(profilePictureFile);
        }

        final updatedTrainer = trainer.copyWith(
          profilePictureUrl: profilePictureUrl,
          updatedAt: DateTime.now(),
        );

        await _repository.updateTrainer(updatedTrainer);

        ErrorUtils.showSuccessSnackBar(S.current.trainerUpdateSuccess);
        return _repository.getAllTrainers();
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });
  }

  Future<void> deleteTrainer(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final isConnected = await _networkService.isConnected();
        if (!isConnected) {
          throw const SocketException('No internet connection');
        }

        final trainer = await _repository.getTrainerById(id);
        if (trainer.profilePictureUrl != null) {
          await _repository.deleteProfilePicture(trainer.profilePictureUrl!);
        }

        await _repository.deleteTrainer(id);

        ErrorUtils.showSuccessSnackBar(S.current.trainerDeleteSuccess);
        return _repository.getAllTrainers();
      } catch (error) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(error));
        rethrow;
      }
    });
  }
}
