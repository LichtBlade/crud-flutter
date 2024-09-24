import 'dart:convert';
import 'package:assignment3/models/students.dart';
import 'package:http/http.dart' as http;

class StudentApiService {
  final String baseUrl = "http://10.0.2.2/crud"; // Adjust if needed

  Future<List<Student>> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read.php'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((student) => Student.fromJson(student))
            .toList();
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(student.toJson()),
      );

      // Print status code and response body for debugging
      print('Create Response status: ${response.statusCode}');
      print('Create Response body: ${response.body}');

      // Decode and process the response body
      final responseBody = json.decode(response.body);

      if (responseBody != null && responseBody is Map<String, dynamic>) {
        final message = responseBody['message'] as String?;
        if (message != null) {
          print('Success message: $message');
          // Optionally handle success or process the response
          if (message == 'Student added successfully') {
            // Handle successful creation
          } else {
            throw Exception('Unexpected response message: $message');
          }
        } else {
          throw Exception('Message field is null');
        }
      } else {
        throw Exception('Response body is not in the expected format');
      }
    } catch (e) {
      // Print and rethrow the error for debugging
      print('Create Error: $e');
      rethrow;
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update student');
      }
    } catch (e) {
      print('Update Error: $e');
      rethrow;
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': id.toString()}), // Convert id to String
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      print('Delete Error: $e');
      rethrow;
    }
  }
}
