import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/blocs/home_bloc/home_bloc.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/screens/initial_screen/initial_screen.dart';
import 'package:bineo/screens/tab_bar/tab_bar_screen.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class SignInPasscodeScreen extends StatefulWidget {
  const SignInPasscodeScreen({super.key});

  @override
  State<SignInPasscodeScreen> createState() => _SignInPasscodeScreenState();
}

class _SignInPasscodeScreenState extends State<SignInPasscodeScreen> {
  final FocusNode pinputNode = FocusNode();
  final TextEditingController pinputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        Duration(milliseconds: 300),
        pinputNode.requestFocus,
      );
    });
  }

  @override
  void dispose() {
    pinputNode.dispose();

    super.dispose();
  }

  final PinTheme pinTheme = PinTheme(
    width: 48,
    height: 56,
    textStyle: AppStyles.digits1TextStyle,
    decoration: BoxDecoration(
      border: Border.all(
        color: AppStyles.bordersColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  void onCompletePasscode(String value) {
    if (validatePasscode(value) != null) return;

    BlocProvider.of<AuthBloc>(context).add(
      PasscodeSignInEvent(passcode: value),
    );
  }

  String? validatePasscode(String? value) {
    return AppValidators.requiredInput(value);
  }

  Widget renderTitle() {
    return Text(
      AppStrings.confirmPasscode,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderDescription() {
    return Text(
      AppStrings.signInWithPasscode,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderPinput(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: Pinput(
            length: 6,
            controller: pinputController,
            focusNode: pinputNode,
            enabled: !isLoading,
            showCursor: false,
            toolbarEnabled: false,
            useNativeKeyboard: true,
            defaultPinTheme: pinTheme,
            validator: validatePasscode,
            focusedPinTheme: pinTheme.copyDecorationWith(
              border: Border.all(
                color: AppStyles.primaryColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            submittedPinTheme: pinTheme.copyWith(
              decoration: pinTheme.decoration,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            errorTextStyle: AppStyles.inputErrorTextStyle,
            onCompleted: onCompletePasscode,
          ),
        ),
      ],
    );
  }

  Widget renderBody(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderTitle(),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: renderDescription(),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 30,
            bottom: 10,
          ),
          child: renderPinput(isLoading),
        ),
        if (isLoading)
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AppActivityIndicator(size: 20),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AppScaffold(
          body: MultiBlocListener(
            listeners: [
              _SignInPasscodeErrorListener(onError: () {
                setState(() {
                  pinputController.text = '';
                });
              }),
              _SetPasscodeSuccessListener(),
            ],
            child: renderBody(state.isSigningInPasscode),
          ),
        );
      },
    );
  }
}

class _SignInPasscodeErrorListener extends BlocListener<AuthBloc, AuthState> {
  final Function() onError;
  _SignInPasscodeErrorListener({required this.onError})
      : super(
          listenWhen: (previous, current) {
            return previous.isSigningInPasscode &&
                !current.isSigningInPasscode &&
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
            onError();
            AppDialog.showMessage(
              AppStrings.somethingWentWrong,
              AppStrings.signInPasscodeError,
              [
                NativeDialogPlusAction(
                  text: AppStrings.okay,
                  onPressed: () {},
                  style: NativeDialogPlusActionStyle.cancel,
                )
              ],
            );
          },
        );
}

class _SetPasscodeSuccessListener extends BlocListener<AuthBloc, AuthState> {
  _SetPasscodeSuccessListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isSigningInPasscode &&
                !current.isSigningInPasscode &&
                current.passcodeSignInSuccess;
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
