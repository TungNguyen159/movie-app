import 'package:movie_app/models/favourite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteService {
  final supabase = Supabase.instance.client;
  //insert favorites
  Future<void> insertfavorite(int movieid) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    await supabase.from('favorites').insert({
      "movie_id": movieid,
      "user_id": user.id,
    });
  }

  //check favor
  Future<String?> checkIfFavorite(int movieid) async {
    final user = supabase.auth.currentUser;

    final response = await supabase
        .from('favorites')
        .select()
        .eq('user_id', user!.id)
        .eq('movie_id', movieid)
        .maybeSingle();

    return response?['id'];
  }

  // read stream favourite by userid
  Stream<List<Favourite>?> get streamfavorites {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      return Stream.value(null);
    }
    return supabase
        .from('favorites')
        .stream(primaryKey: ["id"])
        .eq('user_id', currentUserId)
        .map((data) => data.map((e) => Favourite.fromJson(e)).toList());
  }

  //delete favor
  Future<void> deletefavorite(int movieid) async {
    final user = supabase.auth.currentUser;
    await supabase
        .from('favorites')
        .delete()
        .eq('user_id', user!.id)
        .eq('movie_id', movieid);
  }
}
