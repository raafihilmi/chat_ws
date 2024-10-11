import 'package:chat_app_client/core/api/api_consumer.dart';
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
  final ApiConsumer apiConsumer;
  final ChatWebsocketService _websocketService;

  ChatRemoteDataSourceImpl(this.apiConsumer, this._websocketService);

  @override
  Future<List<MessageModel>> getChatHistory(int userId) async{
    final response = await apiConsumer.getChatHistory(userId);
    return response.map((data) => MessageModel.fromJson(data)).toList();
  }

  @override
  Future<MessageModel> sendMessage(int receiverId, String message) async {
    final response = await apiConsumer.sendMessage(receiverId, message);
    return MessageModel.fromJson(response);
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
