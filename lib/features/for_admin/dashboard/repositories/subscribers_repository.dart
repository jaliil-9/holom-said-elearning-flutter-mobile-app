import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribersRepository {
  final SupabaseClient client;
  SubscribersRepository(this.client);

  Future<List<Map<String, dynamic>>> fetchAdmins() async {
    final response = await client.from('admins').select();
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await client.from('users').select();
    return List<Map<String, dynamic>>.from(response as List);
  }
}
