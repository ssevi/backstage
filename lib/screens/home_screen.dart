import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_input.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController inputController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My First Flutter App'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome!',
                style: AppTextStyles.header,
              ),
              const SizedBox(height: 20),
              CustomTextInput(
                label: 'Enter your name',
                controller: inputController,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Submit',
                onPressed: () {
                  // Display a Snackbar with the input value
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hello, ${inputController.text}!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
