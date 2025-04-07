import 'dart:convert';
import 'package:http/http.dart' as http;
import 'grade.dart';

class ApiService {
  // Fetch grades from the API
  static Future<List<Grade>> fetchGrades() async {
    try {
      final response = await http.get(
        Uri.parse('http://bgnuerp.online/api/gradeapi'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Return a list of Grade objects
        return jsonData.map((json) => Grade.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load grades (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('API Request Failed: $e');
      return [];  // Return empty list if any error occurs
    }
  }
}
