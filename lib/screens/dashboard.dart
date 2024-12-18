import 'package:backstage/styles/colors.dart';
import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/screens/project_added.dart';
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CommonAppBar(),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            top: 0, // Ensure the background starts right from the top
            child: Image.asset(
              'assets/images/home_bg.png', // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(
                top: 0.0,
                left: 16.0,
                right: 16.0), // Adjust padding to respect AppBar height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the entire content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to the center
              children: [
                // Container with the file section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey.shade300), // Light grey border
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center content inside container
                    crossAxisAlignment: CrossAxisAlignment.center, // Center content inside container horizontally
                    children: [
                      // Custom PNG File Icon with Primary Color
                      Image.asset(
                        'assets/images/upload.png', // Replace with your asset path
                        width: 50, // Set the desired size for the image
                        height: 50,
                      ),
                      const SizedBox(height: 20),
                      // Title
                      const Text(
                        'You don\'t have any projects.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Subtitle
                      const Text(
                        'You can import your existing projects.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Import Project Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProjectAdded()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50), // Set a fixed width for the button (e.g., 200)
                          backgroundColor: AppColors.primaryColor, // Primary color for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Import Project',
                          style: TextStyle(
                              color: Colors.white), // Set text color to white
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Smaller Subtitle in Italic
                      const Text(
                        'Supports PDF and Excel',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // OR Divider with horizontal lines
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the OR text and lines
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade400)),
                          const Text('  or  ', style: TextStyle(color: Colors.grey)),
                          Expanded(child: Divider(color: Colors.grey.shade400)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Subtitle for manual entry
                      const Text(
                        'Enter the project details manually.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Enter manually button
                      ElevatedButton(
                        onPressed: () {
                          // Add your action here
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50), // Set a fixed width for the button (e.g., 200)
                          backgroundColor: Colors.white, // Transparent background
                          side: BorderSide(color: AppColors.primaryColor), // Primary color border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Enter Manually',
                          style: TextStyle(
                            color: AppColors.primaryColor, // Text color in primary color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
