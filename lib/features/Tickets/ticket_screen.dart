import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/back_button.dart';
import 'package:movie_app/config/api_handle.dart';
import 'package:movie_app/features/Tickets/widgets/date_selector.dart';
import 'package:movie_app/features/Tickets/widgets/seat_selector.dart';
import 'package:movie_app/features/Tickets/widgets/time_selector.dart';
import 'package:movie_app/models/seat.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.movieId});
  final int movieId;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late Future<String> movietitle;
  String? selectedDate;
  String? selectedTime;
  final List<Seat> selectedSeat = [];
  @override
  void initState() {
    super.initState();
    movietitle = ControllerApi().getitle(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Tách AppBar thành hàm riêng
      body: Column(
        children: [
          DateSelector(
            onDateSelected: (selectedDate) {
              setState(() {
                this.selectedDate = selectedDate; // Lưu ngày được chọn
              });
            },
          ),
          TimeSelector(
            onTimeSelected: (selectedTime) {
              setState(() {
                this.selectedTime = selectedTime;
              });
            },
          ),
          Expanded(
            child: SeatBookingScreen(
              onSeatSelected: (selectedSeats) {
                setState(() {
                  selectedSeat.clear();
                  selectedSeat.addAll(selectedSeats);
                });
              },
            ),
          ),
          _buildNextButton(context),
        ],
      ),
    );
  }

  // Hàm xây dựng AppBar
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: BackBind(
        onPressed: () {
          Modular.to.pop();
        },
      ),
      title: FutureBuilder<String>(
        future: movietitle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading..."); // Hiển thị khi đang tải
          } else if (snapshot.hasError) {
            return const Text("Error loading title"); // Lỗi
          } else {
            return Text(snapshot.data ?? "No Title", // In ra title
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
          }
        },
      ),
    );
  }

  // Hàm xây dựng nút Next
  Widget _buildNextButton(BuildContext context) {
    final isDisabled =
        selectedDate == null || selectedTime == null || selectedSeat.isEmpty;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  Modular.to.pushNamed(
                    '/main/detail/ticket/seat/${widget.movieId}',
                    arguments: {
                      "selectedSeat": selectedSeat,
                      "selectedDate": selectedDate,
                      "selectedTime": selectedTime,
                    },
                  );
                },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDisabled
                  ? Colors.grey // Màu xám nếu bị vô hiệu hóa
                  : Theme.of(context)
                      .colorScheme
                      .primary, // Màu xanh nếu hợp lệ
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                "Next",
                style: TextStyle(
                  color: isDisabled
                      ? Colors.black
                          .withOpacity(0.5) // Màu chữ khi bị vô hiệu hóa
                      : Colors.white, // Màu chữ khi hợp lệ
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
