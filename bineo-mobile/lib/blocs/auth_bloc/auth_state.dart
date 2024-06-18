import 'package:bineo/models/session.dart';

class AuthState {
  bool isLoadingSession = false;
  Session? session;
  bool isSigningIn = false;
  bool isSigningInPasscode = false;
  bool passcodeSignInSuccess = false;
  bool isSigningInBiometrics = false;
  bool biometricsSignInSuccess = false;
  bool hasSignInError = false;
  bool isSettingPasscode = false;
  bool hasErrorSettingPasscode = false;
  bool invalidBiometrics = false;

  // OTP
  bool OTPCodeSent = false;
  bool otpIsInvalid = false;
  bool isSendingOTPCode = false;
  bool otpValidationError = false;
  bool isVerifyingOTPCode = false;
  bool hasErrorSendingOTPCode = false;

  // Biometrics
  bool canCheckBiometrics = false;
  bool isLoadingBiometrics = false;
  bool isBiometricAuthenticated = false;

  AuthState({
    this.isLoadingSession = false,
    this.session,
    this.isSigningIn = false,
    this.isSigningInPasscode = false,
    this.passcodeSignInSuccess = false,
    this.isSigningInBiometrics = false,
    this.biometricsSignInSuccess = false,
    this.hasSignInError = false,
    this.isSettingPasscode = false,
    this.hasErrorSettingPasscode = false,
    this.invalidBiometrics = false,
    this.OTPCodeSent = false,
    this.otpIsInvalid = false,
    this.isSendingOTPCode = false,
    this.otpValidationError = false,
    this.isVerifyingOTPCode = false,
    this.hasErrorSendingOTPCode = false,
    this.canCheckBiometrics = false,
    this.isLoadingBiometrics = false,
    this.isBiometricAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoadingSession,
    Session? session,
    bool? isSigningIn,
    bool? isSigningInPasscode,
    bool? passcodeSignInSuccess,
    bool? isSigningInBiometrics,
    bool? biometricsSignInSuccess,
    bool? hasSignInError,
    bool? isSettingPasscode,
    bool? hasErrorSettingPasscode,
    bool? invalidBiometrics,
    bool? OTPCodeSent,
    bool? otpIsInvalid,
    bool? isSendingOTPCode,
    bool? otpValidationError,
    bool? isVerifyingOTPCode,
    bool? hasErrorSendingOTPCode,
    bool? canCheckBiometrics,
    bool? isLoadingBiometrics,
    bool? isBiometricAuthenticated,
  }) {
    return AuthState(
      isLoadingSession: isLoadingSession ?? this.isLoadingSession,
      session: session ?? this.session,
      isSigningIn: isSigningIn ?? this.isSigningIn,
      isSigningInPasscode: isSigningInPasscode ?? this.isSigningInPasscode,
      passcodeSignInSuccess:
          passcodeSignInSuccess ?? this.passcodeSignInSuccess,
      isSigningInBiometrics:
          isSigningInBiometrics ?? this.isSigningInBiometrics,
      biometricsSignInSuccess:
          biometricsSignInSuccess ?? this.biometricsSignInSuccess,
      hasSignInError: hasSignInError ?? this.hasSignInError,
      isSettingPasscode: isSettingPasscode ?? this.isSettingPasscode,
      hasErrorSettingPasscode:
          hasErrorSettingPasscode ?? this.hasErrorSettingPasscode,
      invalidBiometrics: invalidBiometrics ?? this.invalidBiometrics,
      OTPCodeSent: OTPCodeSent ?? this.OTPCodeSent,
      otpIsInvalid: otpIsInvalid ?? this.otpIsInvalid,
      isSendingOTPCode: isSendingOTPCode ?? this.isSendingOTPCode,
      otpValidationError: otpValidationError ?? this.otpValidationError,
      isVerifyingOTPCode: isVerifyingOTPCode ?? this.isVerifyingOTPCode,
      hasErrorSendingOTPCode:
          hasErrorSendingOTPCode ?? this.hasErrorSendingOTPCode,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      isLoadingBiometrics: isLoadingBiometrics ?? this.isLoadingBiometrics,
      isBiometricAuthenticated:
          isBiometricAuthenticated ?? this.isBiometricAuthenticated,
    );
  }

  AuthState signOut() {
    return AuthState(
      session: null,
      isSigningIn: false,
      hasSignInError: false,
    );
  }
}
