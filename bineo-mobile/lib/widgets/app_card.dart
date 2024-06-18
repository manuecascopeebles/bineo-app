import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.minHeight = 175,
    this.border,
    this.onTap,
  });

  final Widget child;
  final double minHeight;
  final BoxBorder? border;
  final void Function()? onTap;

  BoxDecoration getDecoration() {
    return BoxDecoration(
      gradient: AppStyles.blackColorGradient,
      borderRadius: AppStyles.borderRadius,
      boxShadow: [
        BoxShadow(
          color: AppStyles.darkShadowColor,
          blurRadius: 16,
          blurStyle: BlurStyle.outer,
        ),
        BoxShadow(
          color: AppStyles.lightShadowColor,
          blurRadius: 2,
          blurStyle: BlurStyle.inner,
        ),
      ],
      border: border,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: Container(
        decoration: getDecoration(),
        child: Material(
          borderRadius: AppStyles.borderRadius,
          color: AppStyles.transparentColor,
          child: InkWell(
            borderRadius: AppStyles.borderRadius,
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
