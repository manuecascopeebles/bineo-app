import 'dart:io';

import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/sign_in/sign_in_biometrics_screen.dart';
import 'package:bineo/screens/sign_in/sign_in_passcode_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:native_dialog_plus/native_dialog_plus.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LocalAuthentication localAuth = LocalAuthentication();
  String mainBiometric = '';

  @override
  void initState() {
    final state = BlocProvider.of<OnboardingBloc>(context).state;
    if (state.seonValidationFinished && !state.seonIsValid) {
      showSeonErrorDialog();
    }

    loadMainBiometric();

    super.initState();
  }

  Future loadMainBiometric() async {
    final biometrics = await localAuth.getAvailableBiometrics();

    String biometricToSet = '';

    if (biometrics.isNotEmpty) {
      if (biometrics.first == BiometricType.face) {
        biometricToSet = 'Face ID';
      } else if (biometrics.first == BiometricType.fingerprint) {
        biometricToSet = 'Huella';
      } else if (biometrics.first == BiometricType.strong) {
        biometricToSet = 'Touch ID';
      } else if (biometrics.first == BiometricType.weak) {
        biometricToSet = 'PIN';
      }
    }
    if (biometricToSet.isNotEmpty) {
      setState(() {
        mainBiometric = biometricToSet;
      });
    }
  }

  void signInPasscode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SignInPasscodeScreen(),
      ),
    );
  }

  void signInBiometrics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignInBiometricsScreen(biometricName: mainBiometric),
      ),
    );
  }

  Widget renderLogo() {
    return SVGs.getSVG(
      svg: SVGs.logo,
    );
  }

  Widget renderButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: AppButton(
              title: AppStrings.signInWithPasscode,
              style: AppButtonStyle.secondaryDark,
              onTap: signInPasscode,
            ),
          ),
          if (mainBiometric.isNotEmpty)
            AppButton(
              title: "${AppStrings.signInWithBiometrics} $mainBiometric",
              style: AppButtonStyle.primary,
              onTap: signInBiometrics,
            ),
        ],
      ),
    );
  }

  void showSeonErrorDialog() {
    NativeDialogPlus(
        title: AppStrings.securityPrevention,
        message: AppStrings.yourDeviceOrConnection,
        actions: [
          NativeDialogPlusAction(
            text: AppStrings.okay,
            style: NativeDialogPlusActionStyle.defaultStyle,
            onPressed: () {
              exit(0);
            },
          )
        ]).show();
  }

  Widget renderTitle(String title) {
    return Text(
      AppStrings.helloUser(title),
      style: AppStyles.heading3TextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final username =
        BlocProvider.of<AuthBloc>(context).state.session?.user.username ?? '';
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.seonValidationFinished && !state.seonIsValid) {
          showSeonErrorDialog();
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    renderLogo(),
                    const SizedBox(height: 20),
                    renderTitle(username),
                  ],
                ),
              ),
              renderButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
