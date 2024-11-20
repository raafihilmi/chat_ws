import 'dart:async';

import 'package:chat_app_client/core/socket_service.dart';
import 'package:chat_app_client/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SocketService _socketService;
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  List<ChatMessage> _messages = [];


  ChatRepositoryImpl(this._socketService) {
    _setupMessageListener();
  }

  void _setupMessageListener() {
    _socketService.onEvent('v1_chat_send_message_response', (data) {
      final message = _convertToMessage(data['data']);
      _messages.add(message);
      _messagesController.add(List.from(_messages));
    });
  }

  ChatMessage _convertToMessage(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'],
      fullName: data['full_name'],
      avatar: data['avatar'],
      messageId: data['message_id'],
      message: data['message'],
      messageTimestamp: DateTime.parse(data['message_timestamp']),
      isMessageSeen: data['is_message_seen'],
      isMessageFromCurrentUser: data['is_message_from_current_user'],
    );
  }

  // Stream<List<ChatMessage>> get messages => _messagesController.stream;

  @override
  Stream<List<ChatMessage>> getChatMessages(String receiverId) {
    _socketService.socket?.emit('v1_get_chat_histories');
    return _messagesController.stream;
  }

  @override
  Future<void> sendMessage(String receiverId, String message) async {
    _socketService.socket?.emit('v1_chat_send_message', {
      'receiver_id': receiverId,
      'message': message,
    });
  }

  @override
  Future<void> markMessageAsSeen(String messageId) async {
    _socketService.socket?.emit('v1_mark_message_as_seen', {
      'message_id': messageId,
    });
  }

  @override
  Future<void> setTypingStatus(String receiverId, bool isTyping) async {
    _socketService.socket?.emit('v1_typing_status', {
      'receiver_id': receiverId,
      'is_typing': isTyping,
    });
  }
}
