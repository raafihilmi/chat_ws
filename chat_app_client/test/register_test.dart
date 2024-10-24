import 'dart:convert';
import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([], customMocks: [
  MockSpec<http.Client>(
    as: #MockHttpClient,
    onMissingStub: OnMissingStub.returnDefault,
  )
])
import 'register_test.mocks.dart';

void main() {
  late MockHttpClient mockClient;
  late ApiConsumer authService;
  const baseUrl = 'http://192.168.1.217:8080/api';

  setUp(() {
    mockClient = MockHttpClient();
    authService = ApiConsumer();
  });

  group('Register API Test', () {
    test('returns success response when registration is successful', () async {
      // Arrange
      final expectedResponse = {
        'message': 'User registered successfully'
      };

      when(mockClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': 'testuser',
          'password': 'testpass',
          'email': 'test@example.com'
        }),
      )).thenAnswer((_) async => http.Response(
        json.encode(expectedResponse),
        200,
      ));

      // Act
      final result = await authService.register(
          'testuser',
          'testpass',
          'test@example.com'
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
          'username': 'testuser',
          'password': 'testpass',
          'email': 'test@example.com'
        }),
      )).thenAnswer((_) async => http.Response(
        'Registration failed',
        400,
      ));

      // Act & Assert
      expect(
            () => authService.register('testuser', 'testpass', 'test@example.com'),
        throwsException,
      );
    });

    test('handles network errors', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
            () => authService.register('testuser', 'testpass', 'test@example.com'),
        throwsException,
      );
    });
  });
}