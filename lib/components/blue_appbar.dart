import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/services/profile_service.dart'; // Import your profile service
import '/services/constants.dart';
import 'package:hive/hive.dart';
import 'my_profile.dart';

class BlueAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BlueAppBar({super.key});

  // Fetch user profile from the service
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final profileService = ProfileService(baseUrl);
    return await profileService.getProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    // Get the userId from Hive
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
      child: Stack(
        children: [
          // Background with rounded corners and background image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                     Color(0xFF0051AF),
                    Color(0xFF0076FF),
                   
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/blue.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.blue.withOpacity(0.2),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),
          // Foreground content of the AppBar
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchUserProfile(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load profile'));
                  } else if (snapshot.hasData) {
                    var profileData = snapshot.data!;
                    String username =
                        profileData['profile']['userFullName'] ?? 'No name';
                    String profileImageBase64 =
                        profileData['profile']['userProfilePhoto'] ?? '';
                    String subtitle = 'Premium'; // Hardcoded as Premium

                    // Decode the base64 string to display the profile image
                    ImageProvider profileImage = profileImageBase64.isNotEmpty
                        ? MemoryImage(base64Decode(
                            profileImageBase64)) // Decode the base64 string
                        : const AssetImage('assets/images/default_profile.jpg')
                            as ImageProvider;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile avatar with dynamic image
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: profileImage,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.yellow,
                                child: const Icon(
                                  Icons.star,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Username and subscription (Premium)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/update.png',
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [Colors.yellow, Colors.orange],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: Text(
                                      subtitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Circle and Arrow at the end
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the MyProfile page when the arrow is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilePage()), // Replace MyProfile with your actual profile page
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    'assets/images/arrowfrnd.png', // Path to your arrow image
                                    width: 18, // Adjust size if needed
                                    height: 18, // Adjust size if needed
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120); // Adjusted height
}
