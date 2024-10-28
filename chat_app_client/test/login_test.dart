import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_helper_test.dart';
@GenerateMocks([http.Client])
import 'login_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiConsumer apiConsumer;
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

    test('Successful login stores token and user_id in preferences', () async {
      mockHttpResponse(mockClient, loginEndpoint, expectedResponse, 200);

      final result = await apiConsumer.login(username, password);

      expect(result['token'], startsWith(refreshedTokenPrefix));
      expect(result['user_id'], 26);

      final storedData = await getStoredLoginData();
      expect(storedData?['token'], startsWith(refreshedTokenPrefix));
      expect(storedData?['user_id'], 26);
    });

    test('Handles token refresh scenario', () async {
      mockHttpResponse(mockClient, loginEndpoint, expectedResponse, 200);
      await apiConsumer.login(username, password);

      final newTokenResponse = {'token': refreshedTokenPrefix, 'user_id': 26};
      mockHttpResponse(mockClient, loginEndpoint, newTokenResponse, 200);
      await apiConsumer.login(username, password);

      final storedData = await getStoredLoginData();
      expect(storedData?['token'], startsWith(refreshedTokenPrefix));
    });

    test('Throws exception when login fails with 401', () async {
      final errorResponse = {'error': 'Invalid password'};
      mockHttpResponse(mockClient, loginEndpoint, errorResponse, 401);

      expect(() => apiConsumer.login(username, 'wrong_password'), throwsException);

      final storedData = await getStoredLoginData();
      expect(storedData?['token'], isNull);
      expect(storedData?['user_id'], isNull);
    });
  });
}