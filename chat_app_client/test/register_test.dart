import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'api_helper_test.dart';
@GenerateMocks([http.Client])
import 'register_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiConsumer apiConsumer;
  const endpointRegister = '/auth/register';

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
      const username = 'testuser5';
      const password = 'testuser5';
      const email = 'testuser5@gmail.comm';

      mockHttpResponse(mockClient, endpointRegister, expectedResponse, 200);

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
      mockHttpResponse(mockClient, endpointRegister, {'message': 'Registration failed'}, 400);

      // Act & Assert
      expect(
            () => apiConsumer.register('testuser2', 'testpass', 'test2@example.com'),
        throwsException,
      );
    });
  });
}