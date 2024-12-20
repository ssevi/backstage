import 'package:backstage/styles/colors.dart';
import 'package:flutter/material.dart';
import '/screens/project_added.dart'; // Importing ProjectAdded screen (as per your current code)
import 'package:hive/hive.dart';
import '/services/bank_upi_get_service.dart'; // Import your BankService
import '/services/constants.dart'; // Import constants for baseUrl
import 'dart:convert';
import 'new_bank.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({super.key});

  // Fetch bank details from the service
  Future<Map<String, dynamic>> fetchBank() async {
    final service = BankUpiService(baseUrl);
    final box = Hive.box('user_data');
    final userId = box.get('user_id', defaultValue: '');
    final banks = await service.getBanks(userId);
    return {'success': banks.isNotEmpty, 'accounts': banks};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Background for the entire screen
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
                      'About Company',
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
        future: fetchBank(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bankData = snapshot.data;
          if (bankData == null || !bankData['success']) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
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
                          'assets/images/bank1.png', // Replace with your icon path
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Bank Details.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add bank details to share with the client',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewBank(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add Bank Details',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Extract UPI and Bank account details from the response
          final upiAccounts = bankData['accounts']['upiAccounts'] as List?;
          final bankAccounts = bankData['accounts']['bankAccounts'] as List?;

          if ((upiAccounts == null || upiAccounts.isEmpty) &&
              (bankAccounts == null || bankAccounts.isEmpty)) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                          'assets/images/bank1.png', // Replace with your icon path
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Bank Details.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add bank details to share with the client',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewBank(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add Bank Details',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UPI Accounts:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (upiAccounts != null && upiAccounts.isNotEmpty)
                    ...upiAccounts.map((upiAccount) {
                      return ListTile(
                        title: Text(upiAccount['upiAccountHolderName'] ?? 'N/A'),
                        subtitle: Text(upiAccount['upiId'] ?? 'N/A'),
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  const Text(
                    'Bank Accounts:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bankAccounts != null && bankAccounts.isNotEmpty)
                    ...bankAccounts.map((bankAccount) {
                      return ListTile(
                        title: Text(bankAccount['bankAccountHolderName'] ?? 'N/A'),
                        subtitle: Text(bankAccount['bankName'] ?? 'N/A'),
                        trailing: Text(bankAccount['bankAccountNumber'] ?? 'N/A'),
                      );
                    }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
