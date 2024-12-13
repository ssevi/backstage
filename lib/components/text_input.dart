import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextInput({required this.label, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
