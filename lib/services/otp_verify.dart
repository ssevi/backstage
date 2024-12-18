// lib/services/otp_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  final String baseUrl;

  OtpService(this.baseUrl);

  Future<Map<String, dynamic>> verifyOtp(String userId, String otp) async {
    final url = Uri.parse("${baseUrl}auth/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "userId": userId,
          "otp": otp,
        }),
      );
print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
