import 'dart:io';

import 'package:bineo/apis/romvo/romvo_api.dart';
import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/zip_code.dart';

abstract class IOnboardingService {
  Future<void> sendOTPCode(String phone);
  Future<bool> verifyOTPCode(String code, String phone);
  Future<bool> validateEmail(String email);
  Future<bool> validateCurp(String curp);
  Future<bool> validateRenapo(INE ine);
  Future<String> getRFC(INE ine);
  Future<ZipCode> getZipCode(String postalCode);
  Future<bool> validateBlackList(String transactionId, INE ine, String stateId);
  Future<File> generateContract(
      INE ine, String stateIsoCode, String phoneNumber, String email);
  Future saveIne(INE ine, String applicationId);
  Future<OnBoardingFlow> getOnBoarding(String username);
  Future acceptContract(String customerId);
  Future<bool> validateAlias(String alias);
  Future<String> createCore(
      String applcationId,
      INE ine,
      String email,
      String username,
      String phoneNumber,
      String cardName,
      Address cardAddress,
      double latitude,
      double longitude);
  Future sendContract(String customerId, String email, File contract,
      String applicationId, String alias);
  Future saveCCInfo(String alias, {Address? address});
  Future savePassword(String password);
}
