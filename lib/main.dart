import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart'; // Import your HomeScreen or other target screen
import 'screens/splash_screen.dart'; // Import the SplashScreen
import 'screens/login_screen.dart'; // Import LoginScreen
import 'screens/otp_screen.dart';
import 'screens/profile_setup.dart';
import 'screens/company_setup.dart'; // Importing CompanySetupPage
import 'screens/dashboard.dart'; // Importing CompanySetupPage
import 'screens/more.dart'; // Importing CompanySetupPage
import 'components/navbar_wrapper.dart'; // Import the CommonNavigationBar widget
import 'screens/calendar.dart'; // Importing CompanySetupPage
import 'screens/payments.dart'; // Importing CompanySetupPage

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('user_data'); // Open the box for storing user data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Backstage App',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => const OtpScreen(),
        '/profileSetup': (context) => ProfileSetupPage(),
        '/companySetup': (context) => CompanySetupPage(),
        '/dashboard': (context) => NavbarWrapper(body: Dashboard()),  // Wrap MorePage with navigation bar
        '/more': (context) => NavbarWrapper(body: MorePage()),  // Wrap MorePage with navigation bar
        '/calendar': (context) => NavbarWrapper(body: Calendar()),  // Wrap MorePage with navigation bar
        '/payments': (context) => NavbarWrapper(body: Payments()),  // Wrap MorePage with navigation bar

      },
      // home: Scaffold(
      //   body: HomeScreen(), // Default screen
      //   bottomNavigationBar: const CommonNavigationBar(), // Add the CommonNavigationBar widget
      // ),
    );
  }
}
