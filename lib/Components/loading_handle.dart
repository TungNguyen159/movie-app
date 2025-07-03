import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoadingHandle {
  static void handleLoading(BuildContext context, String route) {
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
      Modular.to.pushNamed(route); // Điều hướng đến trang sau khi thanh toán
    });
  }
}
