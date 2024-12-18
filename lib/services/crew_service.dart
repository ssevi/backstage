import 'dart:convert';
import 'package:http/http.dart' as http;
import '/services/constants.dart';

class CrewService {
  static Future<bool> sendContactData(Map<String, dynamic> contactData) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}contacts/submit"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(contactData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to submit contact. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error submitting contact: $e');
      return false;
    }
  }
}
