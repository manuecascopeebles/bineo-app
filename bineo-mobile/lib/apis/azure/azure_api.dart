import 'dart:convert';

import 'package:bineo/apis/core/oauth_token.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AzureAPI {
  late Dio dio;

  AzureAPI() {
    final options = BaseOptions(
      baseUrl: dotenv.env['AZURE_BASE_URL']!,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode(
                '${dotenv.env['AZURE_CLIENT_ID']}:${dotenv.env['AZURE_CLIENT_SECRET']}')),
      },
    );
    dio = Dio(options);
  }

  Future<OAuthToken> authenticate() async {
    final Map<String, dynamic> formData = {
      'grant_type': dotenv.env['AZURE_GRANT_TYPE'],
      'scope': dotenv.env['AZURE_SCOPE']
    };

    final resp = await dio.post('token', data: FormData.fromMap(formData));
    return OAuthToken.fromMap(resp.data);
  }
}
