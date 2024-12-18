import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ProfileSetupService {
  // Use the baseUrl from constants.dart
  final String baseUrl; // Reference the baseUrl constant
  ProfileSetupService(this.baseUrl);

  Future<Map<String, dynamic>> createProfile({
    required String userId,
    required String userFullName,
    required String userEmail,
    File? userProfilePhoto,
  }) async {
    try {
      // Convert the profile photo to Base64 if it exists
      String? photoBase64;
      if (userProfilePhoto != null) {
        photoBase64 = base64Encode(await userProfilePhoto.readAsBytes());
      }

      // Build the request body
      final body = {
        "userId": userId,
        "userFullName": userFullName,
        "userEmail": userEmail,
        if (photoBase64 != null) "userProfilePhoto": photoBase64,
      };

      // Send POST request
      final response = await http.post(
        Uri.parse('${baseUrl}user-profile'), // Use the complete endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
print(response.body);
      // Parse response
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Save userFullName and userEmail to Hive
          final box = Hive.box('user_data');
          await box.put('userFullName', userFullName);
          await box.put('userEmail', userEmail);

          return data;
        } else {
          throw Exception(data['message'] ?? 'Profile creation failed');
        }
      } else {
        throw Exception('Failed to create profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
