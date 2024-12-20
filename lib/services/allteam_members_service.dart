import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class TeamMemberService {
  final String baseUrl;

  TeamMemberService(this.baseUrl);

  Future<List<Map<String, dynamic>>> getTeamMembers(String userId) async {
    try {
      // Retrieve token and user_id from Hive
      final box = await Hive.openBox('user_data');
      final token = box.get('token');
      final userIdFromHive = box.get('user_id'); // Use a separate variable to avoid confusion

      // Check if token or userId are null
      if (token == null || userIdFromHive == null) {
        throw Exception('Authentication token or user ID not found.');
      }

      // Ensure userId is passed and is not null
      String userIdToUse = userId.isNotEmpty ? userId : userIdFromHive;
      
      // Make the request with the correct user ID
      final response = await http.get(
        Uri.parse('${baseUrl}company-details?userId=$userIdToUse&type=teamMembers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add Authorization header if required
        },
      );

      // Log the request and response
      print('Requesting URL: ${baseUrl}company-details?userId=$userIdToUse&type=teamMembers');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if there are team members in the response
        if (data['success'] == true && data['teamMembers'] != null) {
          print('Team members found: ${data['teamMembers']}');
          return List<Map<String, dynamic>>.from(data['teamMembers']);
        } else {
          print('No team members found in the response');
          return [];
        }
      } else {
        final errorData = jsonDecode(response.body);
        print('Error response body: $errorData');
        throw Exception('Failed to fetch team members: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error fetching team members: $e');
      throw Exception('Error fetching team members: $e');
    }
  }
}
