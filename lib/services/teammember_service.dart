import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '/services/constants.dart'; // Import baseUrl

class TeamMemberService {
  final String baseUrl;

  TeamMemberService(this.baseUrl);

  Future<Map<String, dynamic>> submitCompanyDetails(Map<String, dynamic> data) async {
    try {
      // Retrieve token and user_id from Hive
      final box = await Hive.openBox('user_data');
      final token = box.get('token');
      final userId = box.get('user_id');

      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found.');
      }

      // Add userId to the request body
      data["userId"] = userId;

      print('Making API call to: ${baseUrl}company-details');
      print('Request body: ${jsonEncode(data)}');  // Log the request data to check

      // Send the HTTP POST request to the API
      final response = await http.post(
        Uri.parse('${baseUrl}company-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Include the token in the Authorization header
        },
        body: jsonEncode(data),  // Send data as JSON
      );

      // Log the response from the API
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return the decoded response body
        return jsonDecode(response.body);
      } else {
        // If not successful, throw an exception with the response status code
        throw Exception('Failed to submit data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions during the API call
      print('Error during API call: $e');
      throw Exception('Error during API call: $e');
    }
  }
}
