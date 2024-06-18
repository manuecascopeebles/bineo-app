import 'package:bineo/apis/core/errors.dart';
import 'package:bineo/apis/seon/seon_api_call.dart';
import 'package:bineo/services/interfaces/iseon_service.dart';

import 'package:seon_plugin/seon_plugin.dart';
import 'package:uuid/uuid.dart';
import 'package:get_ip_address/get_ip_address.dart';

class SeonService extends ISeonService {
  String _transactionId = '';
  String _session = '';

  @override
  Future<bool> validate(String applicationId) async {
    _transactionId = applicationId;

    if (_session.isEmpty) {
      await generateSession();
    }

    var ipAddress = IpAddress();
    dynamic ipData = await ipAddress.getIpAddress();
    final value = await SeonAPI.instance
        .validate(_session, ipData.toString(), _transactionId);
    return value != SeonState.decline;
  }

  @override
  Future<bool> validateEmailAndPhone(String email, String phone) async {
    var ipAddress = IpAddress();
    dynamic ipData = await ipAddress.getIpAddress();
    final value = await SeonAPI.instance.validateEmailAndPhone(
        _session, ipData.toString(), _transactionId, email, phone);
    return value != SeonState.decline;
  }

  Future generateSession() async {
    var uuid = const Uuid();
    final seon = SeonPlugin();
    final session = await seon.getFingerPrintBase64(
        sessionId: uuid.v1(), isLoggingEnabled: true);

    if (session == null) {
      throw AppError('Unknown fingerprint');
    }
    _session = session;
  }

  @override
  String get transactionId => _transactionId;
}
