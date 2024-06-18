import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_router.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  void goToSignIn(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.registerDeviceSignInRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isScrollable: false,
      hideBackButton: true,
      topSpacing: 0,
      submitButton:
          AppButton(title: AppStrings.signIn, onTap: () => goToSignIn(context)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Images.getImage(image: Images.congratulations),
            const SizedBox(height: 60),
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                return Text(
                  "${AppStrings.congratulations} ${state.username}!",
                  style: AppStyles.heading2TextStyle,
                );
              },
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.alreadyHaveBineoAccount,
                    style: AppStyles.heading5TextStyle,
                  ),
                  TextSpan(
                    text: AppStrings.light,
                    style: AppStyles.heading5TextStyle.copyWith(
                      color: AppStyles.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.youHaveToSignIn,
              style: AppStyles.heading5TextStyle.copyWith(
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
