import 'dart:convert';
import 'dart:io';

import 'package:bineo/apis/bineo_api.dart';
import 'package:bineo/apis/fionner/fionner_api.dart';
import 'package:bineo/apis/core_api/core_api.dart';
import 'package:bineo/apis/open_text/open_text_api.dart';
import 'package:bineo/apis/renapo/renapo_api.dart';
import 'package:bineo/apis/romvo/romvo_api.dart';
import 'package:bineo/models/address.dart';
import 'package:bineo/models/ine.dart';
import 'package:bineo/models/zip_code.dart';
import 'package:bineo/services/interfaces/ionboarding_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class OnboardingService extends IOnboardingService {
  final BineoAPI _bineo = BineoAPI.instance;
  final FionnerAPI _fionner = FionnerAPI.instance;
  final OpenTextAPI _openText = OpenTextAPI.instance;
  final RenapoAPI _renapo = RenapoAPI.instance;
  final RomvoAPI _romvo = RomvoAPI.instance;

  @override
  Future<void> sendOTPCode(String phone) async {
    return await _bineo.sendOTP(phone);
  }

  @override
  Future<bool> verifyOTPCode(String code, String phone) async {
    await _bineo.validateOTP(code, phone);
    return true;
  }

  @override
  Future<bool> validateEmail(String email) async {
    final valid = await _fionner.validateEmail(email);
    return valid;
  }

  @override
  Future<bool> validateCurp(String curp) async {
    final valid = await _fionner.validateCurp(curp);
    return valid;
  }

  @override
  Future<bool> validateRenapo(INE ine) async {
    final valid = await _renapo.validate(ine);
    return valid;
  }

  @override
  Future<String> getRFC(INE ine) async {
    final rfc = await _bineo.getRfc(ine);
    return rfc;
  }

  @override
  Future<ZipCode> getZipCode(String postalCode) async {
    return await _bineo.getColonias(postalCode);
  }

  @override
  Future<bool> validateBlackList(
      String transactionId, INE ine, String stateId) async {
    return await _bineo.validateBlackList(transactionId, ine, stateId);
  }

  @override
  Future<File> generateContract(
      INE ine, String stateIsoCode, String phoneNumber, String email) async {
    final base64 =
        await _openText.getContract(ine, stateIsoCode, phoneNumber, email);
    final file = await _createFileFromString(base64);
    return file;
  }

  @override
  Future saveIne(INE ine, String applicationId) async {
    await _romvo.saveINE(ine, applicationId);
  }

  @override
  Future<bool> validateAlias(String alias) async {
    return await _bineo.validateAlias(alias);
  }

  @override
  Future<OnBoardingFlow> getOnBoarding(String username) async {
    final flow = await _romvo.getOnBoarding(username);
    return flow!;
  }

  @override
  Future acceptContract(String customerId) async {
    await _romvo.saveContractApproved(customerId);
  }

  @override
  Future saveCCInfo(String alias, {Address? address}) async {
    await _romvo.saveCCInfo(alias, address: address);
  }

  @override
  Future<String> createCore(
      String applcationId,
      INE ine,
      String email,
      String username,
      String phoneNumber,
      String cardName,
      Address cardAddress,
      double latitude,
      double longitude) async {
    phoneNumber = phoneNumber.replaceAll(' ', '');

    final externalId = const Uuid().v1();
    final customerId = await CoreAPI.instance.createClient(
        applcationId,
        externalId,
        ine,
        email,
        username,
        phoneNumber,
        cardName,
        cardAddress,
        latitude,
        longitude);

    await CoreAPI.instance
        .createZendesk(ine.name, email, phoneNumber, customerId);
    return customerId;
  }

  @override
  Future sendContract(String customerId, String email, File contract,
      String applicationId, String alias) async {
    final base64 = await _convertFileToBase64(contract);
    await _bineo.sendContract(customerId, email, base64, applicationId, alias);
  }

  Future<File> _createFileFromString(String base64String) async {
    final bytes = base64.decode(base64String);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<String> _convertFileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64.encode(bytes);
  }

  @override
  Future savePassword(String password) async {
    await _romvo.savePassword(password);
  }
}
