import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void mockHttpResponse({
  required http.Client mockClient,
  required String method,
  required Uri url,
  Map<String, String>? headers,
  dynamic body,
  required dynamic response,
  int statusCode = 200,
}) {
  if (method == 'POST') {
    when(mockClient.post(url, headers: headers, body: json.encode(body)))
        .thenAnswer((_) async => http.Response(json.encode(response), statusCode));
  } else if (method == 'GET') {
    when(mockClient.get(url, headers: headers))
        .thenAnswer((_) async => http.Response(json.encode(response), statusCode));
  }
}

Future<Map<String, dynamic>?> getStoredLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'token': prefs.getString('auth_token'),
    'user_id': prefs.getInt('auth_uid')
  };
}
