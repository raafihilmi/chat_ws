import 'package:chat_app_client/features/chat/data/models/conversation.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



class ChatService {
  IO.Socket? socket;
  final String baseUrl = 'https://api.kampusgratis.id/io';

  void connect(String token) {
    socket = IO.io('$baseUrl/inbox', {
      'transports': ['websocket'],
      'auth': {'token': token},
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
    });

    socket?.onConnect((_) {
      print('Connected to chat server');
    });

    socket?.onDisconnect((_) {
      print('Disconnected from chat server');
    });

    socket?.onError((error) {
      print('Socket error: $error');
    });
  }

  void disconnect() {
    socket?.disconnect();
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }

  void getConversationList() {
    socket?.emit('getConversationList');
  }

  void listenToConversationList(Function(List<Conversation>) onData) {
    socket?.on('chatConversationList', (data) {
      if (data['code'] == 200) {
        final List<Conversation> conversations = (data['data'] as List)
            .map((item) => Conversation.fromJson(item))
            .toList();
        onData(conversations);
      }
    });
  }

  Future<List<Message>> getChatHistory(String receiverId, {String? oldestMessageDate, int limit = 20}) {
    return Future(() {
      socket?.emit('getChatHistories', {
        'receiver_id': receiverId,
        'oldest_message_date': oldestMessageDate,
        'limit': limit
      });

      return Future.delayed(const Duration(seconds: 5));
    });
  }

  void listenToChatHistory(Function(List<Message>) onData) {
    socket?.on('chatHistory', (data) {
      if (data['code'] == 200) {
        final List<Message> messages = (data['data'] as List)
            .map((item) => Message.fromJson(item))
            .toList();
        onData(messages);
      }
    });
  }

  void sendMessage(String receiverId, String content) {
    socket?.emit('chatSendMessage', {
      'receiver_id': receiverId,
      'content': content
    });
  }

  void listenToNewMessages(Function(Message) onData) {
    socket?.on('receiveMessage', (data) {
      if (data['code'] == 200) {
        final message = Message.fromJson(data['data']);
        onData(message);
      }
    });
  }
}
