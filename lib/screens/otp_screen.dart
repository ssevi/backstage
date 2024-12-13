import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/components/button.dart'; // Import your CustomButton
import '/screens/profile_setup.dart';

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
    mobileNumber = box.get('mobile_number',
        defaultValue: ''); // Load mobile number from Hive
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
    // Add logic to resend OTP here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP has been resent!")),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      // Move focus to next field if the value is not empty
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    // Check if all OTP fields are filled to enable Login button
    setState(() {
      isOtpValid =
          _otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28), // Larger back arrow
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white, // Set the whole page to have a white background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Left align the content
          children: [
            // Title - Enter OTP
            Padding(
              padding: const EdgeInsets.only(
                  top: 200.0), // Move title closer to center
              child: const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left, // Left align the title
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle - Mobile number in Blue
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
                            // Navigate back to login page when 'Change' is clicked
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue, // Blue color for "Change"
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(height: 40),
            // OTP Entry TextField (6 individual boxes)
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
                    textAlign: TextAlign.center, // Center-align the digits
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Resend OTP Button with Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                const Text(
                  'Resend OTP in ',
                  style: TextStyle(color: Colors.black38),
                ),
                Text(
                  '$_start', // The dynamic seconds part
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Make only the seconds bold
                  ),
                ),
                const Text(
                  ' seconds',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                ),
                if (_start == 0)
                  TextButton(
                    onPressed: _resendOtp,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                          color: Colors.blue), // Blue color for Resend OTP
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),
            // Full-width, Center-aligned Login Button
            Center(
              child: SizedBox(
                width: double.infinity, // Full width
                child: CustomButton(
                  text: 'Login',
                  onPressed: isOtpValid
                      ? () {
                              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileSetupPage()), // Navigate directly to Profile Setup
    );
                        }
                      : null, // Disable Login button if OTP is invalid
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Safe and Secure Text
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
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
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
            ),
          ],
        ),
      ),
    );
  }
}
