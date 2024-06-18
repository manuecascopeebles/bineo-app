import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/onboarding/onboarding_code_verification_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_input.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class PhoneInputScreen extends StatefulWidget {
  PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final phoneController = TextEditingController();

  final _currentSelectedCountry = CountryWithPhoneCode(
    phoneCode: '52',
    countryCode: 'MX',
    exampleNumberMobileNational: '55 1234 5678',
    exampleNumberFixedLineNational: '55 1234 5678',
    phoneMaskMobileNational: '00 0000 0000',
    phoneMaskFixedLineNational: '00 0000 0000',
    exampleNumberMobileInternational: '+52 55 1234 5678',
    exampleNumberFixedLineInternational: '+52 55 1234 5678',
    phoneMaskMobileInternational: '+00 00 0000 0000',
    phoneMaskFixedLineInternational: '+00 00 0000 0000',
    countryName: 'Mexico',
  );

  void sendOTPCode(BuildContext context) {
    BlocProvider.of<OnboardingBloc>(context).add(
      SendOTPCodeEvent(phoneController.text),
    );
  }

  void continueOnboarding(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingCodeVerificationScreen(
          phoneNumber: phoneController.text,
        ),
      ),
    );
  }

  Widget renderSubmitButton(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        OTPSentListener(
          listener: (context, state) => continueOnboarding(context),
        ),
        ErrorSendingOTPCode(),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              String phoneNumber = phoneController.text.replaceAll(' ', '');
              return AppButton(
                enabled: phoneNumber.length == 10,
                isLoading: state.isSendingOTPCode,
                title: AppStrings.phoneNumberInputButton,
                style: AppButtonStyle.primary,
                onTap: () => sendOTPCode(context),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      submitButton: renderSubmitButton(context),
      body: Column(
        children: [
          Text(
            AppStrings.phoneNumberInputTitle,
            style: AppStyles.heading2TextStyle,
          ),
          Text(
            AppStrings.phoneNumberInputDescription,
            style: AppStyles.body2HighEmphasisTextStyle,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 28, left: 16),
                child: Row(
                  children: [
                    SVGs.getSVG(
                      svg: SVGs.mexicoFlag,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _currentSelectedCountry.countryCode,
                      style: AppStyles.body2HighEmphasisTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AppInput(
                  controller: phoneController,
                  onChanged: (p0) => setState(() {}),
                  inputFormatters: [
                    LibPhonenumberTextFormatter(
                      country: _currentSelectedCountry,
                      inputContainsCountryCode: false,
                      shouldKeepCursorAtEndOfInput: true,
                    ),
                  ],
                  onSubmitted: (p0) => sendOTPCode(context),
                  type: AppInputType.numeric,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            AppStrings.phoneNumberInputDescription2,
            style: AppStyles.body2HighEmphasisTextStyle,
          ),
        ],
      ),
    );
  }
}

class OTPSentListener extends BlocListener<OnboardingBloc, OnboardingState> {
  OTPSentListener({required super.listener, super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.OTPCodeSent && current.OTPCodeSent;
          },
        );
}

class ErrorSendingOTPCode
    extends BlocListener<OnboardingBloc, OnboardingState> {
  ErrorSendingOTPCode({super.child})
      : super(
          listenWhen: (previous, current) {
            return !previous.hasErrorSendingOTPCode &&
                current.hasErrorSendingOTPCode;
          },
          listener: (context, state) {
            // do something
            print('Error sending OTP code');
          },
        );
}
