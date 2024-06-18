import 'dart:convert';

import 'package:bineo/apis/core/request.dart';
import 'package:bineo/models/ine.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenTextAPI {
  static final OpenTextAPI instance = OpenTextAPI._();

  OpenTextAPI._();

  Future<String> _authenticate() async {
    final request = {
      "user_name": dotenv.env['OPEN_TEXT_USERNAME']!,
      "password": dotenv.env['OPEN_TEXT_PASSWORD']!
    };
    final dio = Dio();
    dio.options.headers.addAll({'Content-Type': 'application/json'});
    final resp = await dio.postUri(
        Uri.parse(dotenv.env['OPEN_TEXT_AUTH_ENDPOINT']!),
        data: request);
    return resp.data['ticket'];
  }

  Future<String> getContract(
      INE ine, String stateIsoCode, String phoneNumber, String email) async {
    final ticket = await _authenticate();

    final contract = getContractRequest(ine, stateIsoCode, phoneNumber, email);
    final base64Request = base64Encode(contract.codeUnits);

    final request = {
      "content": {"contentType": "text/xml", "data": base64Request}
    };

    final dio = Dio();
    dio.options.headers.addAll({'OTDSTicket': ticket});
    dio.options.headers.addAll({'Content-Type': 'application/json'});

    final resp = await dio.postUri(
        Uri.parse(dotenv.env['OPEN_TEXT_CONTRACT_ENDPOINT']!),
        data: request);
    final List<dynamic> list = resp.data['data']['result'];
    if (list.length == 0) return '';
    final base64 = list[0]['content']['data'];
    return base64;
  }
}
