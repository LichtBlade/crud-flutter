import 'package:assignment3/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/student_bloc.dart';
import 'service/studentapiservice.dart'; // Import your API service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentBloc(
          StudentApiService()), // Provide StudentBloc at the app level
      child: MaterialApp(
        title: 'Student Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StudentListScreen(), // Starting screen is StudentListScreen
      ),
    );
  }
}
