import 'package:flutter/material.dart';
import 'package:backstage/styles/colors.dart'; // Import your colors
import 'add_url_sheet.dart'; // Import the AddUrlSheet widget

class Links extends StatelessWidget {
  const Links({super.key});

  @override
  Widget build(BuildContext context) {
    // Icon paths and text for rectangles
final List<Map<String, String>> linkData = [
  {'icon': 'assets/images/website.png', 'iconLarge': 'assets/images/instagram_large.png', 'text': 'Website'},
  {'icon': 'assets/images/insta.png', 'iconLarge': 'assets/images/instagram_large.png', 'text': 'Instagram'},
  {'icon': 'assets/images/youtube.png', 'iconLarge': 'assets/images/instagram_large.png', 'text': 'YouTube'},
  {'icon': 'assets/images/facebook.png', 'iconLarge': 'assets/images/instagram_large.png', 'text': 'Facebook'},
];

void showAddLinkBottomSheet(BuildContext context, Map<String, String> item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => AddLinkBottomSheet(
      iconPath: item['iconLarge']!,
      title: '${item['text']} ID',
      labelText: '${item['text']} ID',
      hintText: 'Enter your ${item['text']} ID',
      buttonText: 'Add ${item['text']} ID',
    ),
  );
}

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Custom AppBar height
        child: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(
                bottom: 18.0), // Adjust back arrow position
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Back action
              },
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(bottom: 8.0), // Adjust title position
            child: Text(
              'Links',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: false,
        ),
      ),
      backgroundColor: Colors.white, // Set entire background to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Repeatable rectangles
            for (var item in linkData)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius:
                      BorderRadius.circular(16), // More rounded corners
                ),
                child: Row(
                  children: [
                    // Circle icon
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(item['icon']!,
                          fit: BoxFit.cover), // Fixed the error
                    ),

                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Text(
                        item['text']!,
                        style: const TextStyle(
                          color: Color(0xFF33465C),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Add button
                  TextButton.icon(
                    onPressed: () => showAddLinkBottomSheet(context, item),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                  ],
                ),
              ),
            // Add New URL button
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: () {
                  // Add new URL action
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor, // Primary color
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                icon: const Icon(Icons.add,
                    size: 20, color: AppColors.primaryColor),
                label: const Text('Add New URL'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
