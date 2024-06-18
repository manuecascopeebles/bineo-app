import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/blocs/home_bloc/home_bloc.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/initial_screen/initial_screen.dart';
import 'package:bineo/screens/tab_bar/tab_bar_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBiometricsScreen extends StatefulWidget {
  final String biometricName;
  const SignInBiometricsScreen({super.key, required this.biometricName});

  @override
  State<SignInBiometricsScreen> createState() => _SignInBiometricsScreenState();
}

class _SignInBiometricsScreenState extends State<SignInBiometricsScreen> {
  @override
  void initState() {
    getBiometrics(context);
    super.initState();
  }

  void getBiometrics(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      BiometricSignInEvent(),
    );
  }

  Widget renderButtons(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AppButton(
          title: "${AppStrings.signInWithBiometrics} ${widget.biometricName}",
          enabled: !state.isSigningInBiometrics,
          isLoading: state.isSigningInBiometrics,
          onTap: () => getBiometrics(context),
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
          _BiometricsSignInSuccessListener(),
          _BiometricPasscodeErrorListener()
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
              widget.biometricName,
              textAlign: TextAlign.center,
              style: AppStyles.heading2TextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _BiometricPasscodeErrorListener
    extends BlocListener<AuthBloc, AuthState> {
  _BiometricPasscodeErrorListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isSigningInBiometrics &&
                !current.isSigningInBiometrics &&
                current.hasSignInError;
          },
          listener: (context, state) {
            if (state.invalidBiometrics) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (routeContext) {
                    return InitialScreen();
                  },
                ),
                (route) => false,
              );
              return;
            }
          },
        );
}

class _BiometricsSignInSuccessListener
    extends BlocListener<AuthBloc, AuthState> {
  _BiometricsSignInSuccessListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isSigningInBiometrics &&
                !current.isSigningInBiometrics &&
                current.biometricsSignInSuccess;
          },
          listener: (context, state) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (routeContext) {
                  return BlocProvider(
                    create: (context) => HomeBloc(state.session!.user),
                    child: TabBarScreen(),
                  );
                },
              ),
              (route) => false,
            );
          },
        );
}
