import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../../features/chat/data/models/user_models.dart';

class ApiConsumer {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String wsUrl = dotenv.env['WS_BASE_URL'] ?? '';
  final http.Client client;

  ApiConsumer({required this.client});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('auth_uid');
  }

  Future<void> _saveUserId(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_uid', uid);
  }

  Future<void> _saveFCMTokenToServer(
      int userId, String fcmToken, String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/save_token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'user_id': userId, 'fcm_token': fcmToken}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save FCM token');
    }
  }

  Future<Map<String, dynamic>> login(String email, password) async {
    await Firebase.initializeApp();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final response = await client.post(Uri.parse('$baseUrl/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'email': email, 'password': password, 'role': 'STUDENT'}));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null) {
        final accessToken = data['data']['access_token'];
        final userId = data['data']['user_id'];

        if (accessToken != null && userId != null) {
          await _saveToken(accessToken);
          await _saveUserId(userId);
          return data;
        }
      }
      throw Exception('Data response tidak valid');
    }
    throw Exception('Failed to login');
  }

  Future<Map<String, dynamic>> register(
      String username, password, email) async {
    final response = await http.post(Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'username': username, 'password': password, 'email': email}));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<List<UserModel>> getAvailableUsers() async {
    final token = await _getToken();
    log(token ?? 'Gak ada token', name: "getAvailableUsers");
    final response = await client.get(
      Uri.parse('$baseUrl/users/available'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.isEmpty
          ? []
          : jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users list');
    }
  }

  Future<List<UserModel>> getBlockedUsers() async {
    final token = await _getToken();
    log(token ?? 'Gak ada token', name: "getBlockedUsers");
    final response = await http.get(
      Uri.parse('$baseUrl/block'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users list');
    }
  }

  Future<List<Map<String, dynamic>>> getChatHistory(int userId) async {
    final token = await _getToken();
    log(token!, name: "ChatAPI");
    final response = await http.get(Uri.parse('$baseUrl/chats/$userId'),
        headers: {'Authorization': 'Bearer $token'});

    log(response as String, name: "ChatHist");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get chat history');
    }
  }

  Future<Map<String, dynamic>> sendMessage(
      int receiverId, String message) async {
    final token = await _getToken();
    final response = await http.post(Uri.parse('$baseUrl/chats'),
        headers: {'Authorization': 'Bearer $token'},
        body: json.encode({
          'receiver_id': receiverId,
          'message': message,
        }));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<void> blockUser(int blockedUserId) async {
    final token = await _getToken();
    final response = await http.post(Uri.parse('$baseUrl/block/$blockedUserId'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to BlockUser');
    }
  }

  Future<void> reportUser(String reason, int reportedUserId) async {
    final token = await _getToken();
    final response = await http.post(
        Uri.parse('$baseUrl/report/user/$reportedUserId'),
        headers: {'Authorization': 'Bearer $token'},
        body: json.encode({'reason': reason}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to report user');
    }
  }

  Future<IOWebSocketChannel> connectWebSocket() async {
    final token = await _getToken();

    return IOWebSocketChannel.connect(
      Uri.parse(wsUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
