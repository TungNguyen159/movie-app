import 'dart:io';

import 'package:movie_app/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  // get current user
  Future<Users?> getUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('user')
        .select()
        .eq('id', user.id)
        .single(); // Lấy 1 record duy nhất

    return Users.fromJson(response);
  }

  // getusserbyid
  Future<Users?> getUserbyid(String userid) async {
    final response = await supabase
        .from('user')
        .select()
        .eq('id', userid)
        .single(); // Lấy 1 record duy nhất

    return Users.fromJson(response);
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
  Future<bool> isUsernameExists(String username) async {
    final response =
        await supabase.from('user').select('id').eq('name', username);
    return response.isNotEmpty;
  }
  Future<bool> isEmailExists(String email) async {
    final response =
        await supabase.from('user').select('id').eq('email', email);

    return response.isNotEmpty;
  }

  // read user stream
  final stream = Supabase.instance.client.from('user').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((e) => Users.fromJson(e)).toList());
  Stream<Users?> get streamUser {
    final currentUserId = supabase.auth.currentUser?.id;

    // Nếu chưa đăng nhập, trả về Stream rỗng
    if (currentUserId == null) {
      return Stream.value(null);
    }

    return supabase
        .from('user')
        .stream(primaryKey: ['id'])
        .eq('id', currentUserId)
        .limit(1)
        .map((data) => data.isNotEmpty ? Users.fromJson(data.first) : null);
  }

  // insert user signup
  Future<void> insertUserProfile(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('user').insert({
      'id': user.id,
      'email': user.email,
      'name': name,
      'role': "customer",
      'status': "active",
    });
  }

  // update profile
  Future<void> updateCurrentuser(Users user) async {
    await supabase.from('user').update({
      'name': user.name,
      'age': user.age,
      'image_user': user.imageuser,
    }).eq('id', user.id);
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

  // update status by id
  Future<void> updateStatus(String newStatus, Users user) async {
    await supabase
        .from('user')
        .update({
          'status': newStatus,
        })
        .eq('id', user.id)
        .select();
  }

  // delete user by id
  Future<void> deleteUser(Users user) async {
    await supabase.from('user').delete().eq('id', user.id);
  }

  Future<String?> uploadImage(File imageFile) async {
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final response =
        await supabase.storage.from('image').upload(imageName, imageFile);
    if (response.isNotEmpty) {
      return supabase.storage.from('image').getPublicUrl(imageName);
    } else {
      return null;
    }
  }

  Future<void> refreshUserSession() async {
    final supabase = Supabase.instance.client;
    final session = await supabase.auth.refreshSession();

    if (session.session != null) {
      print(" Token mới: ${session.session!.accessToken}");
    } else {
      print("Không thể refresh session, có thể user đã đăng xuất.");
    }
  }
}
