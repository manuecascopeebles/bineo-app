import 'dart:convert';

import 'package:bineo/apis/core/request.dart';
import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoreAPI {
  static final CoreAPI instance = CoreAPI._();
  late Dio dio;

  CoreAPI._() {
    String username = dotenv.env['CORE_CLIENT_ID']!;
    String password = dotenv.env['CORE_CLIENT_SECRET']!;

    final options = BaseOptions(baseUrl: dotenv.env['CORE_BASE_URL']!);
    options.headers.addAll({
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}'
    });
    dio = Dio(options);
  }

  Future<String> createClient(
      String applcationId,
      String externalId,
      INE ine,
      String email,
      String username,
      String phoneNumber,
      String cardName,
      Address cardAddress,
      double latitude,
      double longitude) async {
    final request = getCoreRequest(applcationId, externalId, ine, email,
        username, phoneNumber, cardName, cardAddress, latitude, longitude);
    final resp = await dio.post('epicc4b', data: request);
    final customerId = resp.data['Response']['CustomerID'];
    return customerId;
  }

  Future createZendesk(
    String name,
    String email,
    String phoneNumber,
    String customerId,
  ) async {
    final request = {
      "user": {
        "name": name,
        "email": email,
        "phone": phoneNumber,
        "external_id": customerId,
        "role": "end-user",
        "verified": true,
        "user_fields": {
          "envio_publicidad": "si_publicidad",
          "whatsapp_publicidad": true,
          "email_publicidad": true,
          "sms_publicidad": true,
          "push_notifications_publicidad": true,
          "envio_fisico_de_estados_de_cuenta": "no_edo_cta"
        }
      }
    };

    final handler = Dio();
    handler.options.baseUrl = dotenv.env['ZENDESK_BASE_URL']!;
    handler.options.headers
        .addAll({'Authorization': dotenv.env['ZENDESK_AUTHORIZATION_KEY']!});
    await handler.post('create_or_update', data: request);
  }
}
