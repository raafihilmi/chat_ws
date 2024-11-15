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
    apiConsumer = ApiConsumer(client: mockClient);
  });

  group('Register API Test', () {
    test('returns success response when registration is successful', () async {

      final expectedResponse = {'message': 'User registered successfully'};
      const username = 'testing1';
      const password = 'testing1';
      const email = 'testing1@gmail.comm';

      mockHttpResponse(
        mockClient: mockClient,
        method: 'POST',
        url: Uri.parse('${apiConsumer.baseUrl}$endpointRegister'),
        headers: {'Content-Type': 'application/json'},
        body: {'username': username, 'password': password, 'email': email},
        response: expectedResponse,
        statusCode: 200,
      );

      final result = await apiConsumer.register(username, password, email);

      expect(result, equals(expectedResponse));
    });

    test('throws an exception when registration fails', () async {
      final errorResponse = {'message': 'Registration failed'};
      mockHttpResponse(
        mockClient: mockClient,
        method: 'POST',
        url: Uri.parse('${apiConsumer.baseUrl}$endpointRegister'),
        headers: {'Content-Type': 'application/json'},
        body: {'username': 'testuser2', 'password': 'testpass', 'email': 'test2@example.com'},
        response: errorResponse,
        statusCode: 400,
      );

      expect(
            () => apiConsumer.register('testuser2', 'testpass', 'test2@example.com'),
        throwsException,
      );
    });
  });
}
