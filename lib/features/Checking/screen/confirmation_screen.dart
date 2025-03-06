import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movie_app/Components/app_button.dart';
import 'package:movie_app/Components/text_head.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset("assets/9.png"),
            ),
            const TextHead(text: "Your ticket have been booked"),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                text: "Go to home",
                onPressed: () {
                 Modular.to.navigate("/main");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
