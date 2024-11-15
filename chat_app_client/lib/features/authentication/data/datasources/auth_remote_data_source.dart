import 'dart:developer';

import 'package:chat_app_client/core/api/api_consumer.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, password);

  Future<void> register(String username, password, email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<Map<String, dynamic>> login(String username, password) async {
    final response = await apiConsumer.login(username, password);
    log(response['token'], name: "TokenDS");
    log(response['user_id'].toString(), name: "UserIDDS");
    return {
      'token': response['token'],
      'user_id': response['user_id'],
    };
  }

  @override
  Future<void> register(String username, password, email) async {
    await apiConsumer.register(username, password, email);
  }
}
