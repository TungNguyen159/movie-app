import 'package:movie_app/models/movie.dart';

class Booking extends Movies {
  final int totalSeat;
  final int totalPrice;
  final String date;
  final String time;
  Booking({
    required super.adult,
    required super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    required super.originalTitle,
    required super.popularity,
    required super.releaseDate,
    required super.title,
    required super.voteAverage,
    required this.totalSeat,
    required this.totalPrice,
    required this.date,
    required this.time,
  });
}
