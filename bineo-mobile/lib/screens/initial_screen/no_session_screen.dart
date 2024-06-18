import 'dart:io';

import 'package:bineo/blocs/common_bloc/common_bloc.dart';
import 'package:bineo/blocs/common_bloc/common_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_router.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/widgets/animated_app_icon.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_dialog_plus/native_dialog_plus.dart';

class NoSessionScreen extends StatefulWidget {
  NoSessionScreen({super.key});

  @override
  State<NoSessionScreen> createState() => _NoSessionScreenState();
}

class _NoSessionScreenState extends State<NoSessionScreen> {
  bool iconAnimationFinished = false;

  @override
  void initState() {
    super.initState();

    OnboardingBloc onboardingBloc = BlocProvider.of<OnboardingBloc>(context);
    OnboardingState state = onboardingBloc.state;

    onboardingBloc.add(ValidateSeonEvent());
    BlocProvider.of<CommonBloc>(context).add(InitAPIEvent());

    if (state.seonValidationFinished && !state.seonIsValid) {
      showSeonErrorDialog();
    }

    super.initState();
  }

  void goToOnBoarding(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRouter.onboardingRoute,
    );
  }

  void signIn() {
    Navigator.of(context).pushNamed(
      AppRouter.registerDeviceSignInRoute,
    );
  }

  Widget renderLogo() {
    return AnimatedAppIcon(
      onAnimationFinished: () {
        setState(() => iconAnimationFinished = true);
      },
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
              title: AppStrings.createAccountButton,
              style: AppButtonStyle.secondaryDark,
              onTap: () => goToOnBoarding(context),
            ),
          ),
          AppButton(
            title: AppStrings.signInButton,
            style: AppButtonStyle.primary,
            onTap: signIn,
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

  @override
  Widget build(BuildContext context) {
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
                child: renderLogo(),
              ),
              Container(
                height: 164,
                child: iconAnimationFinished
                    ? renderButtons(context)
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
