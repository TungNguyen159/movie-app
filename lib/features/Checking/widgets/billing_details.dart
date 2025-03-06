import 'package:flutter/material.dart';
import 'package:movie_app/models/seat.dart';
import 'package:intl/intl.dart'; // Thư viện để format tiền

class BillingDetails extends StatelessWidget {
  const BillingDetails({super.key, required this.selectedSeats});

  final List<Seat> selectedSeats;

  // Tính tổng tiền
  int calculateTotalPrice() {
    return selectedSeats.fold(
      0,
      (sum, seat) => sum + (seat.type == 'vip' ? 100000 : 50000),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();
    final currencyFormatter = NumberFormat("#,###", "vi_VN"); // Format tiền

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết thanh toán',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),

          // Header
          const Row(
            children: [
              Expanded(child: _SummaryLabel(text: 'Số lượng')),
              Expanded(child: _SummaryLabel(text: 'Loại ghế')),
              Expanded(child: _SummaryLabel(text: 'Giá')),
            ],
          ),
          const Divider(color: Colors.black),

          // Danh sách ghế đã chọn
          ...selectedSeats.map((seat) => Row(
                children: [
                  Expanded(
                    child: _SummaryData(text: seat.seatid!),
                  ),
                  Expanded(
                    child: _SummaryData(
                        text: seat.type == 'vip' ? 'VIP' : 'Thường'),
                  ),
                  Expanded(
                    child: _SummaryData(
                      text:
                          '${currencyFormatter.format(seat.type == 'vip' ? 100000 : 50000)} VNĐ',
                    ),
                  ),
                ],
              )),

          const Divider(color: Colors.black, thickness: 1),
          const SizedBox(height: 10),

          // Tổng tiền
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Tổng tiền: ${currencyFormatter.format(totalPrice)} VNĐ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Component Label tiêu đề
class _SummaryLabel extends StatelessWidget {
  final String text;
  const _SummaryLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// Component hiển thị dữ liệu
class _SummaryData extends StatelessWidget {
  final String text;
  const _SummaryData({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }
}
