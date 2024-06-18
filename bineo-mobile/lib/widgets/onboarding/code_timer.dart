import 'dart:async';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:flutter/material.dart';

class CodeTimer extends StatefulWidget {
  const CodeTimer({
    super.key,
    required this.phoneNumber,
    required this.onRequestNewCode,
    required this.isVerifyingOTPCode,
    required this.isSendingOTPCode,
  });
  final String phoneNumber;
  final Function() onRequestNewCode;
  final bool isVerifyingOTPCode;
  final bool isSendingOTPCode;

  @override
  State<CodeTimer> createState() => _CodeTimerState();
}

class _CodeTimerState extends State<CodeTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  int timesTried = 0;

  bool canRequestNewCode = false;
  Timer? timer;
  late int remainingTime;
  final int defaultTotalMinutes = 2;

  void startTimer(int totalMinutes) {
    setState(() {
      timesTried += 1;
    });

    remainingTime = totalMinutes * 60;
    canRequestNewCode = false;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: totalMinutes),
    );

    _animation = IntTween(begin: remainingTime, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          remainingTime = _animation.value;
        });
      });

    _controller.forward().whenComplete(() {
      onTimerEnd();
    });

    if (timesTried == 5) {
      showLimitExceedDialog(context);
    }
  }

  void onTimerEnd() {
    setState(() {
      canRequestNewCode = true;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer(defaultTotalMinutes);
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void requestNewCode() {
    startTimer(defaultTotalMinutes);

    widget.onRequestNewCode();
  }

  void showLimitExceedDialog(BuildContext context) {
    AppDialog.showMessage(
      AppStrings.tooManyAttempts,
      AppStrings.pleaseWait10Minutes,
      [
        NativeDialogPlusAction(
          text: AppStrings.exit,
          onPressed: () {
            setState(() {
              timesTried = 0;
            });
            int attemptsExceededMins = 10;
            startTimer(attemptsExceededMins);
          },
        )
      ],
    );
  }

  String getTimeString() {
    if (remainingTime == 0) {
      return AppStrings.verficationCodeTimer;
    }

    return '${AppStrings.verficationCodeTimer} ${AppStrings.inString} ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')} ${AppStrings.minutes}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Text(
            getTimeString(),
            style: AppStyles.body2HighEmphasisTextStyle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: widget.isVerifyingOTPCode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AppActivityIndicator(size: 20),
                    )
                  ],
                )
              : AppButton(
                  title: AppStrings.resendCode,
                  style: AppButtonStyle.secondaryDark,
                  onTap: requestNewCode,
                  enabled: canRequestNewCode,
                  isLoading: widget.isSendingOTPCode,
                ),
        ),
      ],
    );
  }
}
