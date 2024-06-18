import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/register_device/create_passcode_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricsScreen extends StatelessWidget {
  const BiometricsScreen({super.key});

  void goToPasscode(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CreatePasscodeScreen(),
      ),
    );
  }

  void getBiometrics(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      GetBiometricsEvent(),
    );
  }

  Widget renderButtons(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                bottom: 15,
              ),
              child: AppButton(
                title: AppStrings.later,
                style: AppButtonStyle.secondaryDark,
                enabled: !state.isLoadingBiometrics,
                onTap: () => goToPasscode(context),
              ),
            ),
            AppButton(
              title: AppStrings.enableFaceIdAction,
              enabled: !state.isLoadingBiometrics,
              isLoading: state.isLoadingBiometrics,
              onTap: () => getBiometrics(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideBackButton: true,
      centerBody: true,
      submitButton: renderButtons(context),
      body: MultiBlocListener(
        listeners: [
          _GetBiometricsFinishedListener(),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              margin: const EdgeInsets.only(bottom: 30),
              child: SVGs.getSVG(svg: SVGs.faceId),
            ),
            Text(
              AppStrings.enableFaceId,
              textAlign: TextAlign.center,
              style: AppStyles.heading2TextStyle,
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                top: 10,
              ),
              child: Text(
                AppStrings.faceIdDescription1,
                textAlign: TextAlign.center,
                style: AppStyles.body2MediumEmphasisTextStyle,
              ),
            ),
            Text(
              AppStrings.faceIdDescription2,
              textAlign: TextAlign.center,
              style: AppStyles.body2MediumEmphasisTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _GetBiometricsFinishedListener extends BlocListener<AuthBloc, AuthState> {
  _GetBiometricsFinishedListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isLoadingBiometrics && !current.isLoadingBiometrics;
          },
          listener: (context, state) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CreatePasscodeScreen(),
              ),
            );
          },
        );
}
