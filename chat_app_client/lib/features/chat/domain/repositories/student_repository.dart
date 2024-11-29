import 'package:chat_app_client/features/chat/data/models/conversation.dart';
import 'package:chat_app_client/features/chat/domain/entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents(String search);
  Future<List<Conversation>> getConversation();
  Stream<List<Conversation>> getConversationStream();
  void dispose();
}