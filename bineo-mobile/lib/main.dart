import 'package:bineo/blocs/common_bloc/common_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/common/app_router.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/services/bindings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/models/incode_sdk_init_error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  IncodeOnboardingSdk.setLocalizationLanguage(language: 'es');
  IncodeOnboardingSdk.init(
    apiUrl: dotenv.env['INCODE_API_URL'] ?? '',
    apiKey: dotenv.env['INCODE_API_KEY'] ?? '',
    testMode: false,
    onError: (String error) {
      IncodeSdkInitError? e = error.toIncodeSdkInitError();

      switch (e) {
        case IncodeSdkInitError.hookDetected:
          print(
              'Incode init failed, hook detected: $IncodeSdkInitError.hookDetected');
          break;
        case IncodeSdkInitError.testModeEnabled:
          print(
              'Incode init failed, test mode enabled: $IncodeSdkInitError.testModeEnabled');
          break;
        default:
          print('Incode init failed: $error');
          break;
      }
    },
    onSuccess: () {
      // Update UI, safe to start Onboarding
      print('Incode initialize successfully!');
    },
  );

  IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
  // IncodeOnboardingSdk.setTheme(theme: theme);

  Bindings.register();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CommonBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => OnboardingBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppStyles.surfaceColor,
          primaryColor: AppStyles.primaryColor,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
      ),
    );
  }
}
