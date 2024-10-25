import 'dart:convert';
import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([http.Client])
import 'login_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiConsumer apiConsumer;
  const baseUrl = 'http://192.168.20.76:8080/api';
  const loginEndpoint = '/auth/login';
  const username = 'admin';
  const password = 'admin';
  const refreshedTokenPrefix = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

  final expectedResponse = {
    'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mjk5MjI5MjgsInVzZXJfaWQiOjI3fQ.oeX1GLsFdoI8vVKoWiVK4LMtJVbW70b1KxiifyqP5pc',
    'user_id': 26,
  };

  setUp(() {
    mockClient = MockClient();
    apiConsumer = ApiConsumer();
    SharedPreferences.setMockInitialValues({});
  });

  group('Login API Test', () {
    void mockHttpResponse(Map<String, dynamic> response, int statusCode) {
      when(mockClient.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      )).thenAnswer((_) async => http.Response(json.encode(response), statusCode));
    }


    Future<Map<String, dynamic>?> getStoredLoginData() async {
      final prefs = await SharedPreferences.getInstance();
      return {
        'token': prefs.getString('auth_token'),
        'user_id': prefs.getInt('auth_uid'),
      };
    }

    test('Successful login stores token and user_id in preferences', () async {
      mockHttpResponse(expectedResponse, 200);

      final result = await apiConsumer.login(username, password);

      expect(result['token'], startsWith(refreshedTokenPrefix));
      expect(result['user_id'], 26);

      final storedData = await getStoredLoginData();
      expect(storedData?['token'], startsWith(refreshedTokenPrefix));
      expect(storedData?['user_id'], 26);
    });

    test('Handles token refresh scenario', () async {
      mockHttpResponse(expectedResponse, 200);
      await apiConsumer.login(username, password);

      final newTokenResponse = {'token': refreshedTokenPrefix, 'user_id': 26};
      mockHttpResponse(newTokenResponse, 200);
      await apiConsumer.login(username, password);

      final storedData = await getStoredLoginData();
      expect(storedData?['token'], startsWith(refreshedTokenPrefix));
    });

    test('Throws exception when login fails with 401', () async {
      mockHttpResponse({'error': 'Invalid password'}, 401);

      expect(() => apiConsumer.login(username, 'wrong_password'), throwsException);

      final storedData = await getStoredLoginData();
      expect(storedData?['token'], isNull);
      expect(storedData?['user_id'], isNull);
    });
  });
}
