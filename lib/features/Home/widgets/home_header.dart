import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'MovieVerse',
          style: TextStyle(
            fontSize: 40,
            color: Theme.of(context).colorScheme.onPrimary,
            fontFamily: 'Gistesy',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
