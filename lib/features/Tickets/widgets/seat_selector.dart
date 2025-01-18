import 'package:flutter/material.dart';
import 'package:movie_app/models/seat.dart';

class SeatBookingScreen extends StatefulWidget {
  final Function(List<Seat>) onSeatSelected;
  const SeatBookingScreen({super.key, required this.onSeatSelected});

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  final List<Seat> seats = List.generate(49, (index) {
    // Tạo danh sách ghế mẫu
    // String status = index % 5 == 0
    //     ? 'unavailable'
    //     : (index % 2 == 0 ? 'booked' : 'available');
    String status = index % 5 == 0 ? 'unavailable' : 'available';
    return Seat(id: 'Seat ${index + 1}', status: status, price: 30);
  });
  List<Seat> selectedSeat = [];
  void selectSeat(int index) {
    setState(() {
      if (seats[index].status == 'available') {
        if (selectedSeat.contains(seats[index])) {
          selectedSeat.remove(seats[index]);
        } else {
          seats[index].status = 'booked'; // Đặt ghế
          selectedSeat.add(seats[index]);
          widget.onSeatSelected(selectedSeat);
        }
      } else if (seats[index].status == 'booked') {
        seats[index].status = 'available'; // Hủy đặt ghế
        selectedSeat.remove(seats[index]);
        widget.onSeatSelected(selectedSeat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // Số ghế trên mỗi hàng
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: seats.length,
          itemBuilder: (context, index) {
            final seat = seats[index];
            return GestureDetector(
              onTap: seat.status != 'unavailable'
                  ? () => selectSeat(index)
                  : null, // Chỉ cho phép chọn nếu ghế không phải "unavailable"
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: seat.status == 'available'
                      ? Colors.green // Chưa đặt
                      : (seat.status == 'booked'
                          ? Colors.red // Đã đặt
                          : Colors.grey), // Không thể đặt
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  seat.id,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
