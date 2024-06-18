import 'package:bineo/screens/initial_screen/initial_screen.dart';
import 'package:bineo/screens/onboarding/onboarding_screen.dart';
import 'package:bineo/screens/register_device/register_device_sign_in_screen.dart';
import 'package:bineo/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String initialRoute = '/initial';
  static const String onboardingRoute = '/onboarding';
  static const String registerDeviceSignInRoute = '/register-device-sign-in';
  static const String signInRoute = '/sign-in';

  static final Map<String, Widget Function(BuildContext)> routes = {
    initialRoute: (context) => InitialScreen(),
    onboardingRoute: (context) => OnboardingScreen(),
    registerDeviceSignInRoute: (context) => RegisterDeviceSignInScreen(),
    signInRoute: (context) => SignInScreen(),
  };
}
