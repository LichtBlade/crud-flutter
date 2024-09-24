import 'package:assignment3/studentform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment3/bloc/student_bloc.dart';
import 'package:assignment3/bloc/student_event.dart';
import 'package:assignment3/bloc/student_state.dart';

class StudentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch students
    context.read<StudentBloc>().add(FetchStudents());

    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: StudentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentForm(),
            ),
          ).then((_) {
            // Refresh the student list when returning from the form
            context.read<StudentBloc>().add(FetchStudents());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is StudentLoaded) {
          return ListView.builder(
            itemCount: state.students.length,
            itemBuilder: (context, index) {
              final student = state.students[index];
              return ListTile(
                title: Text('${student.firstName} ${student.lastName}'),
                subtitle: Text('${student.course}, Year: ${student.year}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentForm(student: student),
                          ),
                        ).then((_) {
                          // Refresh the student list when returning from the form
                          context.read<StudentBloc>().add(FetchStudents());
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<StudentBloc>()
                            .add(DeleteStudent(student.id!));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is StudentError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('No students found.'));
        }
      },
    );
  }
}
