import 'dart:io';

import 'package:bineo/apis/core/errors.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/local_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/services/core/injector.dart';
import 'package:bineo/services/interfaces/iauth_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  IAuthService _authService = Injector.resolve<IAuthService>();

  AuthBloc() : super(AuthState(isLoadingSession: true)) {
    LocalStorage localStorage = LocalStorage();
    LocalAuthentication biometrics = LocalAuthentication();

    on<InitializeBlocEvent>((event, emit) async {
      try {
        final session = await _authService.getSessionFromStorage();
        print('Session: $session');
        emit(state.copyWith(session: session, isLoadingSession: false));
      } catch (e) {
        print('No session found');
        emit(state.copyWith(isLoadingSession: false));
      }
    });

    on<SignInEvent>((event, emit) async {
      emit(state.copyWith(
        isSigningIn: true,
        hasSignInError: false,
      ));

      bool canCheckBiometrics = false;

      try {
        final session = await _authService.signIn(event.email, event.password);

        try {
          canCheckBiometrics = await biometrics.canCheckBiometrics;
        } catch (_) {
          // If this fails, do nothing, canCheckBiometrics will stay false
        }

        add(SendOTPCodeEvent(session.user.phoneNumber));

        emit(state.copyWith(
          session: session,
          isSigningIn: false,
          canCheckBiometrics: canCheckBiometrics,
        ));
      } catch (e) {
        emit(state.copyWith(
          isSigningIn: false,
          hasSignInError: true,
          canCheckBiometrics: canCheckBiometrics,
        ));
      }
    });

    on<PasscodeSignInEvent>((event, emit) async {
      emit(state.copyWith(
        isSigningInPasscode: true,
        hasSignInError: false,
        passcodeSignInSuccess: false,
        invalidBiometrics: false,
      ));

      try {
        String deviceId = await getDeviceId();
        final session = await _authService.passcodeSignIn(
          state.session!.user.email,
          event.passcode,
          deviceId,
        );

        emit(state.copyWith(
          session: session,
          isSigningInPasscode: false,
          passcodeSignInSuccess: true,
        ));
      } on BiometricError catch (e) {
        print('PasscodeSignInEvent BiometricError: $e');
        await _authService.removeSession();
        final updatedState = state.copyWith(
          isSigningInPasscode: false,
          invalidBiometrics: true,
          hasSignInError: true,
        );

        updatedState.session = null;

        emit(updatedState);
      } catch (e) {
        print('PasscodeSignInEvent error: $e');
        emit(state.copyWith(
          isSigningInPasscode: false,
          hasSignInError: true,
        ));
      }
    });

    on<BiometricSignInEvent>((event, emit) async {
      emit(state.copyWith(
        isSigningInBiometrics: true,
        hasSignInError: false,
        biometricsSignInSuccess: false,
        invalidBiometrics: false,
      ));

      try {
        bool isBiometricAuthenticated = await getBiometrics(biometrics);
        if (!isBiometricAuthenticated) {
          throw Error();
        }
        String deviceId = await getDeviceId();
        final session = await _authService.biometricSignIn(
          state.session!.user.email,
          deviceId,
        );

        emit(state.copyWith(
          session: session,
          isSigningInBiometrics: false,
          biometricsSignInSuccess: true,
        ));
      } on BiometricError catch (e) {
        print('PasscodeSignInEvent BiometricError: $e');
        _authService.removeSession();

        final updatedState = state.copyWith(
          isSigningInBiometrics: false,
          invalidBiometrics: true,
          hasSignInError: true,
        );

        updatedState.session = null;

        emit(updatedState);
      } catch (e) {
        emit(state.copyWith(
          isSigningInBiometrics: false,
          hasSignInError: true,
        ));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(state.copyWith(isSigningIn: true));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.signOut());
    });

    on<VerifyOTPCodeEvent>((event, emit) async {
      emit(state.copyWith(
        isVerifyingOTPCode: true,
        otpValidationError: false,
      ));

      try {
        bool isValid = await _authService.verifyOTPCode(
          event.code,
          event.phoneNumber,
        );

        if (!isValid) {
          emit(state.copyWith(
            otpIsInvalid: true,
            isVerifyingOTPCode: false,
          ));
          return;
        }

        emit(state.copyWith(isVerifyingOTPCode: false));
      } catch (e) {
        emit(state.copyWith(
          isVerifyingOTPCode: false,
          otpValidationError: true,
        ));
      }
    });

    on<SendOTPCodeEvent>((event, emit) async {
      emit(state.copyWith(isSendingOTPCode: true));

      try {
        await _authService.sendOTPCode(
          event.phoneNumber,
        );

        emit(state.copyWith(
          isSendingOTPCode: false,
          OTPCodeSent: true,
          hasErrorSendingOTPCode: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isSendingOTPCode: false,
          hasErrorSendingOTPCode: true,
        ));
      }
    });

    on<GetBiometricsEvent>((event, emit) async {
      emit(state.copyWith(isLoadingBiometrics: true));

      try {
        bool isBiometricAuthenticated = await getBiometrics(biometrics);

        localStorage.saveHasBiometricAuthentication(isBiometricAuthenticated);

        emit(state.copyWith(
          isLoadingBiometrics: false,
          isBiometricAuthenticated: isBiometricAuthenticated,
        ));
      } catch (_) {
        emit(state.copyWith(
          isLoadingBiometrics: false,
          isBiometricAuthenticated: false,
        ));
      }
    });

    on<SetPasscodeEvent>((event, emit) async {
      emit(state.copyWith(
        isSettingPasscode: true,
        hasErrorSettingPasscode: false,
      ));

      try {
        String deviceId = await getDeviceId();
        await _authService.updatePasscode(
          event.passcode,
          state.session!.user.id,
          deviceId,
        );

        emit(state.copyWith(isSettingPasscode: false));
      } catch (_) {
        emit(state.copyWith(
          isSettingPasscode: false,
          hasErrorSettingPasscode: true,
        ));
      }
    });
  }

  Future<bool> getBiometrics(LocalAuthentication biometrics) async {
    return await biometrics.authenticate(
      localizedReason: ' ',
      options: AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
        sensitiveTransaction: false,
        biometricOnly: true,
      ),
      authMessages: <AuthMessages>[
        IOSAuthMessages(
          lockOut: AppStrings.reenableBiometrics,
          goToSettingsButton: AppStrings.permissionSettingsDialogButton,
          goToSettingsDescription:
              AppStrings.biometricPermissionSettingsDescription,
          cancelButton: AppStrings.cancel,
          localizedFallbackTitle: AppStrings.usePassword,
        ),
        AndroidAuthMessages(
          biometricHint: AppStrings.biometricHint,
          biometricNotRecognized: AppStrings.biometricNotRecognized,
          biometricRequiredTitle: AppStrings.biometricNotConfigured,
          biometricSuccess: AppStrings.biometricSuccess,
          cancelButton: AppStrings.cancel,
          deviceCredentialsRequiredTitle: AppStrings.credentialsNotConfigured,
          deviceCredentialsSetupDescription:
              AppStrings.configureDeviceCredentials,
          goToSettingsButton: AppStrings.permissionSettingsDialogButton,
          goToSettingsDescription:
              AppStrings.biometricPermissionSettingsDescription,
          signInTitle: AppStrings.biometricSignInTitle,
        ),
      ],
    );
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? deviceId;
    deviceId = await LocalStorage().getDeviceId();

    if (deviceId != null) {
      return deviceId;
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? UniqueKey().toString();
    }

    LocalStorage().saveDeviceId(deviceId);

    return deviceId;
  }
}
