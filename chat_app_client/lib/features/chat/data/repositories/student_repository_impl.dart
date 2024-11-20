import 'dart:async';
import 'dart:developer';

import 'package:chat_app_client/core/socket_service.dart';
import 'package:chat_app_client/features/chat/domain/entities/student.dart';
import 'package:chat_app_client/features/chat/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final SocketService _socketService;

  StudentRepositoryImpl(this._socketService);

  @override
  Future<List<Student>> getStudents(String search) async {
    log("GETSTUDENT BOSKU", name: "GETSTUDENT");
    final completer = Completer<List<Student>>();

    _socketService.onEvent('v1_get_students', (data) {
      log("GETSTUDENT data BOSKU", name: "GETSTUDENT");
      completer.completeError("data fetching students: $data");
    });
    // Listen for the response event
    _socketService.onEvent('v1_get_students_response', (data) {
      log("GETSTUDENT RESPON BOSKU", name: "GETSTUDENT");
      log("Data received: $data", name: "GETSTUDENT");

      final studentsData = data['data']['students'] as List;
      final students = studentsData.map((student) => Student(
        id: student['id'],
        fullName: student['full_name'],
        avatar: student['avatar'],
        joinSince: student['join_since'],
        subjects: (student['subjects'] as List).map((subject) => Subject(
          id: subject['id'],
          name: subject['name'],
          isClassmate: subject['is_classmate'],
        )).toList(),
      )).toList();

      completer.complete(students);
    });

    // Listen for the error event (if there is an error in retrieving the data)
    _socketService.onEvent('v1_get_students_error', (error) {
      log("GETSTUDENT ERROR BOSKU", name: "GETSTUDENT");
      completer.completeError("Error fetching students: $error");
    });

    // Emit the request for students based on the search term
    _socketService.socket?.emit('v1_get_students', {'search': search});

    return completer.future;
  }
}
