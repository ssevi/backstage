import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/components/button.dart'; // Import your custom button component
import '/services/teammember_service.dart'; // Import the service for API calls
import '/services/constants.dart'; // Ensure you import your constants file
import '/components/popup_message.dart';
class ContactBottomSheet extends StatefulWidget {
  final Contact contact;

  const ContactBottomSheet({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactBottomSheetState createState() => _ContactBottomSheetState();
}

class _ContactBottomSheetState extends State<ContactBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  bool isDataFilled = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.displayName);
    phoneController = TextEditingController(
        text: widget.contact.phones.isNotEmpty
            ? widget.contact.phones.first.number
            : "");
    emailController = TextEditingController(
        text: widget.contact.emails.isNotEmpty
            ? widget.contact.emails.first.address
            : "");

    // Initially check if any field has data
    _checkDataFilled();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _checkDataFilled() {
    setState(() {
      isDataFilled = nameController.text.isNotEmpty ||
          phoneController.text.isNotEmpty ||
          emailController.text.isNotEmpty;
    });
  }
String cleanPhoneNumber(String phone) {
  // Use regular expression to remove all non-numeric characters (like parentheses, spaces, hyphens)
  return phone.replaceAll(RegExp(r'[^0-9]'), '');
}

Future<void> _submitData() async {
  print("Submit button clicked");
String cleanedPhone = cleanPhoneNumber(phoneController.text);

  // Start building the payload with the mandatory fields
  final data = {
    "teamMembers": [
      {
        "newMemberData": {
          "teamMemberName": nameController.text,
          "teamMemberContact": cleanedPhone,
          "teamMemberEmail": emailController.text,
        }
      }
    ],
    // Ensure all other fields are present if needed
    "aboutCompany": "",
    "termsAndConditions": "",
    "links": {
      "webSite": "",
      "others": []
    },
    "bankDetails": {
      "upi": [],
      "banks": []
    },
  };

try {
  final response = await TeamMemberService(baseUrl).submitCompanyDetails(data);
  print("API called!");

  if (response['success']) {
    Navigator.pop(context); // Close the bottom sheet if open
showCustomPopup(context, 'Crew Added Successfully.');
  } else {
    // Handle API failure, if needed
    throw Exception('Failed to update company details: ${response['message']}');
  }
} catch (e) {
  print('API Error: $e');
  
  // Close the bottom sheet before showing the SnackBar
  Navigator.pop(context); // Ensure the bottom sheet is closed
  
  // Check if the error is related to the 400 status code
  if (e is http.Response && e.statusCode == 400) {
    // Show the message from the response body when status code is 400
    final responseBody = jsonDecode(e.body);
    String errorMessage = responseBody['message'] ?? "Unknown error occurred";
     // Show the custom popup instead of the Snackbar
  showCustomPopup(context, errorMessage);
  } else {
    // Handle other exceptions and show a generic error message

      showCustomPopup(context, 'The contact number already exists.');
  }
}




}



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              "Crew Detail",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Corrected textAlign placement
            ),
            const SizedBox(height: 16),

            // User Image
            CircleAvatar(
              radius: 40,
              backgroundImage: widget.contact.photo != null
                  ? MemoryImage(widget.contact.photo!)
                  : null,
              child: widget.contact.photo == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(height: 16),

            // Name Input Field
            _buildTextField(controller: nameController, label: "Name"),
            const SizedBox(height: 8),

            // Phone Input Field
            _buildTextField(controller: phoneController, label: "Phone"),
            const SizedBox(height: 8),

            // Email Input Field
            _buildTextField(controller: emailController, label: "Email"),
            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
                width: double.infinity, // Make button full width
                child: CustomButton(
                  text: "Add Crew",
                  onPressed: isDataFilled ? _submitData : null,
                )),
          ],
        ),
      ),
    );
  }

  // Custom TextField Builder with separate label above
  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    controller.addListener(_checkDataFilled); // Listen for changes
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF001833)),
        ),
        const SizedBox(height: 4), // Space between label and field
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey), // Grey border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue), // Blue on focus
            ),
          ),
        ),
      ],
    );
  }
}
