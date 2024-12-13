import 'package:flutter/material.dart';
import 'commonnavigationbar.dart';  // Import the CommonNavigationBar widget

class NavbarWrapper extends StatelessWidget {
  final Widget body;
  
  const NavbarWrapper({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,  // Pass the screen content as the body
      bottomNavigationBar: const CommonNavigationBar(),  // Add the CommonNavigationBar
    );
  }
}
