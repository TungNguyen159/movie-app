import 'package:movie_app/models/hall.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HallService {
  final supabase = Supabase.instance.client;

  Future<List<Hall>> gethall() async {
    final response = await supabase.from('halls').select();
    if (response.isEmpty) {
      return [];
    }

    return response.map<Hall>((hall) => Hall.fromJson(hall)).toList();
  }

  Future<Map<String, dynamic>?> fetchHallById(String hallId) async {
    final response = await Supabase.instance.client
        .from('halls')
        .select('*')
        .eq('id', hallId)
        .single();
    return response;
  }


}
