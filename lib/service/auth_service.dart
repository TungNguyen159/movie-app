import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // signin with email
  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  //signup with email 
  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }
  //signout
  Future<void> signOut()async{
    await _supabase.auth.signOut();
  }

  //getuseremail
  String? getuseremail(){
    final session = _supabase.auth.currentSession;
    final user = session!.user;
    return user.email;
  }
}
