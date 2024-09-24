import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final int? id; // Make id nullable
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    this.id, // id is optional now
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] != null
          ? int.tryParse(json['id'].toString())
          : null, // Handle nullable id
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      course: json['course'] as String,
      year: json['year'] as String,
      enrolled: json['enrolled'] == '1', // Convert from String to bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toString(), // Convert from int to String, or null
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'year': year,
      'enrolled': enrolled ? '1' : '0', // Convert from bool to String
    };
  }

  @override
  List<Object?> get props => [id, firstName, lastName, course, year, enrolled];
}
