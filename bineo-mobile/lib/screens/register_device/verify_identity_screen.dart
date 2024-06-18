import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/screens/register_device/biometrics_screen.dart';
import 'package:bineo/screens/register_device/create_passcode_screen.dart';
import 'package:bineo/widgets/code_verification_screen.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/onboarding/code_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyIdentityScreen extends CodeVerificationScreen {
  VerifyIdentityScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState
    extends CodeVerificationScreenState<VerifyIdentityScreen> {
  TextEditingController controller = TextEditingController(text: '');
  final SmsAutoFill smsAutoDetect = SmsAutoFill();

  void showWrongCodeDialog(BuildContext context) {
    AppDialog.showMessage(
      AppStrings.wrongCode,
      AppStrings.wrongCodeMessage,
      [
        NativeDialogPlusAction(
          text: AppStrings.okay,
          onPressed: () {},
        )
      ],
    );
  }

  @override
  void requestNewCode() {
    BlocProvider.of<AuthBloc>(context).add(
      SendOTPCodeEvent(widget.phoneNumber),
    );
  }

  void showRequestRejectedError() {
    ErrorScreen.show(
      context,
      errorText: AppStrings.weAreCheckingYourRequest,
      onExit: () {
        Navigator.of(context).popUntil((ModalRoute.withName('/initial')));
      },
    );
  }

  @override
  void verifyCode(BuildContext context, String code) {
    BlocProvider.of<AuthBloc>(context).add(
      VerifyOTPCodeEvent(code, widget.phoneNumber),
    );
  }

  @override
  void onComplete(String value) {
    AuthState state = BlocProvider.of<AuthBloc>(context).state;

    Widget route;

    if (state.canCheckBiometrics) {
      route = BiometricsScreen();
    } else {
      route = CreatePasscodeScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => route),
    );
  }

  @override
  late String phoneNumber = widget.phoneNumber;

  @override
  String verificationCodeTitle = AppStrings.verficationCodeTitle;

  @override
  late String verificationCodeSubtitle =
      '${AppStrings.verficationCodeSubtitle} ${widget.phoneNumber}';

  @override
  late Widget bottomWidget = Column(
    children: [
      const SizedBox(height: 18),
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return CodeTimer(
            phoneNumber: phoneNumber,
            onRequestNewCode: requestNewCode,
            isVerifyingOTPCode: state.isVerifyingOTPCode,
            isSendingOTPCode: state.isSendingOTPCode,
          );
        },
      ),
    ],
  );

  @override
  late List<SingleChildWidget> listeners = [
    OTPSuccessListener(),
    OTPErrorListener(
      listener: (context, state) => showWrongCodeDialog(context),
    ),
  ];
}

class OTPErrorListener extends BlocListener<AuthBloc, AuthState> {
  OTPErrorListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.otpIsInvalid && current.otpIsInvalid;
          },
        );
}

class OTPSuccessListener extends BlocListener<AuthBloc, AuthState> {
  OTPSuccessListener({super.child})
      : super(listenWhen: (previous, current) {
          return previous.isVerifyingOTPCode &&
              !current.isVerifyingOTPCode &&
              !current.otpValidationError;
        }, listener: (context, state) {
          print('navigate to biometrics screen');
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => const FaceId(),
          //   ),
          // );
        });
}
