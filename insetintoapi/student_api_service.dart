import 'package:http/http.dart' as http;
import 'dart:convert';

class Course {
  final String subjectCode;
  final String subjectName;

  Course({required this.subjectCode, required this.subjectName});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      subjectCode: json['subject_code'] as String,
      subjectName: json['subject_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'subject_code': subjectCode,
        'subject_name': subjectName,
      };
}

class StudentRecord {
  final String userId;
  final String courseName;
  final String creditHours;
  final String marks;
  final String semesterNo;

  StudentRecord({
    required this.userId,
    required this.courseName,
    required this.creditHours,
    required this.marks,
    required this.semesterNo,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      userId: json['user_id'].toString(),
      courseName: json['course_name'] as String,
      creditHours: json['credit_hours'].toString(),
      marks: json['marks'].toString(),
      semesterNo: json['semester_no'].toString(),
    );
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class StudentApiService {
  static const String _baseUrl = 'https://devtechtop.com/management/public/api';
  static const String _coursesUrl = 'https://bgnuerp.online/api';

  Future<List<Course>> fetchCourses() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_coursesUrl/get_courses?user_id=12122'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Course.fromJson(json)).toList();
      }
      throw ApiException('Failed to load courses: ${response.statusCode}');
    } catch (e) {
      throw ApiException('Error fetching courses: $e');
    }
  }

  Future<List<StudentRecord>> fetchStudentData(String userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/select_data?user_id=$userId'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> records = data['data'] ?? [];
        return records
            .where((record) => record['user_id'].toString() == userId)
            .map((json) => StudentRecord.fromJson(json))
            .toList();
      }
      throw ApiException('Failed to load data: ${response.statusCode}');
    } catch (e) {
      throw ApiException('Error fetching data: $e');
    }
  }

  Future<void> submitStudentData({
    required String userId,
    required String courseName,
    required String creditHours,
    required String marks,
    required String semesterNo,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/grades'),
            body: {
              'user_id': userId,
              'course_name': courseName,
              'credit_hours': creditHours,
              'marks': marks,
              'semester_no': semesterNo,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException('Failed to add data: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error submitting data: $e');
    }
  }
}