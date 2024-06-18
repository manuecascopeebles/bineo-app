import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/screens/onboarding/personal_details_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    BlocProvider.of<OnboardingBloc>(context).add(
      const RequestInitialPermissionsEvent(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    OnboardingBloc onboardingBloc = BlocProvider.of<OnboardingBloc>(context);

    if (appLifecycleState == AppLifecycleState.paused &&
        !onboardingBloc.state.hasLocationPermission) {
      onboardingBloc.add(
        const RequestInitialPermissionsEvent(),
      );
    }

    setState(() {
      appLifecycleState = state;
    });
  }

  void startAccountCreation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PersonalDetailsScreen(),
      ),
    );
  }

  Widget renderAppIcon() {
    return SizedBox(
      height: 105,
      width: 105,
      child: Lottie.asset(
        'assets/animations/welcome-animation.json',
        repeat: false,
      ),
    );
  }

  Widget renderTitle() {
    return Text(
      AppStrings.welcomeTitle,
      style: AppStyles.heading1TextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget renderText(String text) {
    return Text(
      text,
      style: AppStyles.body1TextStyle,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.hasErrorGettingLocation) {
          ErrorScreen.show(
            context,
            errorText: AppStrings.errorGettingLocation,
            shouldExitApp: true,
          );
        }

        if (state.locationPermissionDenied) {
          AppDialog.showOpenSettingsDialog(
              AppStrings.locationPermissionSettingsTitle,
              AppStrings.locationPermissionSettingsDescription);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          hideBackButton: true,
          centerBody: true,
          submitButton: AppButton(
            title: AppStrings.welcomeButtonTitle,
            style: AppButtonStyle.primary,
            enabled: state.hasLocationPermission,
            onTap: () => startAccountCreation(context),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              renderAppIcon(),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: renderTitle(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: renderText(
                  AppStrings.welcomeText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: renderText(
                  AppStrings.welcomeText2,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: renderText(
                  AppStrings.welcomeText3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
