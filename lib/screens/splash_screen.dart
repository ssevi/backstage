import 'package:flutter/material.dart';
import 'dart:async';
import '../styles/colors.dart'; // Import the AppColors

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to the next screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    // Animation controller for the loader
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duration for the loader to fill
    )..forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/splash_bg.png', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Circular Loader placed slightly below the center
          Align(
            alignment: const Alignment(0, 0.7), // Adjust position below the center
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Small filled circle
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                // Circular Loader that slowly fills
                SizedBox(
                  width: 30,
                  height: 30,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        strokeWidth: 4,
                        value: _controller.value, // Progress value from 0 to 1
                        color: AppColors.primaryColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
