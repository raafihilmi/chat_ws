import 'dart:convert';

import 'package:chat_app_client/core/api/api_consumer.dart';

import '../../domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Stream<Message> connectToChat(int currentUserId, int otherUserId);

  Future<void> sendMessage(Message message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer apiConsumer;

  ChatRemoteDataSourceImpl(this.apiConsumer);

  @override
  Stream<Message> connectToChat(int currentUserId, int otherUserId) {
    return apiConsumer.connectWebSocket().asStream().asyncExpand((wsChannel) {
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
    final wsChannel = await apiConsumer.connectWebSocket();
    wsChannel.sink.add(json.encode({
      'sender_id': message.senderId,
      'receiver_id': message.receiverId,
      'message': message.message,
      'is_read': message.isRead,
    }));
  }
}
