import 'dart:async';

import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:chat_app_client/core/socket_service.dart';
import 'package:chat_app_client/features/chat/data/models/conversation.dart';
import 'package:chat_app_client/features/chat/domain/entities/student.dart';
import 'package:chat_app_client/features/chat/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final SocketService _socketService;
  final ApiConsumer apiConsumer;
  final _conversationsController =
      StreamController<List<Conversation>>.broadcast();
  List<Conversation> _currentConversations = [];

  StudentRepositoryImpl(this._socketService, this.apiConsumer) {
    _initializeConversationListener();
  }

  void _initializeConversationListener() {
    _socketService.onEvent('v1_update_conversation_response', (data) {
      final updatedConversation = Conversation.fromJson(data['data']);

      final conversationIndex = _currentConversations
          .indexWhere((conv) => conv.id == updatedConversation.id);

      if (conversationIndex != -1) {
        _currentConversations[conversationIndex] = updatedConversation;
      } else {
        _currentConversations.insert(0, updatedConversation);
      }

      _conversationsController.add(_currentConversations);
    });
  }

  Future<void> _reinitializeSocket() async {
    final token = await apiConsumer.getToken();
    _socketService.initSocket(token!);
  }

  @override
  Future<List<Student>> getStudents(String search) async {
    if (!_socketService.isSocketReady) {
      await _reinitializeSocket();
    }
    if (_socketService.socket == null) {
      throw Exception('Socket is not initialized bos');
    }
    final completer = Completer<List<Student>>();

    _socketService.socket?.emit('v1_get_students', {'search': search});

    _socketService.onEvent('v1_get_students_response', (data) {
      print("Data received: $data");

      final studentsData = data['data']['students'] as List;
      final students =
          studentsData.map((student) => Student.fromJson(student)).toList();

      completer.complete(students);
    });

    _socketService.onEvent('v1_get_students_error', (error) {
      completer.completeError("Error fetching students: $error");
    });

    return completer.future;
  }

  @override
  Stream<List<Conversation>> getConversationStream() {
    return _conversationsController.stream;
  }

  @override
  Future<List<Conversation>> getConversation() async {
    if (!_socketService.isSocketReady) {
      await _reinitializeSocket();
    }
    if (_socketService.socket == null) {
      throw Exception('Socket is not initialized bos');
    }
    final completer = Completer<List<Conversation>>();

    _socketService.socket?.emit('v1_get_conversations', {});

    _socketService.onEvent('v1_get_conversations_response', (data) {
      print("Data received: $data");

      final studentsData = data['data']['conversations'] as List;
      _currentConversations = studentsData
          .map((student) => Conversation.fromJson(student))
          .toList();

      _conversationsController.add(_currentConversations);

      completer.complete(_currentConversations);
    });

    _socketService.onEvent('v1_get_conversations_error', (error) {
      completer.completeError("Error fetching students: $error");
    });

    return completer.future;
  }

  @override
  void dispose() {
    _conversationsController.close();
  }
}
