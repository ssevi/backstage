import 'package:backstage/styles/colors.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import '/services/profile_service.dart'; // Import your ProfileService
import '/services/constants.dart'; // Import constants for baseUrl
import 'dart:convert';
import 'terms_conditions_template.dart';
import '/services/terms_conditions_service.dart';


class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  // Fetch templates from the service
  Future<List<Map<String, dynamic>>> fetchTemplates() async {
    final service = TermsConditionsService(baseUrl);
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');
    return await service.getTemplates(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F8F8), // Background for the entire screen
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Set custom AppBar height
        child: Container(
          color: const Color(0xFFF8F8F8), // AppBar background color
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.end, // Align content to the bottom
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0,
                        bottom: 8.0), // Adjust padding for back arrow
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Back action
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 8.0, bottom: 8.0), // Adjust padding for title
                    child: Text(
                      'Terms & Conditions',
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTemplates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final templates = snapshot.data ?? [];
          if (templates.isEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(
                        16.0), // Margin around the container
                    padding: const EdgeInsets.all(
                        16.0), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/contractor.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Data Available.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'You haven\'t created any template.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsConditionsTemplate(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                                double.infinity, 50), // Full-width button
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Create a Template',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
  padding: const EdgeInsets.all(16.0), // Outer margin around the entire container
  child: Container(
    width: double.infinity, // Make it full width
    margin: const EdgeInsets.all(16.0), // Margin to simulate space around the card
    padding: const EdgeInsets.all(16.0), // Inner padding for content inside the container
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          templates[0]['content'] ?? 'No content available.',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  ),
);

          }
        },
      ),
    );
  }
}
