import 'package:build/build.dart';
import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_helper_test.dart';
import 'login_test.mocks.dart';

void main(){
  late MockClient mockClient;
  late ApiConsumer apiConsumer;
  const getUserEndpoint = '/users/available';


  setUp((){
   mockClient = MockClient();
   apiConsumer = ApiConsumer();
   SharedPreferences.setMockInitialValues({});
  });

  group('GetAvailable API Test', () {
    test('returns success response when get user is successful', () async {
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
        {
          "ID": 37,
          "CreatedAt": "2024-10-24T17:07:54.224602+07:00",
          "UpdatedAt": "2024-10-24T17:07:54.224602+07:00",
          "DeletedAt": null,
          "username": "testuser",
          "email": "test@example.com"
        },
        {
          "ID": 45,
          "CreatedAt": "2024-10-24T17:34:10.952493+07:00",
          "UpdatedAt": "2024-10-24T17:34:10.952493+07:00",
          "DeletedAt": null,
          "username": "testuser2",
          "email": "test2@example.com"
        },
        {
          "ID": 49,
          "CreatedAt": "2024-10-24T17:37:01.50272+07:00",
          "UpdatedAt": "2024-10-24T17:37:01.50272+07:00",
          "DeletedAt": null,
          "username": "testuser3",
          "email": "testuser3@gmail.comm"
        },
        {
          "ID": 53,
          "CreatedAt": "2024-10-24T17:39:05.551161+07:00",
          "UpdatedAt": "2024-10-24T17:39:05.551161+07:00",
          "DeletedAt": null,
          "username": "testuser4",
          "email": "testuser4@gmail.comm"
        },
        {
          "ID": 57,
          "CreatedAt": "2024-10-28T13:37:03.001293+07:00",
          "UpdatedAt": "2024-10-28T13:37:03.001293+07:00",
          "DeletedAt": null,
          "username": "testuser5",
          "email": "testuser5@gmail.comm"
        },
        {
          "ID": 59,
          "CreatedAt": "2024-10-28T13:52:46.320385+07:00",
          "UpdatedAt": "2024-10-28T13:52:46.320385+07:00",
          "DeletedAt": null,
          "username": "yakalis",
          "email": "yakalis@example.com"
        }
      ];

      mockHttpResponse(mockClient, getUserEndpoint, expectedResponse, 200);

      final result = await apiConsumer.getAvailableUsers();
      final resultAsMap = result.map((u) => u.toJson()).toList();

      expect(resultAsMap.length, equals(expectedResponse.length));
      expect(login['token'], token);
    });

    test('handles empty users list', () async {
      await apiConsumer.login('admin', 'admin');
      final storedData = await getStoredLoginData();
      final token = storedData?['token'];
      final expectedUrl = '${apiConsumer.baseUrl}/users/available';

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