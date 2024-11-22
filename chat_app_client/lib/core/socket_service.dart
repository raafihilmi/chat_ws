import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  IO.Socket? socket;
  bool isInitialized = false;

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
    });

    socket?.onDisconnect((_) {
      print('Disconnected from WebSocket Server');
    });

    socket?.on('v1_get_students', (data) {
      print('v1_get_students: $data');
    });

    socket?.on('v1_get_students_error', (data) {
      print('v1_get_students_error: $data');
    });

    socket?.on('v1_get_students_response', (data) {
      print('v1_get_students_response: $data');
    });

    socket?.on('v1_chat_send_message_response', (data) {
      print('Message sent response: $data');
    });

    socket?.on('v1_get_chat_histories', (data) {
      print('Chat histories received: $data');
    });

    socket?.on('v1_get_chat_histories_error', (data) {
      print('Chat histories error: $data');
    });
    socket?.on('v1_get_chat_histories_response', (data) {
      print('Chat histories response: $data');
    });

    socket?.on('v1_chat_send_message', (data) {
      print('Chat send message: $data');
    });
    socket?.on('v1_chat_send_message_error', (data) {
      print('Chat send message error: $data');
    });
    socket?.on('v1_chat_send_message_response', (data) {
      print('Chat send message response: $data');
    });

    socket?.on('v1_mark_message_as_seen', (data) {
      print('Message marked as seen: $data');
    });
    socket?.on('v1_mark_message_as_seen_error', (data) {
      print('Message marked as seen error: $data');
    });
    socket?.on('v1_mark_message_as_seen_response', (data) {
      print('Message marked as seen response: $data');
    });

    socket?.on('v1_chat_receive_message_response', (data) {
      print('Message receive: $data');
    });

    socket?.onConnectError((error) {
      print('WebSocket connection error: $error');
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

  void offEvent(String event) {
    socket?.off(event);
  }

  // Close the socket connection
  void dispose() {
    socket?.disconnect();
  }

  bool get isSocketReady => socket != null && isInitialized;
}
