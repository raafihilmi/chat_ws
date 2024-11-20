import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class SocketService {
  IO.Socket? socket;

  void initSocket(String token) {
    print('Initializing WebSocket with token: $token');
    socket = IO.io(
      dotenv.env['WS_BASE_URL'] ?? '',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': token})
          .build(),
    );

    socket?.onConnect((_) {
      print('Connected to WebSocket Server');
      socket?.emit('v1_get_students', {'search': "sandi"});

    });

    socket?.onDisconnect((_) {
      print('Disconnected from WebSocket Server');
    });

    socket?.on('v1_chat_send_message_response', (data) {
      print('Message sent response: $data');
    });

    socket?.on('v1_get_chat_histories_response', (data) {
      print('Chat histories received: $data');
    });

    socket?.on('v1_mark_message_as_seen_response', (data) {
      print('Message marked as seen: $data');
    });

    socket?.onError((error) {
      print('WebSocket Error: $error');
    });

    socket?.connect();
  }

  // Emit event
  void sendMessage(String receiverId, String message) {
    socket?.emit('v1_chat_send_message', {
      'receiver_id': receiverId,
      'message': message,
    });
  }

  void getChatHistories(String search) {
    socket?.emit('v1_get_chat_histories', {'search': search});
  }

  void markMessageAsSeen(String messageId) {
    socket?.emit('v1_mark_message_as_seen', {'message_id': messageId});
  }

  // Listen to events
  void onEvent(String event, Function(dynamic data) callback) {
    socket?.on(event, callback);
  }

  // Close the socket connection
  void dispose() {
    socket?.disconnect();
  }
}
