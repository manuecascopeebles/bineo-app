import 'dart:convert';

import 'package:bineo/apis/core/oauth_token.dart';
import 'package:bineo/apis/renapo/renapo_auth_interceptor.dart';
import 'package:bineo/models/ine.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RenapoAPI {
  static final RenapoAPI instance = RenapoAPI._();
  late Dio dio;
  late RenapoAuthInterceptor _authInterceptor;

  RenapoAPI._() {
    String username = dotenv.env['RENAPO_CLIENT_ID']!;
    String password = dotenv.env['RENAPO_CLIENT_SECRET']!;

    final options = BaseOptions(baseUrl: dotenv.env['RENAPO_BASE_URL']!);
    dio = Dio(options);

    _authInterceptor = RenapoAuthInterceptor(
        base64Encode(utf8.encode('$username:$password')), _refreshToken);
    dio.interceptors.add(_authInterceptor);
  }

  Future initialize() async {
    await authenticate();
  }

  Future authenticate() async {
    final request = dotenv.env['RENAPO_REQUEST'];
    final resp =
        await dio.post('authorization-server/oauth/token', data: request);

    final token = OAuthToken.fromMap(resp.data);
    _authInterceptor.setToken(token.accessToken);
  }

  Future<Response> _refreshToken(RequestOptions options) async {
    _authInterceptor.setToken('');
    await authenticate();
    return await dio.fetch(options);
  }

  Future<bool> validate(INE ine) async {
    final request = {
      "apellidoPaterno": ine.firstSurname,
      "apellidoMaterno": ine.secondSurname,
      "nombres": ine.name,
      "sexo": ine.gender,
      "fechaNacimiento": ine.curp!.dateString,
      "entidadNacimiento": ine.curp!.birthEntity,
      "curp": ine.curp!.value
    };

    final resp = await dio.post('validation/renapoProcess', data: request);
    final data = resp.data['data'];

    return data['curpValido'] &&
        data['nombre'] &&
        data['apellidoPaterno'] &&
        data['apellidoMaterno'];
  }
}
