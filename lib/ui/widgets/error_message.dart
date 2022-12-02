import 'package:flutter/material.dart';
import 'package:test_roulette/ui/utils/theme_colors.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorText});
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return errorText.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: errorColor,
              ),
            ),
          );
  }
}