import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../../features/chat/data/models/user_models.dart';

class ApiConsumer {
  final String baseUrl = 'http://192.168.20.76:8080/api';
  final String wsUrl = 'ws://192.168.20.76:8080/ws';

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

  Future<void> _saveUserId(int uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('auth_uid', uid);
  }


  Future<Map<String, dynamic>> login(String username, password) async {
    log('$baseUrl/auth/login', name: "LOGIN API: ");
    final response = await http.post(Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveToken(data['token']);
      await _saveUserId(data['user_id']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
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
    final response = await http.get(
      Uri.parse('$baseUrl/users/available'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.isEmpty ? [] : jsonList.map((json) => UserModel.fromJson(json)).toList();
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

  Future<void> reportUser(String reason,int reportedUserId) async {
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
