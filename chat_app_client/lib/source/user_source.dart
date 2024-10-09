import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_client/common/urls.dart';
import 'package:chat_app_client/models/register_response.dart';
import 'package:chat_app_client/models/token_response.dart';
import 'package:http/http.dart' as http;


class UserSource {
  static const _baseURL = '${URLs.host}/api';

  static Future<RegisterResponse?> registerAcc(
      String username, password, email) async {
    log(username, name: "username");
    log(password, name: "password");
    log(email, name: "email");
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/auth/register'),
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email
        })
      );

      if(response.statusCode == 200) {
        log(response.body);
        Map resBody = jsonDecode(response.body);
        log(resBody.toString());

        return RegisterResponse(message: resBody.toString());
      }
      log('Response status: ${response.statusCode}', name: 'register');
      log('Response body: ${response.body}', name: 'register');

    } catch (e) {
      log(e.toString(), name: 'Error register');
      return null;
    }
    return null;
  }

  static Future<TokenResponse?> loginAcc(
      String username, password) async {
    log(username, name: "email");
    log(password, name: "password");
    try {
      final response = await http.post(
          Uri.parse('$_baseURL/auth/login'),
          body: jsonEncode({
            "username": username,
            "password": password,
          })
      );

      if(response.statusCode == 200) {
        log(response.body);
        Map resBody = jsonDecode(response.body);
        log(resBody.toString());

        return TokenResponse(token: resBody.toString());
      }

    } catch (e) {
      log(e.toString(), name: 'Error login');
      return null;
    }
    return null;
  }
}
