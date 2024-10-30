import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_helper_test.dart';
import 'login_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiConsumer apiConsumer;
  const getUserEndpoint = '/users/available';

  setUp(() {
    mockClient = MockClient();
    apiConsumer = ApiConsumer(client: mockClient);
    SharedPreferences.setMockInitialValues({});
  });

  group('GetAvailable API Test', () {
    test('returns success response when get user is successful', () async {
      mockHttpResponse(
          mockClient: mockClient,
          method: 'POST',
          url: Uri.parse('${apiConsumer.baseUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: {'username': 'admin', 'password': 'admin'},
          response: {'token': 'mock_token', 'user_id': 1});
      final login = await apiConsumer.login('admin', 'admin');
      final storedData = await getStoredLoginData();
      final token = storedData?['token'];
      final expectedResponse = [
        {
          "ID": 34,
          "CreatedAt": "2024-10-18T16:52:18.621638+07:00",
          "UpdatedAt": "2024-10-18T16:52:18.621638+07:00",
          "DeletedAt": null,
          "username": "tesajaha",
          "email": "tahanaj@gaml.cim"
        },
        {
          "ID": 35,
          "CreatedAt": "2024-10-21T13:17:50.564699+07:00",
          "UpdatedAt": "2024-10-21T13:17:50.564699+07:00",
          "DeletedAt": null,
          "username": "gagajah",
          "email": "gagajah@gmail.com"
        },
      ];
      final expectedUrl = '${apiConsumer.baseUrl}$getUserEndpoint';

      mockHttpResponse(
          mockClient: mockClient,
          method: 'GET',
          url: Uri.parse(expectedUrl),
          headers: {'Authorization': 'Bearer $token'},
          response: expectedResponse);
      final result = await apiConsumer.getAvailableUsers();
      final resultAsMap = result.map((user) => user.toJson()).toList();

      expect(resultAsMap.length, equals(expectedResponse.length));
      expect(login['token'], token);
    });

    test('handles empty users list', () async {
      mockHttpResponse(mockClient: mockClient,
          method: 'POST',
          url: Uri.parse('${apiConsumer.baseUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: {'username': 'admin', 'password': 'admin'},
          response: {'token': 'mock_token', 'user_id': 1});
      await apiConsumer.login('admin', 'admin');
      final storedData = await getStoredLoginData();
      final token = storedData?['token'];
      final expectedUrl = '${apiConsumer.baseUrl}$getUserEndpoint';

      when(mockClient.get(
        Uri.parse(expectedUrl),
        headers: {'Authorization': 'Bearer $token'},
      )).thenAnswer((_) async => http.Response('[]', 200));
      final users = await apiConsumer.getAvailableUsers();

      // Assert
      expect(users, isEmpty);
    });
  });
}
