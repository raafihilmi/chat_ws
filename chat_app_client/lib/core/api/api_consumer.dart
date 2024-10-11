import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../features/chat/data/models/user_models.dart';

class ApiConsumer {
  final String baseUrl = 'http://192.168.1.217:8080/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<Map<String, dynamic>> login(String username, password) async {
    log('$baseUrl/auth/login', name: "LOGIN API: ");
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password})
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveToken(data['token']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(String username, password, email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email
      })
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<List<UserModel>> getAvailableUsers() async {
    final token = await _getToken();
    log(token!, name: "getAvailableUsers");
    final response = await http.get(
      Uri.parse('$baseUrl/users/available'),
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
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$userId'),
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    log(response as String, name: "ChatHist");

    if(response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get chat history');
    }
  }

  Future<Map<String, dynamic>> sendMessage(int receiverId, String message) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'receiver_id': receiverId,
        'message': message,
      })
    );

    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }
}