import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/components/commonnavigationbar.dart';

class ProjectAdded extends StatelessWidget {
  const ProjectAdded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CommonAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white, // Set the background color to white
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Name, Venue, Date etc.',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search,
                        color: Colors.grey), // Search icon
                    onPressed: () {
                      // Implement search functionality if needed
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Upcoming Events Subtitle
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Red Border Card with Title and Details, now with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.red), // Red border for the card
                gradient: LinearGradient(
                  colors: [
                    Color(0x4DFF4D00), // FF4D00 with 30% opacity
                    Color(0x4DFFFFFF), // White with 3% opacity
                  ],
                  begin: Alignment.centerLeft, // Start from left
                  end: Alignment.centerRight, // End at right
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with "Pranit Bhavana" and "In 5 days"
// Row with "Pranit Bhavana" and "In 5 days"
                  Row(
                    children: [
                      const Text(
                        'Pranit Bhavana',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.red), // Red border around the text
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFF4D00).withOpacity(
                                  0.3), // Start with 30% opacity orange
                              Color(0xFFFF4D00).withOpacity(
                                  0.03), // End with 3% opacity orange
                            ],
                          ), // Gradient from orange to white with opacity
                        ),
                        child: const Text(
                          'In 5 days',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Row with "Wednesday", Grey dot, "Bangalore", Grey dot, and Policy Icon
// Row with "Wednesday", Grey dot, "Bangalore", Grey dot, and Policy Icon
                  Row(
                    children: [
                      const Text(
                        'Wednesday',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Bangalore',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      // Replace Icon with custom PNG image from assets
                      Image.asset(
                        'assets/images/rot.png', // Replace with your actual image path
                        width: 20, // Set the width of the image
                        height: 20, // Set the height of the image
                        fit: BoxFit
                            .contain, // Adjust the image to fit inside the box
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CommonNavigationBar(),
    );
  }
}
