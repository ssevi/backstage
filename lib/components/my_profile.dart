import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/styles/colors.dart';
import '/components/button.dart';
import 'package:hive/hive.dart';
import '/services/constants.dart';
import '/services/profile_service.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert'; // For Base64 decoding

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService(baseUrl);

  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _isVerified = false; // Tracks if the mobile number is verified.

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }


Future<void> _fetchProfile() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');
    final mobileNumber = box.get('mobile_number', defaultValue: '');

    if (userId.isEmpty) {
      throw Exception('User ID not found. Please log in again.');
    }

    // Fetch profile data
    final profile = await _service.getProfile(userId);
    final data = profile['profile'];

    // Safely assign data to controllers with null checks
    _nameController.text = data['userFullName'] ?? '';
    _emailController.text = data['userEmail'] ?? '';
    _mobileController.text = mobileNumber ?? '';

    // Disable editing for mobile number
    _mobileController.selection =
        TextSelection.collapsed(offset: _mobileController.text.length);

    // Handle Base64 profile photo
    if (data['userProfilePhoto'] != null && data['userProfilePhoto'].isNotEmpty) {
      final photoData = data['userProfilePhoto'];

      if (photoData.startsWith('/9j/') || photoData.startsWith('iVBORw0KGgo')) { // Common Base64 prefixes
        final Uint8List bytes = base64Decode(photoData);
        _selectedImage = await _writeTempImage(bytes); // Save as temporary file
      } else {
        _selectedImage = null; // Invalid Base64 string, fallback to null
      }
    } else {
      _selectedImage = null; // No photo, set to null
    }
  } catch (e) {
    // Show error only if the entire process fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading profile: $e')),
    );
  } finally {
    // Ensure loading state is reset regardless of errors
    setState(() {
      _isLoading = false;
    });
  }
}

// Helper function to save image bytes to a temporary file
Future<File> _writeTempImage(Uint8List bytes) async {
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/profile_photo.png';
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return file;
}


// Helper function to download and save the image.
  Future<String> _downloadImage(String url) async {
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/profile_photo.png');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final box = Hive.box('user_data');
      final userId = box.get('user_id', defaultValue: '');

      if (userId.isEmpty) {
        throw Exception('User ID not found. Please log in again.');
      }

      final result = await _service.updateProfile(
        userId: userId,
        userFullName: _nameController.text.trim(),
        userEmail: _emailController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        userProfilePhoto: _selectedImage,
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        await _fetchProfile(); // Reload profile data
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

void _checkValidation() {
  setState(() {
    _isButtonEnabled = _nameController.text.trim().isNotEmpty ||
        _selectedImage != null;
  });
}


  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
        .hasMatch(email.trim());
  }

Future<void> _pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _checkValidation(); // Revalidate after image selection
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to pick image: $e')),
    );
  }
}


  bool _isValidMobileNumber(String input) {
    return RegExp(r"^[6-9]\d{9}$").hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the content resizes when the keyboard appears
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(100), // Adjust the height as needed
          child: AppBar(
            backgroundColor: Colors.grey.shade100, // Use your primary color
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(top: 20.0), // Adds top margin
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Navigates back to the previous page
                },
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 20.0), // Adds top margin
              child: const Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ), // Centers the title
          ),
        ),

        body: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(), // Show a spinner while loading
              )
            : SingleChildScrollView(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage: _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                        : null,
                                    child: _selectedImage == null
                                        ? const Icon(Icons.person,
                                            size: 60, color: Colors.white)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.edit,
                                            size: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Full Name',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 20),
                              ),
                              onChanged: (_) => _checkValidation(),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Mobile Number',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: 'Enter your mobile number',
                                suffixIcon: _isVerified
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 20),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Email Address',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email address',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 20),
                              ),
                              onChanged: (_) => _checkValidation(),
                            ),
                            const SizedBox(height: 36),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: 'Update Profile',
                                  onPressed: _isButtonEnabled
                                      ? () {
                                          if (_emailController
                                                  .text.isNotEmpty &&
                                              !_isValidEmail(_emailController
                                                  .text
                                                  .trim())) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Please enter a valid email address.'),
                                                backgroundColor: Colors.red,
                                                action: SnackBarAction(
                                                  label: 'Dismiss',
                                                  textColor: Colors.white,
                                                  onPressed:
                                                      () {}, // Dismiss action
                                                ),
                                              ),
                                            );
                                          } else {
                                            // Call the function to submit the profile if validation passes
                                            _updateProfile();
                                          }
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 24), // Adjust spacing as needed
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
