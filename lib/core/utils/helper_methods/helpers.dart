import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../generated/l10n.dart';
import '../../services/storage_service.dart';
import '../../../features/for_admin/exams/models/exam_model.dart';
import '../../../features/for_user/exams/models/user_exam_attempt.dart';

class Helpers {
  static Color getScoreColor(
      Exam exam, AsyncValue<UserExamAttempt?> examAttempt) {
    return examAttempt.when(
      data: (attempt) {
        if (attempt?.score != null && attempt!.score! >= exam.passingScore) {
          return Colors.green;
        }
        return Colors.red;
      },
      loading: () => Colors.grey,
      error: (_, __) => Colors.grey,
    );
  }

  static ImageProvider getImageProvider(String? profileUrl) {
    return profileUrl != null && profileUrl.isNotEmpty
        ? NetworkImage(profileUrl)
        : const AssetImage('assets/images/user.jpg') as ImageProvider;
  }

  static Future<String?> uploadImage(BuildContext context) async {
    try {
      final hasPermission = await StorageService.requestStoragePermission(context);
      if (!hasPermission) {
        throw Exception(S.current.permissionRequiredMessage);
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final fileExt = p.extension(image.path);
        final fileName = '${const Uuid().v4()}$fileExt';

        final imageFile = File(image.path);
        await Supabase.instance.client.storage.from('profile-images').upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        final imageUrl = Supabase.instance.client.storage
            .from('profile-images')
            .getPublicUrl(fileName);

        return imageUrl;
      }
      return null;
    } on StorageException catch (e) {
      throw Exception('Storage error: $e');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<void> refreshProviders(
      WidgetRef ref, List<ProviderBase> providers) async {
    for (final provider in providers) {
      // ignore: unused_result
      ref.refresh(provider);
    }
  }
}

class AuthHelper {
  static String? getCurrentUserId() {
    return Supabase.instance.client.auth.currentUser?.id;
  }

  static String? getCurrentUserEmail() {
    return Supabase.instance.client.auth.currentUser?.email;
  }
}
