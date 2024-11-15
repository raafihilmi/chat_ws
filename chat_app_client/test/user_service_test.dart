import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:chat_app_client/features/chat/data/models/user_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api_helper_test.dart';
import 'user_service_test.mocks.dart' as userMocks;

@GenerateMocks([http.Client])
import 'user_service_test.mocks.dart';

void main() {
  late userMocks.MockClient mockClient;
  late ApiConsumer apiConsumer;

  setUp(() {
    mockClient = userMocks.MockClient();
    apiConsumer = ApiConsumer(client: mockClient);
    SharedPreferences.setMockInitialValues({});
  });

  group('getBlockedUsers', () {
    test('returns list of blocked users when the call completes successfully',
        () async {
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
          "ID": 3,
          "CreatedAt": "2024-10-08T12:34:08.620115+07:00",
          "UpdatedAt": "2024-10-08T12:34:08.620115+07:00",
          "DeletedAt": null,
          "username": "namaaja",
          "email": "namaaja@example.com",
        },
        {
          "ID": 16,
          "CreatedAt": "2024-10-09T14:16:25.600859+07:00",
          "UpdatedAt": "2024-10-09T14:16:25.600859+07:00",
          "DeletedAt": null,
          "username": "fikri",
          "email": "fikri@gmail.com",
        },
      ];

      mockHttpResponse(
        mockClient: mockClient,
        method: 'GET',
        url: Uri.parse('${apiConsumer.baseUrl}/block'),
        headers: {'Authorization': 'Bearer $token'},
        response: expectedResponse,
        statusCode: 200,
      );
      final result = await apiConsumer.getBlockedUsers();

      expect(result, isA<List<UserModel>>());
      expect(result.length, expectedResponse.length);
    });

    test('throws exception when the call fails', () async {
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
      expect(token, isNotNull);

      mockHttpResponse(
        mockClient: mockClient,
        method: 'GET',
        url: Uri.parse('${apiConsumer.baseUrl}/block'),
        headers: {'Authorization': 'Bearer $token'},
        response: {'message': 'Failed to load users list'},
        statusCode: 401,
      );

      expect( await apiConsumer.getBlockedUsers(), throwsException);
    });
  });

  group('getChatHistory', () {
    test('returns chat history when the call completes successfully', () async {
      final expectedResponse = [
        {
          "message": "Hello",
          "sender_id": 1,
          "receiver_id": 2,
          "timestamp": "2024-10-30T13:00:00Z"
        },
        {
          "message": "Hi",
          "sender_id": 2,
          "receiver_id": 1,
          "timestamp": "2024-10-30T13:05:00Z"
        }
      ];

      when(mockClient.get(
        Uri.parse('${apiConsumer.baseUrl}/chats/1'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response(json.encode(expectedResponse), 200));

      final result = await apiConsumer.getChatHistory(1);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, expectedResponse.length);
    });

    test('throws exception when the call fails', () async {
      when(mockClient.get(
        Uri.parse('${apiConsumer.baseUrl}/chats/1'),
        headers: anyNamed('headers'),
      )).thenAnswer(
          (_) async => http.Response('Failed to get chat history', 400));

      expect(apiConsumer.getChatHistory(1), throwsException);
    });
  });

  group('blockUser', () {
    test('completes successfully when the user is blocked', () async {
      when(mockClient.post(
        Uri.parse('${apiConsumer.baseUrl}/block/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response('{"message": "User blocked successfully"}', 200));

      await apiConsumer.blockUser(1);
    });

    test('throws exception when blocking user fails', () async {
      when(mockClient.post(
        Uri.parse('${apiConsumer.baseUrl}/block/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Failed to block user', 400));

      expect(apiConsumer.blockUser(1), throwsException);
    });
  });

  group('reportUser', () {
    test('completes successfully when the user is reported', () async {
      final reason = 'Inappropriate behavior';

      when(mockClient.post(
        Uri.parse('${apiConsumer.baseUrl}/report/user/1'),
        headers: anyNamed('headers'),
        body: json.encode({'reason': reason}),
      )).thenAnswer((_) async =>
          http.Response('{"message": "User reported successfully"}', 200));

      await apiConsumer.reportUser(reason, 1);
    });

    test('throws exception when reporting user fails', () async {
      final reason = 'Inappropriate behavior';

      when(mockClient.post(
        Uri.parse('${apiConsumer.baseUrl}/report/user/1'),
        headers: anyNamed('headers'),
        body: json.encode({'reason': reason}),
      )).thenAnswer((_) async => http.Response('Failed to report user', 400));

      expect(apiConsumer.reportUser(reason, 1), throwsException);
    });
  });
}
