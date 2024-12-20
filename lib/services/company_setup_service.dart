import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class CompanySetupService {
  final String baseUrl;
  CompanySetupService(this.baseUrl);

  Future<Map<String, dynamic>> createCompanyProfile({
    required String userId,
    required String companyName,
    required String companyContactNumber,
    String? companyEmail,
    File? companyProfilePhoto,
  }) async {
    try {
      // Convert the profile photo to Base64 if it exists
      String? photoBase64;
      if (companyProfilePhoto != null) {
        photoBase64 = base64Encode(await companyProfilePhoto.readAsBytes());
      }

      // Build the request body
      final body = {
        "userId": userId,
        "companyName": companyName,
        "companyContactNumber": companyContactNumber,
        // if (companyEmail != null) "companyEmail": companyEmail,
        // if (photoBase64 != null) "companyProfilePhoto": photoBase64,
        "companyEmail": companyEmail,
"companyProfilePhoto": photoBase64,

      };
print(body);

      // Send POST request
      final response = await http.post(
        Uri.parse('${baseUrl}company-profile'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
print(response.body);
      // Parse response
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create company profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
