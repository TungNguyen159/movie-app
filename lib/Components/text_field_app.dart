import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/radius.dart';

import '../core/theme/gap.dart';

class TextFieldApp extends StatelessWidget {
  const TextFieldApp({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
  });
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Gap.sM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius8,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: radius8,
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          filled: true,
          prefixIcon: prefixIcon,
          prefixIconColor: Theme.of(context).colorScheme.tertiary,
          focusedBorder: OutlineInputBorder(
            borderRadius: radius8,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: Gap.mL,
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
