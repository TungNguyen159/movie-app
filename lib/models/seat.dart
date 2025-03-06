class Seat {
  final String? seatid;
  final String? hallid;
  final String? showtimeId;
  final String? seatNumber;
  final String type;
  final String? price;
  String? status;

  Seat({
    this.seatid,
    this.hallid,
    this.showtimeId,
    this.seatNumber,
    this.price,
    this.status,
    required this.type,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      hallid: json['hall_id'],
      showtimeId: json['showtime_id'],
      seatNumber: json['seatnumber'],
      status: json['status'],
      price: json['price'],
      type: json['type'],
    );
  }
}
