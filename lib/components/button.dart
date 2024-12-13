import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Allow nullable onPressed

  const CustomButton({required this.text, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 22.0, horizontal: 12.0),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.blue.withOpacity(0.64);
            }
            return Colors.blue;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withOpacity(0.64);
            }
            return Colors.white;
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Reduced border radius
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
