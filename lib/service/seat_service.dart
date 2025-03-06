import 'package:movie_app/models/seat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeatService {
  final supabase = Supabase.instance.client;

  Future<void> insertseat(Seat seat) async {
    await supabase.from('seats').insert({
      'hall_id': seat.hallid,
      'showtime_id': seat.showtimeId,
      'type': seat.type,
      'seatnumber': seat.seatNumber,
      'price': seat.price,
    });
  }

  Future<List<Seat>> getSeatsByHall(String hallId) async {
    final response =
        await supabase.from('seats').select('*').eq('hall_id', hallId);

    if (response.isEmpty) return [];

    return response.map((data) => Seat.fromJson(data)).toList();
  }

  Future<List<Seat>> getSeatsByShowtime(String showtimeid) async {
    final response =
        await supabase.from('seats').select('*').eq('hall_id', showtimeid);

    if (response.isEmpty) return [];

    return response.map((data) => Seat.fromJson(data)).toList();
  }
}
