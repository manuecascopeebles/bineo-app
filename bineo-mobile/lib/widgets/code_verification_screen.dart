import 'dart:io';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:nested/nested.dart';

abstract class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  StatefulElement createElement() => StatefulElement(this);
}

abstract class CodeVerificationScreenState<T extends CodeVerificationScreen>
    extends State<T> with CodeAutoFill {
  TextEditingController controller = TextEditingController(text: '');
  final SmsAutoFill smsAutoDetect = SmsAutoFill();
  String get verificationCodeTitle;
  String get verificationCodeSubtitle;
  List<SingleChildWidget> get listeners;
  String get phoneNumber;

  /// this is should be overridden due to the fact that it depends bloc state
  Widget get bottomWidget;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      getAppSignatureHash();
      // Start listening for the OTP code
      listenForCode();
    }

    autoFillFakeCode();
  }

  void autoFillFakeCode() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    setState(() {
      controller.text = '222222';
    });
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      smsAutoDetect.unregisterListener(); // Stop listening for the SMS code
      cancel();
    }
    super.dispose();
  }

  // Function to be overridden to handle App Signature Hash retrieval
  Future<String> getAppSignatureHash() async {
    String appSignature = await smsAutoDetect.getAppSignature;
    print("App Signature: $appSignature");
    return appSignature;
  }

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

  void showCodeExpiredDialog(BuildContext context) {
    AppDialog.showMessage(
      AppStrings.codeExpired,
      AppStrings.codeExpiredMessage,
      [
        NativeDialogPlusAction(
          text: AppStrings.okay,
          onPressed: () {},
        )
      ],
    );
  }

  void onChanged(String value) {
    if (value.length < 6) {
      setState(() {
        controller.text = '';
      });
    } else if (value.length == 6) {
      if (value != '222222') {
        showWrongCodeDialog(context);
      } else {
        verifyCode(context, value);
      }
    }
  }

  void verifyCode(BuildContext context, String value);

  void onComplete(String value);

  void requestNewCode();

  final defaultPinTheme = PinTheme(
    width: 48,
    height: 56,
    textStyle: AppStyles.digits1TextStyle,
    decoration: BoxDecoration(
      border: Border.all(color: AppStyles.bordersColor),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: MultiBlocListener(
        listeners: listeners,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verificationCodeTitle,
              style: AppStyles.heading2TextStyle,
            ),
            Text(
              verificationCodeSubtitle,
              style: AppStyles.body2HighEmphasisTextStyle,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Pinput(
                      length: 6,
                      controller: controller,
                      useNativeKeyboard: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyDecorationWith(
                        border: Border.all(color: AppStyles.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration,
                      ),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: false,
                      toolbarEnabled: false,
                      enabled: Platform.isAndroid ? false : true,
                      onChanged: onChanged,
                      onCompleted: onComplete,
                    ),
                  ),
                ),
              ],
            ),
            bottomWidget,
          ],
        ),
      ),
    );
  }

  void codeUpdated() {
    if (Platform.isAndroid) {
      print('Code: $code');
      if (mounted) {
        setState(() {
          controller.text = code ?? '';
        });
      }
      if (controller.text.length == 6) {
        verifyCode(context, controller.text);
      }
    }
  }
}
