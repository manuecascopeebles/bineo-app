import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum SeonState { approve, decline, review }

class SeonAPI {
  static final SeonAPI instance = SeonAPI._();
  late Dio dio;

  SeonAPI._() {
    dio = Dio(BaseOptions(baseUrl: dotenv.env['SEON_BASE_URL']!, headers: {
      'X-API-KEY': dotenv.env['SEON_API_KEY'],
      'Content-Type': 'application/json'
    }));
  }

  Future<SeonState> validate(
      String session, String ip, String transactionId) async {
    final request = {
      "config": {
        "ip": {"include": "flags,history,id", "timeout": 2000, "version": "v1"},
        "ip_api": true,
        "device_fingerprinting": true,
        "ignore_velocity_rules": false,
        "response_fields":
            "id,state,fraud_score,ip_details,applied_rules,device_details,calculation_time,seon_id"
      },
      "ip": ip,
      "session": session,
      "transaction_id": transactionId
    };

    final resp = await dio.post('', data: request);
    if (resp.data['success'] == false) {
      return SeonState.decline;
    }

    final state = _stringToState(resp.data['data']['state']);
    return state;
  }

  Future<SeonState> validateEmailAndPhone(String session, String ip,
      String transactionId, String email, String phoneNumber) async {
    final request = {
      "config": {
        "ip": {"include": "flags,history,id", "timeout": 2000, "version": "v1"},
        "email": {
          "include": "flags,history,id",
          "timeout": 2000,
          "version": "v2"
        },
        "phone": {
          "include": "flags,history,id",
          "timeout": 2000,
          "version": "v1"
        },
        "ip_api": true,
        "email_api": true,
        "phone_api": true,
        "device_fingerprinting": true,
        "ignore_velocity_rules": false,
        "response_fields":
            "id,state,fraud_score,ip_details,applied_rules,device_details,calculation_time,seon_id"
      },
      "ip": ip,
      "session": session,
      "email": email,
      "phone_number": phoneNumber,
      "transaction_id": transactionId
    };

    final resp = await dio.post('', data: request);
    if (resp.data['success'] == false) {
      return SeonState.decline;
    }

    final state = _stringToState(resp.data['data']['state']);
    return state;
  }

  SeonState _stringToState(String value) {
    switch (value) {
      case 'APPROVE':
        return SeonState.approve;
      case 'DECLINE':
        return SeonState.decline;
      case 'REVIEW':
      default:
        return SeonState.review;
    }
  }
}
