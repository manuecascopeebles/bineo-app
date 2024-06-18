import 'dart:convert';

import 'package:bineo/apis/core/oauth_token.dart';
import 'package:bineo/apis/fionner/fionner_auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FionnerAPI {
  static final FionnerAPI instance = FionnerAPI._();
  late Dio dio;
  late FionnerAuthInterceptor _authInterceptor;

  FionnerAPI._() {
    String username = dotenv.env['FIONNER_CLIENT_ID']!;
    String password = dotenv.env['FIONNER_CLIENT_SECRET']!;

    final options = BaseOptions(baseUrl: dotenv.env['FIONNER_BASE_URL']!);
    dio = Dio(options);

    _authInterceptor = FionnerAuthInterceptor(
        base64Encode(utf8.encode('$username:$password')), _refreshToken);
    dio.interceptors.add(_authInterceptor);
  }

  Future authenticate() async {
    final request = dotenv.env['FIONNER_REQUEST'];
    final resp = await dio.post('oauth2/token', data: request);

    final token = OAuthToken.fromMap(resp.data);
    _authInterceptor.setToken(token.accessToken);
  }

  Future<Response> _refreshToken(RequestOptions options) async {
    _authInterceptor.setToken('');
    await authenticate();
    return await dio.fetch(options);
  }

  Future<bool> validateEmail(String email) async {
    final endpoint =
        's4b/v15/bp/PersonSet?\$filter=EmailAddress eq \'$email\'&\$format=json';
    final resp = await dio.get(endpoint);
    final List<dynamic> results = resp.data['d']['results'];
    return results.isEmpty;
  }

  Future<bool> validateCurp(String curp) async {
    final endpoint =
        's4b/v15/bp/PersonSet?\$filter=SocialSecurityNumber eq \'$curp\'&\$format=json';
    final resp = await dio.get(endpoint);
    final List<dynamic> results = resp.data['d']['results'];
    if (kDebugMode) {
      return true;
    }
    return results.isEmpty;
  }

  Future<double> getBalance(String customerId) async {
    final endpoint =
        's4b/v1/bacovr/AccountSet?\$filter=AccountHolderID eq \'$customerId\'&\$format=json';
    final resp = await dio.get(endpoint);
    final List<dynamic> results = resp.data['d']['results'];
    if (results.isEmpty) {
      return 0;
    }

    return double.parse(results[0]['CurrentBalance']);
  }
}
