import 'package:movie_app/models/showtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShowtimeService {
  final supabase = Supabase.instance.client;
  //insert showtime
  Future<void> insertShowtime(Showtime showtimes) async {
    await supabase.from('showtimes').insert({
      'movie_id': showtimes.movieid,
      'hall_id': showtimes.hallid,
      'start_time': showtimes.starttime,
      'ticket_price': showtimes.ticketprice,
    });
  }

  //read showtime
  Future<List<Showtime>> getShowtime() async {
    final response =
        await Supabase.instance.client.from('showtimes').select('*');
    return response.map((showtime) => Showtime.fromJson(showtime)).toList();
  }

  //read showtime by id
  final streamShowtime = Supabase.instance.client.from('showtimes').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((e) => Showtime.fromJson(e)).toList());
  // read showtime by movieid
  Future<List<Showtime>> getShowtimeMovieid(int movieId) async {
    final response = await supabase
        .from('showtimes')
        .select('*, halls(*)')
        .eq('movie_id', movieId);
    return response.map((showtime) => Showtime.fromJson(showtime)).toList();
  }

  // update showtime
  Future<void> updateShowtime(Showtime showtimes) async {
    await supabase
        .from('showtimes')
        .update({
          'movie_id': showtimes.movieid,
          'hall_id': showtimes.hallid,
          'start_time': showtimes.starttime,
          'ticket_price': showtimes.ticketprice,
        })
        .eq('id', showtimes.showtimeid!)
        .select();
  }

  // delete showtime
  Future<void> deleteShowtime(Showtime showtime) async {
    await supabase.from('showtimes').delete().eq('id', showtime.showtimeid!);
  }
}
