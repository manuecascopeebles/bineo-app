import 'package:bineo/apis/core/errors.dart';
import 'package:collection/collection.dart';
import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RomvoAPI {
  static final RomvoAPI instance = RomvoAPI._();
  late Dio dio;
  String _email = '';
  String _phoneNumber = '';

  RomvoAPI._() {
    final options = BaseOptions(baseUrl: dotenv.env['ROMVO_BASE_URL']!);
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': dotenv.env['ROMVO_AUTHORIZATION_KEY']!
    });

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        DioError error = e;

        if (e.response?.statusCode == 410) {
          error = PasswordError(e);
        }

        if (e.response?.statusCode == 411 || e.response?.statusCode == 412) {
          error = throw BiometricError(e);
        }

        return handler.next(error);
      },
    ));
  }

  void initialize(String email, String phoneNumber) {
    _email = email;
    _phoneNumber = phoneNumber;
  }

  void setAuthenticationToken(String token) {
    if (token == '') {
      dio.options.headers.remove('authentication');
      return;
    }
    dio.options.headers['authentication'] = token;
  }

  Future<OnBoardingFlow?> getOnBoarding(String username) async {
    final request = {
      "username": username,
      "email": _email,
      "phone": _phoneNumber
    };
    final resp = await dio.post('onboarding', data: request);
    if (resp.data['error'] == true) return null;

    return OnBoardingFlow.fromMap(resp.data['response']);
  }

  Future saveINE(INE ine, String applicationId) async {
    final request = {
      "email": _email,
      "phone": _phoneNumber,
      "name": ine.name,
      "surname": ine.firstSurname,
      "surname2": ine.secondSurname,
      "curp": ine.curp!.value,
      "rfc": ine.rfc,
      "birth_country": ine.birthCountry,
      "voter_id": ine.voterId,
      "application_id": applicationId,
      "address": {
        "street": ine.address.street,
        "ext_number": ine.address.exteriorNumber,
        "int_number": ine.address.interiorNumber,
        "zip_code": ine.address.postalCode,
        "neighborhood_text": ine.address.municipality,
        "city": ine.address.colony,
        "state": ine.address.state?.name ?? '',
        "state_iso": ine.address.state?.isoCode ?? '',
        "state_id": ine.address.state?.id ?? '',
        "type": 1
      }
    };
    await dio.post('onboarding', data: request);
  }

  Future saveContractApproved(String customerId) async {
    final request = {
      "email": _email,
      "phone": _phoneNumber,
      "contract_approve": true,
      "user_id": customerId
    };
    await dio.post('onboarding', data: request);
  }

  Future savePassword(String password) async {
    final request = {
      "email": _email,
      "phone": _phoneNumber,
      "password": password
    };
    await dio.post('onboarding', data: request);
  }

  Future saveCCInfo(String alias, {Address? address}) async {
    final Map<String, dynamic> request = {
      "email": _email,
      "phone": _phoneNumber,
      'card_nickname': alias,
    };

    if (address != null) {
      request['address'] = {
        "street": address.street,
        "ext_number": address.exteriorNumber,
        "int_number": address.interiorNumber,
        "zip_code": address.postalCode,
        "neighborhood_text": address.municipality,
        "city": address.colony,
        "state": address.state?.name ?? '',
        "state_iso": address.state?.isoCode ?? '',
        "state_id": address.state?.id ?? '',
        "type": 2
      };
    }

    await dio.post('onboarding', data: request);
  }

  Future<String> signIn(String email, String password) async {
    final request = {
      "username": email,
      "password": password,
      "type": "password"
    };

    final resp = await dio.post('login', data: request);

    setAuthenticationToken(resp.data['response']['token']);

    return resp.data['response']['token'];
  }

  Future<String> biomestricSignIn(String email, String deviceId) async {
    final request = {
      "username": email,
      "password": deviceId,
      "type": "biometric"
    };

    final resp = await dio.post('login', data: request);

    setAuthenticationToken(resp.data['response']['token']);

    return resp.data['response']['token'];
  }

  Future<String> passcodeSignIn(
    String email,
    String password,
    String deviceId,
  ) async {
    final request = {
      "username": email,
      "password": password,
      "biometric": deviceId,
      "type": "passcode"
    };

    final resp = await dio.post('login', data: request);

    setAuthenticationToken(resp.data['response']['token']);

    return resp.data['response']['token'];
  }

  Future<User> getProfile() async {
    final resp = await dio.get('profile');

    return User.fromMap(resp.data['response']);
  }

  Future updatePasscode(String code, String userId, String deviceId) async {
    final request = {"passcode": code, "biometric": deviceId};

    await dio.put('users/$userId', data: request);
  }
}

class OnBoardingFlow {
  String applicationId;
  String customerId;
  INE? ine;
  String cardNickname;
  bool contractApproved;
  Address? cardAddress;

  OnBoardingFlow(
      {required this.applicationId,
      required this.ine,
      required this.cardNickname,
      required this.contractApproved,
      required this.cardAddress,
      required this.customerId});

  factory OnBoardingFlow.fromMap(Map<String, dynamic> map) {
    final curp = map['curp'];
    final addresses = map['addresses'] as List<dynamic>;
    final cardAddress = addresses.firstWhereOrNull((a) => a['type'] == 2);
    return OnBoardingFlow(
        applicationId: map['application_id'] ?? '',
        ine: curp == null || curp.toString().isEmpty ? null : INE.fromMap(map),
        cardNickname: map['card_nickname'] ?? '',
        contractApproved: map['contract_approve'],
        cardAddress: cardAddress == null ? null : Address.fromMap(cardAddress),
        customerId: map['user_id'] ?? '');
  }
}
