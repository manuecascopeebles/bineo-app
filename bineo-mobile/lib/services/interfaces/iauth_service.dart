import 'dart:async';

import 'package:bineo/models/session.dart';

abstract class IAuthService {
  Session get session;
  Future<Session?> getSessionFromStorage();
  Future<Session> signIn(String email, String password);
  Future<void> sendForgotPasswordEmail(String email);
  Future<void> recoverPassword(String email, String password, String code);
  Future<void> sendOTPCode(String phone);
  Future<bool> verifyOTPCode(String code, String phone);
  Future<void> updatePasscode(String code, String userId, String deviceId);
  Future<Session> biometricSignIn(String email, String password);
  Future<Session> passcodeSignIn(
    String email,
    String password,
    String deviceId,
  );
  Future removeSession();
}
