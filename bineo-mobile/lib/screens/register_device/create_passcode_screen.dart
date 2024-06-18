import 'package:bineo/blocs/auth_bloc/auth_bloc.dart';
import 'package:bineo/blocs/auth_bloc/auth_event.dart';
import 'package:bineo/blocs/auth_bloc/auth_state.dart';
import 'package:bineo/blocs/home_bloc/home_bloc.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/app_validators.dart';
import 'package:bineo/screens/success_screen.dart';
import 'package:bineo/screens/tab_bar/tab_bar_screen.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class CreatePasscodeScreen extends StatefulWidget {
  const CreatePasscodeScreen({
    super.key,
    this.originalPasscode = '',
    this.isConfirmationScreen = false,
  });

  final String originalPasscode;
  final bool isConfirmationScreen;

  @override
  State<CreatePasscodeScreen> createState() => _CreatePasscodeScreenState();
}

class _CreatePasscodeScreenState extends State<CreatePasscodeScreen> {
  String passcode = '';
  final FocusNode pinputNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        Duration(
          milliseconds: widget.isConfirmationScreen ? 300 : 0,
        ),
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

    if (widget.isConfirmationScreen) {
      BlocProvider.of<AuthBloc>(context).add(
        SetPasscodeEvent(value),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return CreatePasscodeScreen(
              originalPasscode: value,
              isConfirmationScreen: true,
            );
          },
        ),
      );
    }
  }

  String? validatePasscode(String? value) {
    if (!widget.isConfirmationScreen) {
      return AppValidators.requiredInput(value);
    } else {
      return AppValidators.confirmationPasscodeInput(
        value,
        widget.originalPasscode,
      );
    }
  }

  Widget renderTitle() {
    return Text(
      widget.isConfirmationScreen
          ? AppStrings.confirmPasscode
          : AppStrings.createPasscode,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderDescription() {
    return Text(
      AppStrings.createPasscodeDescription,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderPinput(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: Pinput(
            length: 6,
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
        if (!widget.isConfirmationScreen)
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
          hideBackButton:
              state.isSettingPasscode || !widget.isConfirmationScreen,
          body: MultiBlocListener(
            listeners: [
              _SetPasscodeErrorListener(),
              _SetPasscodeSuccessListener(),
            ],
            child: renderBody(state.isSettingPasscode),
          ),
        );
      },
    );
  }
}

class _SetPasscodeErrorListener extends BlocListener<AuthBloc, AuthState> {
  _SetPasscodeErrorListener()
      : super(
          listenWhen: (previous, current) {
            return previous.isSettingPasscode &&
                !current.isSettingPasscode &&
                current.hasErrorSettingPasscode;
          },
          listener: (context, state) {
            AppDialog.showMessage(
              AppStrings.somethingWentWrong,
              AppStrings.createPasscodeError,
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
            return previous.isSettingPasscode &&
                !current.isSettingPasscode &&
                !current.hasErrorSettingPasscode;
          },
          listener: (context, state) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (routeContext) {
                  return SuccessScreen(
                    showCloseButton: true,
                    title:
                        '${AppStrings.done}, ${state.session?.user.username}!',
                    description: AppStrings.passcodeSuccessDescription,
                    subtitleStyle: AppStyles.body2MediumEmphasisTextStyle,
                    onClose: () {
                      Navigator.of(routeContext).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) => HomeBloc(state.session!.user),
                            child: TabBarScreen(
                              showGrowAccountDialog: true,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              (route) => false,
            );
          },
        );
}
