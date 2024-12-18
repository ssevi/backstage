import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/styles/colors.dart';
import '/components/button.dart';
import '/screens/company_setup.dart';
import '/services/profile_setup_service.dart';
import 'package:hive/hive.dart';
import '/services/constants.dart';
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // Pass the baseUrl constant to the service constructor
  final ProfileSetupService _service = ProfileSetupService(baseUrl);


  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _checkValidation() {
    setState(() {
      _isButtonEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
        .hasMatch(email.trim());
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Retrieve userId from Hive
      final box = Hive.box('user_data');
      final userId = box.get('user_id', defaultValue: '');

      if (userId.isEmpty) {
        throw Exception('User ID not found. Please log in again.');
      }

      // Validate email if entered
      if (_emailController.text.isNotEmpty &&
          !_isValidEmail(_emailController.text.trim())) {
        throw Exception('Please enter a valid email address.');
      }

      // Call the service to create profile
      final result = await _service.createProfile(
        userId: userId,
        userFullName: _nameController.text.trim(),
        userEmail: _emailController.text.trim(),
        userProfilePhoto: _selectedImage,
      );
      print(result);
      if (result['success'] == true) {
        // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CompanySetupPage()),
        );
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the content resizes when the keyboard appears
        body: SingleChildScrollView(
          // Wraps the content to allow scrolling
          child: Container(
            color: AppColors.backgroundColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 24), // Adds some spacing for better alignment
                const Text(
                  'Step 1/2',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Setup Your Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter details to setup your profile',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
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
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Icon(
                                    _selectedImage == null
                                        ? Icons.camera_alt
                                        : Icons.edit,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Your Full Name',
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
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                        ),
                        onChanged: (_) => _checkValidation(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Email Address (Optional)',
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
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
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
                            text: 'Continue',
                            onPressed: _isButtonEnabled
    ? () {
        if (_emailController.text.isNotEmpty &&
            !_isValidEmail(_emailController.text.trim())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please enter a valid email address.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {}, // Dismiss action
              ),
            ),
          );
        } else {
          // Call the function to submit the profile if validation passes
          _submitProfile();
        }
      }
    : null,

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24), // Adjust spacing as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
