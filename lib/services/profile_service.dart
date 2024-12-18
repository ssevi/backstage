import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileService {
  final String baseUrl;

  ProfileService(this.baseUrl);

  Future<Map<String, dynamic>> getProfile(String userId) async {
    final url = Uri.parse('${baseUrl}user-profile/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String userFullName,
    required String userEmail,
    String? mobileNumber,
    File? userProfilePhoto,
  }) async {
    final url = Uri.parse('${baseUrl}user-profile/$userId');
    final request = http.MultipartRequest('PUT', url);
    request.fields['userFullName'] = userFullName;
    request.fields['userEmail'] = userEmail;
    if (mobileNumber != null) {
      request.fields['newMobileNumber'] = mobileNumber;
    }
    if (userProfilePhoto != null) {
      request.files.add(
        await http.MultipartFile.fromPath('userProfilePhoto', userProfilePhoto.path),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

    Future<Map<String, dynamic>> sendOtp(String mobileNumber) async {
    final String url = '$baseUrl/send-otp'; // Adjust the endpoint path as per your backend API.
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobileNumber': mobileNumber}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'OTP sent successfully',
          'data': jsonDecode(response.body),
        };
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': 'Invalid mobile number',
        };
      } else if (response.statusCode == 429) {
        return {
          'success': false,
          'message': 'Too many requests. Please try again later.',
        };
      } else {
        return {
          'success': false,
          'message': 'An unexpected error occurred',
          'statusCode': response.statusCode,
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error: ${error.toString()}',
      };
    }
  }
}
