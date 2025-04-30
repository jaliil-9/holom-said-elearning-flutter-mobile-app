import 'package:holom_said/features/personalzation/models/admin_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient client = Supabase.instance.client;

  Future<void> saveUserRecord(AdminModel user) async {
    await client.from('admins').upsert(user.toJson(), onConflict: 'id');
  }

  Future<void> updateUserRecord(AdminModel user) async {
    await client
        .from('admins')
        .update(user.toJson())
        .eq('id', user.id)
        .select();
  }

  Future<AdminModel?> getUserById(String id) async {
    final response =
        await client.from('admins').select().eq('id', id).maybeSingle();
    return response != null ? AdminModel.fromJson(response) : null;
  }

  Future<void> updateProfile({
    required String adminId,
    String? firstName,
    String? lastName,
  }) async {
    final updates = {
      if (firstName != null) 'firstname': firstName,
      if (lastName != null) 'lastname': lastName,
    };

    if (updates.isNotEmpty) {
      await client.from('admins').update(updates).eq('id', adminId).select();
    }
  }

  Future<void> updateProfilePicture({
    required String userId,
    required String profilePictureUrl,
  }) async {
    await client
        .from('admins')
        .update({'profilepicture': profilePictureUrl})
        .eq('id', userId)
        .select()
        .single();
  }

  Future<void> deleteProfilePicture(
      String userId, String profilePictureUrl) async {
    try {
      // First update the user record
      await client
          .from('admins')
          .update({'profilepicture': null})
          .eq('id', userId)
          .select();

      // Then remove from storage
      final uri = Uri.parse(profilePictureUrl);
      final filename = uri.pathSegments.last;
      await client.storage.from('profile-images').remove([filename]);
    } catch (e) {
      throw Exception('Failed to delete profile picture: $e');
    }
  }
}
