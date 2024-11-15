import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Stream<Message> connectToChat(int currentUserId, int otherUserId);

  Future<void> sendMessage(Message message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer apiConsumer;
  WebSocketChannel? _wsChannel;

  ChatRemoteDataSourceImpl(this.apiConsumer);

  @override
  Stream<Message> connectToChat(int currentUserId, int otherUserId) {
    return apiConsumer.connectWebSocket().asStream().asyncExpand((wsChannel) {
      _wsChannel = wsChannel;
      return wsChannel.stream.map((event) {
        final data = json.decode(event);
        return Message(
          senderId: data['sender_id'],
          receiverId: data['receiver_id'],
          message: data['message'],
          isRead: data['is_read'],
        );
      });
    });
  }

  @override
  Future<void> sendMessage(Message message) async {
    if (_wsChannel == null) {
      log('WebSocket not connected. Connecting...', name: 'ChatRemoteDataSource');
      _wsChannel = await apiConsumer.connectWebSocket();
    }
    final messageJson = json.encode({
      'sender_id': message.senderId,
      'receiver_id': message.receiverId,
      'message': message.message,
      'is_read': message.isRead,
    });
    log('Sending message: $messageJson', name: 'ChatRemoteDataSource');
    _wsChannel!.sink.add(messageJson);
  }

  void dispose() {
    _wsChannel?.sink.close();
    _wsChannel = null;
  }
}
