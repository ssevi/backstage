import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/components/button.dart'; // Import your CustomButton
import '/screens/profile_setup.dart';
import '/services/otp_verify.dart';
import '/services/constants.dart';

final otpService = OtpService(baseUrl);

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String mobileNumber;
  late Timer _timer;
  int _start = 30; // Timer for resend OTP
  bool isOtpValid = false; // Flag to track OTP validity

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
    _startTimer();
  }

  void _loadMobileNumber() async {
    final box = Hive.box('user_data');
    mobileNumber = box.get('mobile_number', defaultValue: '');
    setState(() {});
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendOtp() {
    setState(() {
      _start = 30; // Reset timer for resend OTP
    });
    _startTimer(); // Restart timer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP has been resent!")),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    setState(() {
      isOtpValid =
          _otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

void _verifyOtp() async {
  final otp = _otpControllers.map((c) => c.text).join();

  try {
    // Retrieve userId from Hive
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');

    if (userId.isEmpty) {
      throw Exception('User ID not found. Please log in again.');
    }

    // Call the API to verify OTP
    final result = await otpService.verifyOtp(userId, otp);

    // Print the API response for debugging
    print('API Response: $result');

    if (result['success'] == true) {
      // Save the token to Hive
      final token = result['token'];
      if (token != null) {
        await box.put('token', token);
      }

      // Navigate based on userProfile status
      if (result['userProfile'] == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileSetupPage()),
        );
      } else {
        Navigator.pushNamed(context, '/dashboard'); // Assuming '/dashboard' is the route for the dashboard
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Error verifying OTP')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}




  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            mobileNumber.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "We've sent it to +91 $mobileNumber. ",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black38,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) => _onOtpChanged(value, index),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Resend OTP in ',
                  style: TextStyle(color: Colors.black38),
                ),
                Text(
                  '$_start',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(' seconds'),
                if (_start == 0)
                  TextButton(
                    onPressed: _resendOtp,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Login',
                  onPressed: isOtpValid ? _verifyOtp : null,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF02A032).withOpacity(0.08),
                      Colors.white.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '100% safe and secure',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
