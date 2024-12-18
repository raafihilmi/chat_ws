import 'package:bloc/bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:chat_app_client/features/chat/domain/entities/student.dart';
import 'package:chat_app_client/features/chat/domain/repositories/student_repository.dart';
import 'package:equatable/equatable.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _repository;

  StudentBloc(this._repository) : super(StudentInitial()) {
    on<GetStudentsEvent>(_onGetStudents);
    on<SearchStudentsEvent>(_onSearchStudents);
    print('Current state: $state');
  }

  Future<void> _onGetStudents(
    GetStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    try {
      emit(StudentLoading());
      print('Fetching students with search term: ${event.search}');
      final students = await _repository.getStudents(event.search);
      print('Students found: $students');
      emit(StudentLoaded(students));
    } catch (e) {
      print('Error searching students: $e');
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onSearchStudents(
    SearchStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    try {
      emit(StudentLoading());
      final students = await _repository.getStudents(event.search);
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }
}
