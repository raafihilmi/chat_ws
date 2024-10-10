import 'package:chat_app_client/features/chat/data/datasources/chat_websocket_service.dart';
import 'package:chat_app_client/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<MessageModel> get messageStream;

  Future<List<MessageModel>> getChatHistory(int userId);

  Future<MessageModel> sendMessage(int receiverId, String message);

  void connect();

  void disconnect();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatWebsocketService _websocketService;

  ChatRemoteDataSourceImpl(this._websocketService);

  @override
  Future<List<MessageModel>> getChatHistory(int userId) {
    // nanti pas set API
    throw UnimplementedError();
  }

  @override
  Future<MessageModel> sendMessage(int receiverId, String message) async {
    final newMessage = MessageModel(
      senderId: 1,
      receiverId: receiverId,
      message: message,
      isRead: false,
      createdAt: DateTime.now(),
    );
    _websocketService.sendMessage(newMessage);
    return newMessage;
  }

  @override
  void connect() {
    _websocketService.connect();
  }

  @override
  void disconnect() {
    _websocketService.disconnect();
  }

  @override
  Stream<MessageModel> get messageStream => _websocketService.messageStream;
}
