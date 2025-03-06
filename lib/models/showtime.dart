class Showtime {
  final String? showtimeid;
  final int? movieid;
  final String? hallid;

  final String starttime;
  final int ticketprice;

  Showtime(
      {this.showtimeid,
      required this.movieid,
      required this.hallid,
      required this.starttime,
      required this.ticketprice});

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      showtimeid: json['id'].toString(),
      movieid: json['movie_id'] ?? 'no movieid',
      starttime: json['start_time'],
      hallid: json['hall_id'] ?? 'no hallid',
      ticketprice: json['ticket_price'] ?? 'no ticketprice',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieid,
      'hall_id': hallid,
      'start_time': starttime,
      'ticket_price': ticketprice,
    };
  }
}
