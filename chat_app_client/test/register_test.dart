import 'dart:convert';
import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as yak;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
import 'register_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiConsumer apiConsumer;
  const baseUrl = 'http://192.168.1.217:8080/api';

  setUp(() {
    mockClient = MockClient();
    apiConsumer = ApiConsumer();
  });

  group('Register API Test', () {
    test('returns success response when registration is successful', () async {
      // Arrange
      final expectedResponse = {
        'message': 'User registered successfully'
      };
      const username = 'testuser3';
      const password = 'testuser3';
      const email = 'testuser3@gmail.comm';

      when(mockClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'email': email
        }),
      )).thenAnswer((_) async => http.Response(
        json.encode(expectedResponse),
        200,
      ));

      // Act
      final result = await apiConsumer.register(
          username,
          password,
          email
      );

      // Assert
      expect(result, equals(expectedResponse));
    });

    test('throws an exception when registration fails', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': 'testuser2',
          'password': 'testpass',
          'email': 'test2@example.com'
        }),
      )).thenAnswer((_) async => http.Response(
        'Registration failed',
        400,
      ));

      // Act & Assert
      expect(
            () => apiConsumer.register('testuser2', 'testpass', 'test2@example.com'),
        throwsException,
      );
    });
  });
}