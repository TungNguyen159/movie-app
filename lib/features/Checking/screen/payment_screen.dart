import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/app_button.dart';
import 'package:movie_app/Components/back_button.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/features/Checking/widgets/billing_details.dart';
import 'package:movie_app/features/Checking/widgets/payment_options.dart';
import 'package:movie_app/models/seat.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late List<Seat> selectedSeats;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    final data = Modular.args.data;
    selectedSeats = data['selectedSeat'] ?? [];
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    totalPrice = selectedSeats.fold(
        0, (sum, seat) => sum + (seat.type == 'vip' ? 100000 : 50000));
    setState(() {});
  }

  void _handlePayment() {
    // Hiển thị loading khi thanh toán
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Giả lập thời gian xử lý thanh toán
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Đóng loading
      Modular.to.pushNamed("/main/detail/ticket/confirm"); // Điều hướng
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextHead(text: "Thanh toán"),
        leading: BackBind(onPressed: () => Modular.to.pop()),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Billing Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BillingDetails(selectedSeats: selectedSeats),
              ),

              const SizedBox(height: 20),

              // Payment Options
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const PaymentOptions(),
                ),
              ),

              const SizedBox(height: 20),

              // Total Price

              const SizedBox(height: 10),

              // Pay Button
              AppButton(
                text: 'Thanh toán',
                onPressed: _handlePayment,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
