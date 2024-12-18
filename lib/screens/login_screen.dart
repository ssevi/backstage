import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/components/button.dart'; // Import your CustomButton
import '/services/constants.dart'; // Import the constants
import '/services/login_service.dart'; // Import the API service

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isButtonEnabled = false;
  final ApiService _apiService = ApiService(baseUrl);

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      bool isValid = value.length == 10 && RegExp(r'^[6-9]').hasMatch(value);
      _isButtonEnabled = isValid;

      // Show validation message if the number is invalid after 10 digits
      if (value.length == 10 && !isValid) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This is not a valid mobile number")),
          );
        }
      }
    });
  }

  Future<void> _handleLogin() async {
    final mobileNumber = _mobileController.text.trim();

    try {
      final result = await _apiService.login(mobileNumber);

      if (result['success'] == true) {
        final box = Hive.box('user_data');
        await box.put('mobile_number', mobileNumber);
        await box.put('user_id', result['userId']); // Save userId to Hive
        print('nmm: $mobileNumber');

        print('API Response: $result');

        if (context.mounted) {
          Navigator.pushNamed(context, '/otp', arguments: {
            'otp': result['otp'], // Pass OTP and userId to the next screen
            'userId': result['userId'],
          });
        }
      } else {
        // Show error message from API
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      // Handle any exceptions
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/login_top_image.png', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Bottom Half Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your mobile number to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 44),
                  const Text(
                    'Mobile Number *',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter your mobile number',
                      hintStyle: const TextStyle(color: Colors.black38),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: _onTextChanged,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Continue',
                    onPressed: _isButtonEnabled ? _handleLogin : null,
                  ),
                  const SizedBox(height: 46),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF02A032).withOpacity(0.08),
                                Colors.white.withOpacity(0.08),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.verified_user,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '100% safe and secure',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
