import 'package:backstage/styles/colors.dart';
import 'package:flutter/material.dart';
import '/components/appbar.dart'; // Your custom AppBar
import '/screens/project_added.dart'; // Importing ProjectAdded screen (as per your current code)
import 'package:hive/hive.dart';
import '/services/profile_service.dart'; // Import your ProfileService
import '/services/constants.dart'; // Import constants for baseUrl
import 'dart:convert';

class BankDetails extends StatelessWidget {
  const BankDetails({super.key});

  // Fetch user profile from the service
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final profileService = ProfileService(baseUrl);
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');
    return await profileService.getProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Set custom AppBar height
        child: Container(
          color: Colors.grey.shade100, // AppBar background color
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align content to the bottom
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0,
                        bottom: 8.0), // Adjust padding for back arrow
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Back action
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 8.0, bottom: 8.0), // Adjust padding for title
                    child: Text(
                      'Bank Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          // Extract data from the snapshot
          final profileData = snapshot.data!;
          final name = profileData['profile']['userFullName'] ?? 'Unknown';
          final email = profileData['profile']['userEmail'] ?? 'Unknown';
          final profileImageBase64 =
              profileData['profile']['userProfilePhoto'] ?? '';
          final mobile = Hive.box('user_data').get('mobile_number', defaultValue: 'Unknown');

          ImageProvider profileImage = profileImageBase64.isNotEmpty
              ? MemoryImage(base64Decode(profileImageBase64))
              : const AssetImage('assets/images/default_profile.jpg')
                  as ImageProvider;

          return Stack(
            children: [
              Positioned.fill(
                top: 0,
                child: Image.asset(
                  'assets/images/home_bg.png', // Replace with your background image
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 16.0,
                    right: 16.0), // Adjust padding to account for AppBar height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // First container (existing rectangle)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/bank1.png', // Replace with your icon path
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No Bank Details.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Add bank details to share with the client',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProjectAdded(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add Bank Details',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                           
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
