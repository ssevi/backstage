import 'package:flutter/material.dart';
import '/services/constants.dart';
import 'package:hive/hive.dart';
import '/services/profile_service.dart';
import '/services/allteam_members_service.dart'; // Import the service for team members
import 'dart:convert';
import '/components/button.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '/screens/import_contact.dart'; // Make sure this path is correct
import '/styles/colors.dart'; // For AppColors

class TeamMembersPage extends StatefulWidget {
  const TeamMembersPage({super.key});

  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  void _importContacts(BuildContext context) async {
    // Show a dialog to explain why you need permission before requesting it
    bool permissionGranted = await _showPermissionDialog(context);

    if (permissionGranted) {
      try {
        // Request permission to access contacts
        final status = await Permission.contacts.request();

        if (status.isGranted) {
          // If permission is granted, fetch contacts
          final contacts = await FlutterContacts.getContacts(
            withProperties: true,
            withThumbnail: true,
          );

          // Navigate to the ContactImportPage with the contacts
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactImportPage(contacts: contacts),
            ),
          );
        } else {
          // If permission is denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permission not granted")),
          );
        }
      } catch (e) {
        // Handle any errors that might occur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

// Show a dialog to explain why the app needs permission and ask the user to grant it
  Future<bool> _showPermissionDialog(BuildContext context) async {
    bool permissionGranted = false;
    await showDialog(
      context: context,
      barrierDismissible: false, // User must respond to the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add the icon from the assets above the title
              Image.asset(
                'assets/images/crew2.png', // Replace with your icon path
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10), // Space between icon and title
              // Split the title into two lines
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Allow ',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'BackStage',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                                    Text(
                    ' to',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 5), // Space between title and the next line
              Text(
                'access your contacts?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option 1: "Always"
              _buildOptionButton(
                  context, "Allow", permissionGranted, true, false),
              // Option 2: "Only while using the app"
              _buildOptionButton(context, "While using the app",
                  permissionGranted, false, false),
              // Option 3: "Only this time"
              _buildOptionButton(
                  context, "Only this time", permissionGranted, false, false),
              // Option 4: "Never"
              _buildOptionButton(
                  context, "Don't Allow", permissionGranted, false, true),
            ],
          ),
        );
      },
    ).then((value) {
      permissionGranted = value ?? false;
    });

    return permissionGranted;
  }

// Custom widget to build each option button with grey background and square edges
  Widget _buildOptionButton(BuildContext context, String option,
      bool permissionGranted, bool isFirst, bool isLast) {
    return GestureDetector(
      onTap: () async {
        // Handle user selection of an option
        Navigator.of(context).pop(true); // Close the dialog
        if (option == "Always" ||
            option == "Only while using the app" ||
            option == "Only this time") {
          permissionGranted = true;
        } else {
          permissionGranted = false;
        }
        // Proceed to request permission if user selects a valid option
        _importContacts(context);
      },
      child: SizedBox(
        width: double.infinity, // Make the button span the full width
        child: Container(
          margin: EdgeInsets.only(
              bottom: isLast ? 0 : 8.0), // No margin below the last option
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? Radius.circular(12) : Radius.zero,
              topRight: isFirst ? Radius.circular(12) : Radius.zero,
              bottomLeft: isLast ? Radius.circular(12) : Radius.zero,
              bottomRight: isLast ? Radius.circular(12) : Radius.zero,
            ),
          ),
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final profileService = ProfileService(baseUrl);
    final box = Hive.box('user_data');
    final userId =
        box.get('user_id', defaultValue: ''); // Default empty string if null
    return await profileService.getProfile(userId);
  }

  // Fetch team members from the API using the service
  Future<List<Map<String, dynamic>>> fetchTeamMembers(String userId) async {
    final teamMemberService = TeamMemberService(baseUrl);
    return await teamMemberService.getTeamMembers(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Set background color to white
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
          final userId = profileData['profile']['userId'] ??
              ''; // Use default empty string if null
          final name = profileData['profile']['userFullName'] ??
              'Unknown'; // Default 'Unknown' if null
          final email = profileData['profile']['userEmail'] ??
              'Unknown'; // Default 'Unknown' if null
          final profileImageBase64 = profileData['profile']
                  ['userProfilePhoto'] ??
              ''; // Default empty string if null
          final mobile = Hive.box('user_data').get('mobile_number',
              defaultValue: 'Unknown'); // Default 'Unknown' if null

          ImageProvider profileImage = profileImageBase64.isNotEmpty
              ? MemoryImage(base64Decode(profileImageBase64))
              : const AssetImage('assets/images/default_profile.jpg')
                  as ImageProvider;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchTeamMembers(userId), // Fetch team members here
            builder: (context, teamMembersSnapshot) {
              if (teamMembersSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (teamMembersSnapshot.hasError) {
                // Instead of showing an error in the center,
                // show the empty team card when there's an error
                return Column(
                  children: [
                    buildProfileCard(name, email, mobile, profileImage),
                    const SizedBox(height: 10),
                    buildEmptyTeamCard(context),
                  ],
                );
              }

              // When data is available and not empty, show team members
              if (teamMembersSnapshot.hasData &&
                  teamMembersSnapshot.data!.isNotEmpty) {
                final teamMembers = teamMembersSnapshot.data!;
                return Column(
                  children: [
                    buildProfileCard(name, email, mobile, profileImage),
                    const SizedBox(height: 10),
                    // Replace SingleChildScrollView with ListView to avoid overflow
                    Expanded(
                      child: ListView.builder(
                        physics:
                            const ClampingScrollPhysics(), // Disables bounce effect
                        itemCount: teamMembers.length,
                        itemBuilder: (context, index) {
                          final member = teamMembers[index];
                          return buildTeamMemberCard(member);
                        },
                      ),
                    ),
                    buildAddNewCrewButton(context),
                  ],
                );
              }

              // When no data or empty data, show empty team card
              return Column(
                children: [
                  buildProfileCard(name, email, mobile, profileImage),
                  const SizedBox(height: 10),
                  buildEmptyTeamCard(context),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildProfileCard(
      String name, String email, String mobile, ImageProvider profileImage) {
    return Container(
      margin: const EdgeInsets.all(8.0), // Decreased margin between cards
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
    );
  }

  Widget buildEmptyTeamCard(BuildContext context) {
    return Container(
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
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 10), // Set text size here
                ),
              ),
            ),
            child: CustomButton(
              text: 'Import from Contact',
              onPressed: () => _importContacts(context),
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
          TextButton(
            style: TextButton.styleFrom(
              side: BorderSide(color: AppColors.primaryColor),
              foregroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Logic for manual entry
            },
            child: const Text('Enter Manually'),
          ),
        ],
      ),
    );
  }

  Widget buildTeamMemberCard(Map member) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: member['profileImage'] != null &&
                  member['profileImage'].isNotEmpty
              ? NetworkImage(member['profileImage'])
              : const AssetImage('assets/images/default_profile.jpg')
                  as ImageProvider,
        ),
        title: Text(member['teamMemberName'] ?? 'Unknown'),
        subtitle: Text(
          '${member['teamMemberContact'] ?? 'Unknown'} • ${member['teamMemberEmail'] ?? 'Unknown'}',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget buildAddNewCrewButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          side: BorderSide(color: const Color(0xFFF8F8F8)),
          foregroundColor: AppColors.primaryColor,
          backgroundColor: const Color(0xFFF8F8F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _importContacts(context),
        icon: const Icon(Icons.add, color: AppColors.primaryColor),
        label: const Text(
          'Add New Crew',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
