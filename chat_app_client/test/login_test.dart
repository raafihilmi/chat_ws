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
    "code": 200,
    "status": "OK",
    "message": "Login Success",
    "data": {
      "user_id": "2315dc50-7bb8-42d5-9215-61d946376701",
      "refresh_token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMjMxNWRjNTAtN2JiOC00MmQ1LTkyMTUtNjFkOTQ2Mzc2NzAxIiwic2Vzc2lvbl9pZCI6ImE0ZTljZjE0LWEwNTUtNDg3MC1iZDI2LTk2Njg5OGE0N2ZiNyIsImlhdCI6MTczMzg5MTg2NywiZXhwIjoxNzM0NDk2NjY3fQ.RwbGQMJEHrmLx3fOTuAnkNUnyZ7Rcvp0DO_51vVHVeM",
      "access_token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMjMxNWRjNTAtN2JiOC00MmQ1LTkyMTUtNjFkOTQ2Mzc2NzAxIiwic2Vzc2lvbl9pZCI6ImE0ZTljZjE0LWEwNTUtNDg3MC1iZDI2LTk2Njg5OGE0N2ZiNyIsImlhdCI6MTczMzg5MTg2NywiZXhwIjoxNzM0NDk2NjY3fQ.80KeeA5q16-vlthP9R6yBqLc04oR29UJKvycuM9VOjc"
    }
  };

  setUp(() {
    mockClient = MockClient();
    apiConsumer = ApiConsumer(client: mockClient);
    SharedPreferences.setMockInitialValues({});
  });

  group('Login API Test', () {
    test(
        'Successful login stores access_token, refresh_token, and user_id in preferences',
        () async {
      mockHttpResponse(
        mockClient: mockClient,
        method: 'POST',
        url: Uri.parse('${apiConsumer.baseUrl}$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: {'username': username, 'password': password},
        response: expectedResponse,
      );

      final result =
          await apiConsumer.login(username, password);

      final data = result['data'] as Map<String, dynamic>;
      expect(data['access_token'], startsWith(refreshedTokenPrefix));
      expect(data['user_id'], "2315dc50-7bb8-42d5-9215-61d946376701");

      final storedData = await getStoredLoginData();
      expect(storedData?['access_token'], startsWith(refreshedTokenPrefix));
      expect(storedData?['refresh_token'],
          (expectedResponse['data'] as Map<String, dynamic>)['refresh_token']);
      expect(storedData?['user_id'], "2315dc50-7bb8-42d5-9215-61d946376701");
    });

    test('Handles token refresh scenario', () async {
      mockHttpResponse(
        mockClient: mockClient,
        method: 'POST',
        url: Uri.parse('${apiConsumer.baseUrl}$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: {'username': username, 'password': password},
        response: {
          "code": 200,
          "status": "OK",
          "message": "Login Success",
          "data": {
            "user_id": "1",
            "refresh_token": "mock_refresh_token",
            "access_token": "mock_access_token"
          }
        },
      );

      await apiConsumer.login(username, password);

      mockHttpResponse(
        mockClient: mockClient,
        method: 'POST',
        url: Uri.parse('${apiConsumer.baseUrl}$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: {'username': username, 'password': password},
        response: expectedResponse,
      );

      final refreshedResult =
          await apiConsumer.login(username, password);
      final refreshedData = refreshedResult['data'] as Map<String, dynamic>;

      expect(refreshedData['access_token'], startsWith(refreshedTokenPrefix));

      final storedData = await getStoredLoginData();
      expect(storedData?['access_token'], startsWith(refreshedTokenPrefix));
      expect(storedData?['refresh_token'],
          (expectedResponse['data'] as Map<String, dynamic>)['refresh_token']);
    });

    test('Throws exception when login fails with 401', () async {
      final errorResponse = {'error': 'Invalid password'};
      mockHttpResponse(
        mockClient: mockClient,
        method: 'POST',
        url: Uri.parse('${apiConsumer.baseUrl}$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: {'username': username, 'password': 'wrong_password'},
        response: errorResponse,
        statusCode: 401,
      );

      expect(
          () => apiConsumer.login(username, 'wrong_password'), throwsException);

      final storedData = await getStoredLoginData();
      expect(storedData?['access_token'], isNull);
      expect(storedData?['refresh_token'], isNull);
      expect(storedData?['user_id'], isNull);
    });
  });
}
