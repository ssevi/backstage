import 'package:flutter/material.dart';
import '/styles/colors.dart';  // Import your colors file
import '/screens/more.dart'; // Import MorePage
import '/screens/home_screen.dart'; // Import HomeScreen
import '/screens/dashboard.dart'; // Import Dashboard
import '/screens/login_screen.dart'; // Import LoginScreen
import '/screens/otp_screen.dart'; // Import OtpScreen
import '/screens/profile_setup.dart'; // Import ProfileSetupPage
import '/screens/company_setup.dart'; // Import CompanySetupPage

class CommonNavigationBar extends StatefulWidget {
  const CommonNavigationBar({super.key});

  @override
  _CommonNavigationBarState createState() => _CommonNavigationBarState();
}

class _CommonNavigationBarState extends State<CommonNavigationBar> {
  int _currentIndex = 0; // Track the current selected index

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Material(
        elevation: 10.0,
        color: Colors.white,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/home_icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/calendar_icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/payment_icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
              label: 'Payments',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/more_icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
              label: 'More',
            ),
          ],
          currentIndex: _currentIndex, // Track selected index
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Navigate to the corresponding route based on index
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/dashboard');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/calendar');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/payments');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/more');
                break;
            }
          },
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey[800],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
        ),
      ),
    );
  }
}
