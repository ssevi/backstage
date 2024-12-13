import 'package:flutter/material.dart';
import 'dart:io'; // For handling File
import 'package:image_picker/image_picker.dart'; // For picking images
import '/styles/colors.dart'; // Importing your custom colors
import 'package:permission_handler/permission_handler.dart';
import '/components/button.dart'; // Importing your custom button
import '/screens/dashboard.dart'; // Importing CompanySetupPage

class CompanySetupPage extends StatefulWidget {
  const CompanySetupPage({super.key});

  @override
  State<CompanySetupPage> createState() => _CompanySetupPageState();
}

class _CompanySetupPageState extends State<CompanySetupPage> {
  File? _selectedImage; // Store the selected image
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // This method checks whether all inputs are valid
  void _checkValidation() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty;
    });
  }

  Future<void> requestPermissions() async {
    if (await Permission.photos.request().isGranted) {
      // Permission granted
    } else {
      // Handle the permission denial (e.g., show a dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission required to access the gallery.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Pick from gallery

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
    child: Scaffold(
      resizeToAvoidBottomInset: true, // Adjust layout when keyboard appears
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255), // Background color
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Step 2/2',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Setup Company Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '(Optional)',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                          child: _selectedImage == null
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primaryColor,
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Company Name',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your company name',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onChanged: (_) => _checkValidation(),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact Number (Optional)',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    TextField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        hintText: 'Enter your contact number',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email Address (Optional)',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Create Profile',
                        onPressed: _isButtonEnabled
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dashboard()), // Navigate to Dashboard
                                );
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()), // Navigate to Dashboard
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

}
