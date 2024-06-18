import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppStyles.transparentColor,
      borderRadius: AppStyles.borderRadius,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: AppStyles.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: const Icon(
            Icons.arrow_back,
            color: AppStyles.textHighEmphasisColor,
          ),
        ),
      ),
    );
  }
}
