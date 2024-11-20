import 'package:chat_app_client/features/chat/domain/entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents(String search);
}