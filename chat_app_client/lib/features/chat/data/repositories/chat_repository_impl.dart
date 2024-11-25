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
    _socketService.offEvent('v1_chat_send_message_response');
    _socketService.offEvent('v1_chat_receive_message_response');

    _socketService.onEvent('v1_chat_send_message_response', (data) {
      final message = _convertToMessage(data['data']);
      if (!_messages.any((msg) => msg.messageId == message.messageId)) {
        _messages.add(message);
        _messagesController.add(List.from(_messages));
      }
    });

    _socketService.onEvent('v1_chat_receive_message_response', (data) {
      if (data['code'] == 200) {
        final message = _convertToMessage(data['data']);
        if (!_messages.any((msg) => msg.messageId == message.messageId)) {
          _messages.add(message);
          _messagesController.add(List.from(_messages));
        }
      } else {
        print("Error menerima pesan: ${data['message']}");
      }
    });
  }

  ChatMessage _convertToMessage(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'],
      fullName: data['full_name'],
      avatar: data['avatar'],
      status: data['status'],
      messageId: data['message_id'],
      message: data['message'],
      messageTimestamp: DateTime.parse(data['message_timestamp']),
      isMessageSeen: data['is_message_seen'],
      isMessageFromCurrentUser: data['is_message_from_current_user'],
    );
  }

  Stream<List<ChatMessage>> get messages => _messagesController.stream;

  @override
  Stream<List<ChatMessage>> getChatMessages(String receiverId) {
    _socketService.offEvent('v1_get_chat_histories_response');
    _socketService.socket
        ?.emit('v1_get_chat_histories', {'receiver_id': receiverId});

    _socketService.onEvent('v1_get_chat_histories_response', (data) {
      print("Response diterima di WebSocket: $data");
      if (data['code'] == 200) {
        final messagesData = data['data']['messages'] as List;
        final chatMessages =
            messagesData.map((msg) => ChatMessage.fromJson(msg)).toList();
        print("Messages parsed: $chatMessages");
        chatMessages
            .sort((a, b) => a.messageTimestamp.compareTo(b.messageTimestamp));

        _messages = chatMessages;
        _messagesController.add(List.from(_messages));
      } else {
        print("Error dari response: ${data['message']}");
        _messagesController.addError('Failed to load chat histories');
      }
    });

    _socketService.onEvent('v1_get_chat_histories_error', (error) {
      _messagesController.addError(error.toString());
    });

    return _messagesController.stream;
  }

  @override
  Future<void> sendMessage(String receiverId, String message) async {
    _socketService.socket?.emit('v1_chat_send_message', {
      'receiver_id': receiverId,
      'message': message,
    });

    _socketService.onEvent('v1_chat_send_message_error', (error) {
      _messagesController.addError(error);
    });
  }

  @override
  Future<void> markMessageAsSeen(String messageId) async {
    _socketService.socket?.emit('v1_mark_message_as_seen', {
      'receiver_id': messageId,
    });

    _socketService.onEvent('v1_mark_message_as_seen_response', (data) {
      if (data['code'] == 200) {
        print(data['message']);
      } else {
        print("Gagal memperbarui status pesan: ${data['message']}");
      }
    });
  }

  @override
  Future<void> setTypingStatus(String receiverId, bool isTyping) async {
    _socketService.socket?.emit('v1_typing_status', {
      'receiver_id': receiverId,
      'is_typing': isTyping,
    });
  }

  void dispose() {
    _socketService.offEvent('v1_chat_send_message_response');
    _socketService.offEvent('v1_get_chat_histories_response');
    _socketService.offEvent('v1_chat_receive_message_response');
    _messagesController.close();
  }
}
