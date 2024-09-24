import 'package:assignment3/service/studentapiservice.dart';
import 'package:bloc/bloc.dart';
import 'package:assignment3/bloc/student_event.dart';
import 'package:assignment3/bloc/student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentApiService apiService;

  StudentBloc(this.apiService) : super(StudentInitial()) {
    on<FetchStudents>(_onFetchStudents);
    on<AddStudent>(_onAddStudent);
    on<UpdateStudent>(_onUpdateStudent);
    on<DeleteStudent>(_onDeleteStudent);
  }

  void _onFetchStudents(FetchStudents event, Emitter<StudentState> emit) async {
    try {
      emit(StudentLoading());
      final students = await apiService.fetchStudents();
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError("Failed to fetch students"));
    }
  }

  void _onAddStudent(AddStudent event, Emitter<StudentState> emit) async {
    try {
      await apiService.createStudent(event.student);
      // Optional delay to ensure API updates properly
      await Future.delayed(Duration(milliseconds: 500));
      final students =
          await apiService.fetchStudents(); // Refresh list after adding
      emit(StudentLoaded(students));
    } catch (e) {
      print('Error adding student: $e');
      emit(StudentError("Failed to add student: $e"));
    }
  }

  void _onUpdateStudent(UpdateStudent event, Emitter<StudentState> emit) async {
    try {
      await apiService.updateStudent(event.student);
      final students =
          await apiService.fetchStudents(); // Refresh list after updating
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError("Failed to update student"));
    }
  }

  void _onDeleteStudent(DeleteStudent event, Emitter<StudentState> emit) async {
    try {
      await apiService.deleteStudent(event.id);
      final students =
          await apiService.fetchStudents(); // Refresh list after deleting
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError("Failed to delete student"));
    }
  }
}
