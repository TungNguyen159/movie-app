import 'package:movie_app/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  // get current user
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('user')
        .select()
        .eq('id', user.id)
        .single(); // Lấy 1 record duy nhất

    return response;
  }

  // find user
  // Future<List<Users>> getAllUser(String query) async {
  //   if (query.isEmpty) {
  //     return [];
  //   }

  //   final response = await Supabase.instance.client
  //       .from('user') // Tên bảng chứa người dùng
  //       .select('*')
  //       .ilike('name', '%$query%');
  //   return response.map((user) => Users.fromJson(user)).toList();
  // }

  final stream = Supabase.instance.client.from('user').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((e) => Users.fromJson(e)).toList());

  // insert user signup
  Future<void> insertUserProfile(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('user').insert({
      'id': user.id,
      'email': user.email,
      'name': name,
      'role': "customer",
    });
  }

  // update current user
  Future<void> updateUserProfile(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('user').upsert({
      'id': user.id,
      'email': user.email,
      'name': name,
    });
  }

  // update user by id
  Future<void> updateUser(String newRole, Users user) async {
    await supabase
        .from('user')
        .update({
          'role': newRole,
        })
        .eq('id', user.id)
        .select();
  }

  // delete user by id
  Future<void> deleteUser(Users user) async {
    await supabase.from('user').delete().eq('id', user.id);
  }
}
