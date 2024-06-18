import 'dart:io';
import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/screens/onboarding/IPAB_screen.dart';
import 'package:bineo/screens/onboarding/card_customization_screen.dart';
import 'package:bineo/screens/onboarding/contract_screen.dart';
import 'package:bineo/widgets/code_verification_screen.dart';
import 'package:bineo/screens/onboarding/products_menu_screen.dart';
import 'package:bineo/screens/error_screen.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/onboarding/code_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class OnboardingCodeVerificationScreen extends CodeVerificationScreen {
  OnboardingCodeVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OnboardingCodeVerificationScreen> createState() =>
      _OnboardingCodeVerificationScreenState();
}

class _OnboardingCodeVerificationScreenState
    extends CodeVerificationScreenState<OnboardingCodeVerificationScreen> {
  TextEditingController controller = TextEditingController(text: '');

  @override
  void verifyCode(BuildContext context, String code) {
    BlocProvider.of<OnboardingBloc>(context).add(
      VerifyOTPCodeEvent(code, widget.phoneNumber),
    );
  }

  void showSeonErrorDialog(BuildContext context) {
    AppDialog.showMessage(
      AppStrings.seonError,
      AppStrings.seonErrorMessage,
      [
        NativeDialogPlusAction(
          text: AppStrings.exit,
          onPressed: () {
            exit(0);
          },
        )
      ],
    );
  }

  void showAlreadyRegisteredDialog(BuildContext context) {
    AppDialog.showMessage(
      AppStrings.alreadyRegistered,
      AppStrings.alreadyRegisteredMessage,
      [
        NativeDialogPlusAction(
          text: AppStrings.login,
          onPressed: () {
            Navigator.of(context).popUntil((ModalRoute.withName('/initial')));
          },
        )
      ],
    );
  }

  void showHiringSoliticationDialog() async {
    AppDialog.showMessage(
      AppStrings.hiringSolitication,
      AppStrings.hiringSoliticationMessage,
      [
        NativeDialogPlusAction(
          text: AppStrings.hiringSoliticationButton1,
          onPressed: () {},
          style: NativeDialogPlusActionStyle.cancel,
        ),
        NativeDialogPlusAction(
          text: AppStrings.hiringSoliticationButton2,
          onPressed: () {},
        ),
      ],
    );
  }

  void pepRejection() {
    AppDialog.showMessage(
      AppStrings.weAreSorry,
      AppStrings.weAreCheckingYourRequest,
      [
        NativeDialogPlusAction(
          text: AppStrings.okay,
          onPressed: showRequestRejectedError,
          style: NativeDialogPlusActionStyle.cancel,
        ),
      ],
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
  void onComplete(String value) {}

  @override
  void requestNewCode() {
    BlocProvider.of<OnboardingBloc>(context).add(
      SendOTPCodeEvent(widget.phoneNumber),
    );
  }

  @override
  late String phoneNumber = widget.phoneNumber;

  @override
  String verificationCodeTitle = AppStrings.verficationCodeTitle;

  @override
  late String verificationCodeSubtitle =
      "${AppStrings.verficationCodeSubtitle} ${widget.phoneNumber}";

  @override
  late Widget bottomWidget = Column(
    children: [
      const SizedBox(height: 18),
      BlocBuilder<OnboardingBloc, OnboardingState>(
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
    OTPSuccessListener(listener: (context, state) {
      if (state.onBoardingFlow?.ine != null) {
        showPendingFlowAlert(context);
      } else {
        continueToProductsMenu(context);
      }
    }),
    OTPErrorListener(
        listener: (context, state) => showWrongCodeDialog(context)),
    EmailAlreadyExistsListener(
        listener: (context, state) => showAlreadyRegisteredDialog(context)),
    SeonErrorListener(
        listener: (context, state) => showSeonErrorDialog(context)),
  ];
}

void showPendingFlowAlert(BuildContext context) {
  AppDialog.showMessage(
    '¿Quieres continuar el proceso?',
    'Tienes una solicitud de contratación en proceso, puedes continuar desde donde te quedaste o volver a iniciar, tomaremos en cuenta la información compartida previamente',
    [
      NativeDialogPlusAction(
        text: AppStrings.continueString,
        onPressed: () => navigateToFlow(context),
      ),
      NativeDialogPlusAction(
        text: 'Iniciar de nuevo',
        onPressed: () => continueToProductsMenu(context),
        style: NativeDialogPlusActionStyle.cancel,
      ),
    ],
  );
}

void navigateToFlow(BuildContext context) {
  final bloc = BlocProvider.of<OnboardingBloc>(context);
  bloc.add(LoadFlowEvent());

  final flow = bloc.state.onBoardingFlow!;
  Widget screen;
  if (flow.contractApproved) {
    screen = IPABScreen();
  } else {
    if (flow.cardNickname.isNotEmpty) {
      screen = ContractScreen();
    } else {
      screen = CardCustomizationScreen();
    }
  }

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => screen,
    ),
    (route) => false,
  );
}

void continueToProductsMenu(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => ProductsMenuScreen(),
    ),
    (route) => false,
  );
}

class OTPErrorListener extends BlocListener<OnboardingBloc, OnboardingState> {
  OTPErrorListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.otpIsInvalid && current.otpIsInvalid;
          },
        );
}

class EmailAlreadyExistsListener
    extends BlocListener<OnboardingBloc, OnboardingState> {
  EmailAlreadyExistsListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.emailAlreadyExists && current.emailAlreadyExists;
          },
        );
}

class SeonErrorListener extends BlocListener<OnboardingBloc, OnboardingState> {
  SeonErrorListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.seonIsInvalid && current.seonIsInvalid;
          },
        );
}

class OTPSuccessListener extends BlocListener<OnboardingBloc, OnboardingState> {
  OTPSuccessListener({super.child, required super.listener})
      : super(listenWhen: (previous, current) {
          return previous.isVerifyingOTPCode &&
              !current.isVerifyingOTPCode &&
              !current.otpValidationError &&
              !current.emailAlreadyExists &&
              !current.seonIsInvalid &&
              current.onBoardingFlow != null;
        });
}
