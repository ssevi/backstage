import 'package:flutter/material.dart';
import '/components/appbar.dart'; // Import your CommonAppBar
import '/components/commonnavigationbar.dart'; // Import your CommonNavigationBar

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CommonAppBar(), // CommonAppBar with primary color as background
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(), // This removes the bouncing effect
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center all items
            children: [
              // Menu container with title, subtitle, and menu items
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // Increased corner radius
                  border:
                      Border.all(color: Colors.grey.shade300), // Light border
                  color: Colors.white, // White background
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align left for the avatar and title
                  children: [
                    // Title and subtitle with avatar
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 8.0), // Reduced top padding
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40, // Avatar size
                            backgroundImage: AssetImage(
                                'assets/images/avatar.png'), // Replace with your avatar image
                            backgroundColor: Colors.grey
                                .shade200, // Light grey background for the avatar
                          ),
                          const SizedBox(
                              width: 16), // Space between avatar and title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align title and subtitle to the left
                            children: const [
                              Text(
                                'Vows of Love',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '+91 88661 98731',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.circle,
                                      size: 5,
                                      color: Colors.grey), // Dot separator
                                  SizedBox(width: 5),
                                  Text(
                                    'hello@vowoflove.in',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.3),

                    // First menu items list
                    Column(
                      children: [
                        _menuItem(
                            context, 'Team Members', 'assets/images/team.png'),
                        _menuItem(context, 'About Company',
                            'assets/images/about.png'),
                        _menuItem(context, 'Links', 'assets/images/link.png'),
                        _menuItem(
                            context, 'Bank Details', 'assets/images/bank.png'),
                        _menuItem(context, 'Terms & Conditions',
                            'assets/images/bank.png'),
                      ],
                    ),
                    // Add a subtitle here
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Templates',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Second menu items list
                    Column(
                      children: [
                        _menuItem(context, 'Enquiry Form',
                            'assets/images/enquiry.png'),
                        _menuItem(context, 'Quotation',
                            'assets/images/quotation.png'),
                        _menuItem(
                            context, 'Invoice', 'assets/images/enquiry.png'),
                        _menuItem(context, 'Feedback Form',
                            'assets/images/feedback.png',
                            isLast: true),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Add a new container for the Subscription menu item
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // Increased corner radius
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    _menuItem(context, 'Subscription', 'assets/images/subs.png',
                        isLast: true), // Subscription item
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Made with Love section
              const Center(
                child: Text(
                  'Made with ❤️ in India',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'App Version 1.0',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // Logout title
              GestureDetector(
                onTap: () {
                  // Handle logout logic
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => LogoutPage()));
                },
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menu item widget with an icon on the left and an arrow on the right
  Widget _menuItem(BuildContext context, String title, String iconPath,
      {bool isLast = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 0), // Reduced margin
      child: Column(
        children: [
          // Menu item row with icon and title
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 0), // Reduced padding
            leading: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0), // Margin on the right of the leading icon
              child: CircleAvatar(
                radius: 18, // Icon size
                backgroundColor: Colors.grey.shade200, // Light grey background
                child: Image.asset(
                  iconPath, // PNG icon
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            title: Text(title, style: const TextStyle(fontSize: 16)),
            trailing: Padding(
              padding: const EdgeInsets.only(
                  right: 12.0), // Margin on the left of the trailing icon
              child: const Icon(Icons.arrow_forward_ios,
                  size: 20), // Go arrow on the right
            ),
            onTap: () {
              // Handle menu item tap if necessary
            },
          ),
          // Only show the divider if it's not the last item
          if (!isLast)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0), // Margin on left and right of the divider
              child: const Divider(
                  color: Colors.grey,
                  thickness: 0.3), // Divider that doesn't touch the edges
            ),
        ],
      ),
    );
  }
}
