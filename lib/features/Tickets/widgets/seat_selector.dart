import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:movie_app/models/seat.dart';

class SeatBookingScreen extends StatefulWidget {
  final Function(List<Seat>, int) onSeatSelected;
  final String showtimeId;

  const SeatBookingScreen({
    super.key,
    required this.onSeatSelected,
    required this.showtimeId,
  });

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  final supabase = Supabase.instance.client;
  List<Seat> seats = [];
  List<Seat> selectedSeats = [];
  int totalPrice = 0;

  final int normalPrice = 50000;
  final int vipPrice = 100000;

  @override
  void initState() {
    super.initState();
    _fetchSeats();
  }

  Future<void> _fetchSeats() async {
    // Tạo danh sách 49 ghế, trong đó 35 ghế thường và 14 ghế VIP
    List<Seat> fixedSeats = List.generate(64, (index) {
      return Seat(
        seatid: 'S${index + 1}',
        status: 'available',
        type: index < 40 ? 'normal' : 'vip',
      );
    });

    // Lấy danh sách ghế đã được đặt từ Supabase
    final response = await supabase
        .from('seats')
        .select()
        .eq('showtime_id', widget.showtimeId);
    if (response.isNotEmpty) {
      for (var bookedSeat in response) {
        String seatId = bookedSeat['seatnumber'];
        int seatIndex = fixedSeats.indexWhere((seat) => seat.seatid == seatId);
        if (seatIndex != -1) {
          fixedSeats[seatIndex].status = 'unavailable'; // Ghế đã được đặt trước
        }
      }
    }

    setState(() {
      seats = fixedSeats;
    });
  }

  void toggleSeat(Seat seat) {
    setState(() {
      if (seat.status == 'available') {
        if (selectedSeats.contains(seat)) {
          selectedSeats.remove(seat);
          seat.status = 'available';
          totalPrice -= seat.type == 'vip' ? vipPrice : normalPrice;
        } else {
          selectedSeats.add(seat);
          seat.status = 'booked';
          totalPrice += seat.type == 'vip' ? vipPrice : normalPrice;
        }
      } else if (seat.status == 'booked') {
        seat.status = 'available';
        selectedSeats.remove(seat);
        totalPrice -= seat.type == 'vip' ? vipPrice : normalPrice;
      }

      widget.onSeatSelected(selectedSeats, totalPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Sơ đồ ghế",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Image.asset("assets/screen.png"),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // 7 ghế mỗi hàng
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  final seat = seats[index];
                  return _buildSeatWidget(seat);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Tổng tiền: $totalPrice vnđ",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatWidget(Seat seat) {
    Color seatColor;
    if (seat.status == 'unavailable') {
      seatColor = Colors.grey;
    } else if (selectedSeats.contains(seat)) {
      seatColor = Colors.red;
    } else {
      seatColor = seat.type == 'vip' ? Colors.amber : Colors.green;
    }

    return GestureDetector(
      onTap: seat.status != 'unavailable' ? () => toggleSeat(seat) : null,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          seat.seatid!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
