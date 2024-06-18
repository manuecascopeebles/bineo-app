import 'package:bineo/apis/bineo_api.dart';
import 'package:bineo/apis/romvo/romvo_api.dart';
import 'package:bineo/common/local_storage.dart';
import 'package:bineo/models/session.dart';
import 'package:bineo/services/interfaces/iauth_service.dart';

class AuthService extends IAuthService {
  final LocalStorage _localStorage = LocalStorage();
  final BineoAPI _bineo = BineoAPI.instance;
  final RomvoAPI _romvo = RomvoAPI.instance;

  @override
  late Session session;

  AuthService() {
    initialize();
  }

  void initialize() async {
    final s = await _localStorage.getSession();
    if (s != null) {
      session = s;
    }
  }

  @override
  Future<Session?> getSessionFromStorage() async {
    return await _localStorage.getSession();
  }

  @override
  Future<Session> signIn(String email, String password) async {
    final token = await _romvo.signIn(email, password);
    final user = await _romvo.getProfile();

    session = Session(user: user, token: token);

    return session;
  }

  @override
  Future sendForgotPasswordEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future recoverPassword(
    String email,
    String password,
    String code,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<bool> verifyOTPCode(String code, String phone) async {
    await _bineo.validateOTP(code, phone);
    return true;
  }

  @override
  Future<void> sendOTPCode(String phone) async {
    return await _bineo.sendOTP(phone);
  }

  @override
  Future<void> updatePasscode(
      String code, String userId, String deviceId) async {
    await _romvo.updatePasscode(code, userId, deviceId);
    _localStorage.saveSession(session);
  }

  Future<Session> biometricSignIn(String email, String deviceId) async {
    final token = await _romvo.biomestricSignIn(email, deviceId);

    session.token = token;
    _localStorage.saveSession(session);

    return session;
  }

  @override
  Future<Session> passcodeSignIn(
    String email,
    String password,
    String deviceId,
  ) async {
    final token = await _romvo.passcodeSignIn(email, password, deviceId);

    session.token = token;
    _localStorage.saveSession(session);

    return session;
  }

  @override
  Future removeSession() async {
    await LocalStorage().removeItem(StorageKey.session);
  }
}
