import 'package:bineo/apis/azure/azure_api.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/zip_code.dart';
import 'package:dio/dio.dart';
import 'package:bineo/apis/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BineoAPI {
  static final BineoAPI instance = BineoAPI._();
  final AzureAPI _azureAPI = AzureAPI();
  final Dio dio = Dio();

  BineoAPI._() {
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.options.validateStatus = (status) => status != 401;
    dio.interceptors
        .add(AuthInterceptor(dotenv.env['SUBSCRIPTION_KEY']!, refreshToken));
  }

  Future initialize() async {
    final token = await _azureAPI.authenticate();
    setToken(token.accessToken);
  }

  void setToken(String authToken) {
    final authInterceptor = dio.interceptors
        .firstWhere((element) => element is AuthInterceptor) as AuthInterceptor;
    authInterceptor.setToken(authToken);
  }

  Future<Response> refreshToken(RequestOptions requestOptions) async {
    print('Refreshing BINEO - OAuth2 Token');
    final token = await _azureAPI.authenticate();
    setToken(token.accessToken);
    return await dio.fetch(requestOptions);
  }

  Future<bool> validateLocation(
      double latitude, double longitude, String transactionId) async {
    final request = {
      "latitud": latitude.toStringAsFixed(6),
      "longitud": longitude.toStringAsFixed(6),
      'idProspecto': transactionId
    };

    final resp =
        await dio.post('itm/gps/operations/risk-location/v1', data: request);
    return !resp.data['riskCountry'];
  }

  Future sendOTP(String phoneNumber) async {
    final request = {
      "phoneNumber": phoneNumber.replaceAll(' ', ''),
      "channels": ["SMS"],
      "template": {"type": "cuenta-ahorro", "subType": "otp-autollenado"}
    };

    return await dio.post('api/itm/onboarding/otp/v1/generate', data: request);
  }

  Future validateOTP(String otp, String phoneNumber) async {
    final request = {
      "otp": otp,
      "phoneNumber": phoneNumber.replaceAll(' ', ''),
      "email": ""
    };

    await dio.post('api/itm/onboarding/otp/v1/validate', data: request);
  }

  Future<String> getRfc(INE ine) async {
    final request = {
      "personPhysical": {
        "firstName": ine.name,
        "lastName": ine.firstSurname,
        'personPhysical': ine.secondSurname,
        "dateOfBirth":
            '${ine.birthDate!.year}-${ine.birthDate!.month}-${ine.birthDate!.day}'
      }
    };

    final resp =
        await dio.post('data/validation-services/v1/get-rfc', data: request);
    return resp.data['rfc'];
  }

  Future<bool> validateAlias(String alias) async {
    final resp =
        await dio.get('data/validation-services/v1/approve-alias/$alias');
    return resp.data['offenseType'] == null;
  }

  Future<ZipCode> getColonias(String postalCode) async {
    final resp =
        await dio.get('data/catalogs/v1/zipcode-neighborhoods/$postalCode');

    final List<dynamic> list = resp.data['neighborhoods']['neighborhoodsSet'];
    final zipCode = ZipCode.fromMap(resp.data['zipcode']);
    zipCode.neighborhoods = list.map((a) => a['name'].toString()).toList();
    return zipCode;
  }

  Future<bool> validateBlackList(
      String transactionId, INE ine, String stateId) async {
    final request = {
      "applicationId": transactionId,
      "persons": [
        {
          "personEnum": 1,
          "isBeneficiary": false,
          "firstName": ine.name,
          "surName": "",
          "lastName": ine.firstSurname,
          "maternalLastName": ine.secondSurname,
          "taxId": ine.rfc,
          "CURP": ine.curp!.value,
          "dateOfBirth": ine.curp?.dateString,
          "birthAddress": {
            "countryID": 1,
            "stateID": int.parse(stateId),
          }
        }
      ]
    };
    final resp = await dio
        .post('api/v1/products/applications/verify-black-lists', data: request);
    final code = resp.data['response']['globalPoliciesResults']['code'];
    return code != 4;
  }

  Future sendContract(String customerId, String email, String contract,
      String applicationId, String alias) async {
    final request = {
      "emailAddresses": [email],
      "notification": {
        "type": "cuenta-ahorro",
        "subType": "cuenta-bienvenida",
        "channels": ["EMAIL"],
        "templateParams": [
          {"name": "custID", "value": customerId},
          {"name": "producto", "value": "Cuenta Bineo Ligera"},
          {"name": "namecorto", "value": alias}
        ],
        "attachments": [
          {
            "type": "application/pdf",
            "name": "contrato.pdf",
            "content": contract
          }
        ]
      }
    };
    dio.options.headers.addAll({'uuid': applicationId, 'Producer': 'Backbase'});
    await dio.post('api/itm/messaging/third-party/notification/v1',
        data: request);
  }
}
