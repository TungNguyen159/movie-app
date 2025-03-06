class Hall {
  final String hallid;
  final String nameHall;
  final int totalSeat;

  Hall({
    required this.hallid,
    required this.nameHall,
    required this.totalSeat,
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      hallid: json['id'].toString(),
      nameHall: json['name'] ?? 'unknown',
      totalSeat: json['total_seat'] ?? 'unknown',
    );
  }
}
