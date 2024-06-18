import 'dart:io';

import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:flutter/material.dart';

class ErrorScreen {
  ErrorScreen._();

  static void show(
    BuildContext context, {
    required String errorText,
    bool shouldExitApp = false,
    Function()? onExit,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return _ErrorScreen(
            errorText: errorText,
            shouldExitApp: shouldExitApp,
            onExit: onExit,
          );
        },
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  _ErrorScreen({
    required this.errorText,
    this.shouldExitApp = false,
    this.onExit,
  });

  final String errorText;
  final bool shouldExitApp;
  final Function()? onExit;

  void exitScreen(BuildContext context) {
    if (shouldExitApp) {
      exit(0);
    } else {
      onExit != null ? onExit!() : Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 45),
                      child: Text(
                        AppStrings.weAreSorry,
                        style: AppStyles.heading3TextStyle,
                      ),
                    ),
                    Text(
                      errorText,
                      style: AppStyles.body1TextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: AppButton(
                      title: AppStrings.exit,
                      style: AppButtonStyle.primary,
                      onTap: () => exitScreen(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
