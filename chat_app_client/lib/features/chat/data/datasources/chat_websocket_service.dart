import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_client/features/chat/data/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebsocketService {
  WebSocketChannel? _channel;
  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get messageStream => _messageController.stream;

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final uri = Uri.parse('ws://localhost:8080/ws');
    _channel = IOWebSocketChannel.connect(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    _channel!.stream.listen((data) {
      final jsonData = json.decode(data);
      final message = MessageModel.fromJson(jsonData);
      _messageController.add(message);
    }, onError: (e) {
      log(e, name: "WebSocket Error: ");
    }, onDone: () {
      log('WebSocket connection closed');
    });
  }

  void sendMessage(MessageModel message) {
    if (_channel != null) {
      final jsonMessage = json.encode(message.toJson());
      _channel!.sink.add(jsonMessage);
    } else {
      log('WebSocket is not connected');
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _messageController.close();
  }
}
