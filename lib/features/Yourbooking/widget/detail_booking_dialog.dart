import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/config/api_key.dart';
import 'package:movie_app/config/api_link.dart';

class DetailBookingDialog extends StatelessWidget {
  const DetailBookingDialog({super.key, required this.posterurl});
  final String posterurl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500, // Giới hạn chiều cao
      width: 400, // Giới hạn chiều rộng
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Đặt màu trong BoxDecoration
        borderRadius: BorderRadius.circular(20), // Bo góc
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Đảm bảo nội dung không chiếm toàn bộ không gian
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "${ApiLink.imagePath}$posterurl?api_key=${ApiKey.apiKeys}",
              height: 200, // Giới hạn chiều cao của hình ảnh
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 48, color: Colors.red);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextHead(
                  text: "seat",
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                TextHead(
                  text: "price",
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                TextHead(
                  text: "status",
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  custom_seat(seat: 'seat 1', price: '1000', status: 'Confirm'),
                  custom_seat(seat: 'seat 2', price: '3000', status: 'Confirm'),
                  custom_seat(seat: 'seat 3', price: '4000', status: 'Confirm'),
                  custom_seat(seat: 'seat 4', price: '5000', status: 'Confirm'),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue, // Đặt màu tại đây
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: IconButton(
              onPressed: () {
                Modular.to.pop(); // Đóng dialog
              },
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class custom_seat extends StatelessWidget {
  const custom_seat({
    super.key,
    required this.seat,
    required this.price,
    required this.status,
  });
  final String seat;
  final String price;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextHead(
            text: seat,
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          TextHead(
            text: price,
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          Row(
            children: [
              TextHead(
                text: status,
                textStyle: const TextStyle(color: Colors.green),
              ),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
