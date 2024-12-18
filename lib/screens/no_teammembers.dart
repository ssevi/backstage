import 'package:backstage/styles/colors.dart';
import 'package:flutter/material.dart';
import '/screens/project_added.dart';
import 'package:hive/hive.dart';
import '/services/profile_service.dart';
import '/services/constants.dart';
import 'dart:convert';
import '/services/crew_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'import_contact.dart';
import '/components/button.dart';

class TeamMembersPage extends StatelessWidget {
  const TeamMembersPage({super.key});

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final profileService = ProfileService(baseUrl);
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');
    return await profileService.getProfile(userId);
  }

  Future<List<Contact>> _fetchContacts() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      return await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
    } else {
      throw Exception('Permission not granted');
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/images/crew2.png',
            width: 40,
            height: 40,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Allow ',
                        style: TextStyle(
                          fontSize: 26,
                          color: Color(0xFF1E1C13),
                        ),
                      ),
                      const TextSpan(
                        text: 'BackStage\n',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1C13),
                        ),
                      ),
                      const TextSpan(
                        text: 'to access your contacts.',
                        style: TextStyle(
                          fontSize: 26,
                          color: Color(0xFF1E1C13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _buildPermissionButton('Allow', context),
                  _buildPermissionButton('While using the app', context),
                  _buildPermissionButton('Only this time', context),
                  _buildPermissionButton('Don\'t allow', context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPermissionButton(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () async {
          PermissionStatus status = await Permission.contacts.status;
          if (status.isGranted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FutureBuilder<List<Contact>>(
                  future: _fetchContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return ContactImportPage(contacts: snapshot.data ?? []);
                    }
                  },
                ),
              ),
            );
          } else {
            status = await Permission.contacts.request();
            if (status.isGranted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<List<Contact>>(
                    future: _fetchContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return ContactImportPage(contacts: snapshot.data ?? []);
                      }
                    },
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Permission not granted")),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: text == 'Allow'
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : text == 'Don\'t allow'
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                    : BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Team Members',
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

          final profileData = snapshot.data!;
          final name = profileData['profile']['userFullName'] ?? 'Unknown';
          final email = profileData['profile']['userEmail'] ?? 'Unknown';
          final profileImageBase64 =
              profileData['profile']['userProfilePhoto'] ?? '';
          final mobile = Hive.box('user_data')
              .get('mobile_number', defaultValue: 'Unknown');

          ImageProvider profileImage = profileImageBase64.isNotEmpty
              ? MemoryImage(base64Decode(profileImageBase64))
              : const AssetImage('assets/images/default_profile.jpg')
                  as ImageProvider;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/home_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: profileImage,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$name (You)',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '+91 $mobile • $email',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
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
                            'assets/images/crew.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'You don\'t have any Crew.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'You can import your existing contacts.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),
                          Theme(
                            data: ThemeData(
                              textButtonTheme: TextButtonThemeData(
                                style: ButtonStyle(
                                  textStyle: WidgetStateProperty.all(
                                    TextStyle(
                                        fontSize:
                                            10), // Adjust the text size here
                                  ),
                                ),
                              ),
                            ),
                            child: CustomButton(
                              text: 'Import from Contacts',
                              onPressed: () async {
                                PermissionStatus status =
                                    await Permission.contacts.status;

                                if (status.isGranted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FutureBuilder<List<Contact>>(
                                        future: _fetchContacts(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else {
                                            return ContactImportPage(
                                                contacts: snapshot.data ?? []);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  status = await Permission.contacts.request();
                                  if (status.isGranted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FutureBuilder<List<Contact>>(
                                          future: _fetchContacts(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else {
                                              return ContactImportPage(
                                                  contacts:
                                                      snapshot.data ?? []);
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Permission not granted")),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'or',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Enter crew details manually.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
Theme(
  data: ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColors.primaryColor),
          ),
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.primaryColor),
        textStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), // Adjust the text size here
        ),
      ),
    ),
  ),
  child: TextButton(
    onPressed: () {
      // Logic for manual entry
    },
    child: Text('Enter Manually'),
  ),
)

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