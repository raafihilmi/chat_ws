import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';


void mockHttpResponse(http.Client client, String endpoint, dynamic response, int statusCode, {Map<String, String>? body}){
  const baseUrl = 'http://192.168.20.76:8080/api';
  when(client.post(
    Uri.parse('$baseUrl/$endpoint'),
    headers: {'ContentType': 'application/json'},
    body: json.encode(body),
  )).thenAnswer((_) async => http.Response(json.encode(response), statusCode));
}

Future <Map<String, dynamic>?> getStoredLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'token': prefs.getString('auth_token'),
    'user_id': prefs.getInt('auth_uid')
  };
}