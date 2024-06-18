import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/password.dart';
import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  final Password password;

  Color getColor() {
    switch (password.strength) {
      case PasswordStrength.strong:
        return AppStyles.strongPasswordColor;
      case PasswordStrength.medium:
        return AppStyles.mediumPasswordColor;
      case PasswordStrength.weak:
        return AppStyles.weakPasswordColor;
      case PasswordStrength.veryWeak:
        return AppStyles.veryWeakPasswordColor;
    }
  }

  String getTitle() {
    switch (password.strength) {
      case PasswordStrength.strong:
        return AppStrings.strong;
      case PasswordStrength.medium:
        return AppStrings.medium;
      case PasswordStrength.weak:
        return AppStrings.weak;
      case PasswordStrength.veryWeak:
        return AppStrings.veryWeak;
    }
  }

  double getWidthMultiplier() {
    switch (password.strength) {
      case PasswordStrength.strong:
        return 1;
      case PasswordStrength.medium:
        return 0.8;
      case PasswordStrength.weak:
        return 0.5;
      case PasswordStrength.veryWeak:
        return 0.2752;
    }
  }

  Widget renderIndicator(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 4,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: AppStyles.disabledColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              width: constraints.maxWidth * getWidthMultiplier(),
              decoration: BoxDecoration(
                color: getColor(),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget renderTitle() {
    return Text(
      getTitle(),
      style: AppStyles.passwordStrengthTextStyle(
        getColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (password.password.isEmpty) {
      return Container();
    }

    return Row(
      children: [
        Expanded(
          child: renderIndicator(context),
        ),
        Container(
          width: 62,
          margin: const EdgeInsets.only(left: 10),
          child: renderTitle(),
        )
      ],
    );
  }
}
