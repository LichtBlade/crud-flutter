import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment3/bloc/student_bloc.dart';
import 'package:assignment3/bloc/student_event.dart';
import 'package:assignment3/models/students.dart';

class StudentForm extends StatefulWidget {
  final Student? student; // Optional student object for update

  const StudentForm({Key? key, this.student}) : super(key: key); // Constructor

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _course;
  String? _year;
  bool _enrolled = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate form fields if we're updating an existing student
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _course = widget.student!.course;
      _year = widget.student!.year;
      _enrolled = widget.student!.enrolled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null; // Check if it's an update

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Update Student' : 'Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a first name'
                    : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a last name'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _course,
                hint: const Text('Select Course'),
                items: [
                  'First Year',
                  'Second Year',
                  'Third Year',
                  'Fourth Year',
                  'Fifth Year'
                ]
                    .map((course) =>
                        DropdownMenuItem(value: course, child: Text(course)))
                    .toList(),
                onChanged: (value) => setState(() => _course = value),
                validator: (value) =>
                    value == null ? 'Please select a course' : null,
              ),
              DropdownButtonFormField<String>(
                value: _year,
                hint: const Text('Select Year'),
                items: ['2024', '2025', '2026', '2027']
                    .map((year) =>
                        DropdownMenuItem(value: year, child: Text(year)))
                    .toList(),
                onChanged: (value) => setState(() => _year = value),
                validator: (value) =>
                    value == null ? 'Please select a year' : null,
              ),
              SwitchListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (value) => setState(() => _enrolled = value),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final student = Student(
                      id: widget.student?.id, // Use existing ID for update
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      course: _course!,
                      year: _year!,
                      enrolled: _enrolled,
                    );

                    if (isEditing) {
                      // Update existing student
                      context.read<StudentBloc>().add(UpdateStudent(student));
                    } else {
                      // Add new student
                      context.read<StudentBloc>().add(AddStudent(student));
                    }

                    Navigator.pop(context); // Navigate back
                  }
                },
                child: Text(isEditing ? 'Update' : 'Submit'), // Dynamic text
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
