import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.enabled = true,
    this.isLoading = false,
    this.expandWidth = true,
    this.topWidget,
    this.padding,
    required this.title,
    this.style = AppButtonStyle.primary,
    required this.onTap,
  });

  final bool enabled;
  final bool isLoading;
  final bool expandWidth;
  final Widget? topWidget;
  final EdgeInsetsGeometry? padding;
  final String title;
  final AppButtonStyle style;
  final void Function() onTap;

  AppButton copyWith({
    Key? key,
    bool? enabled,
    bool? isLoading,
    bool? expandWidth,
    Widget? topWidget,
    EdgeInsetsGeometry? padding,
    String? title,
    AppButtonStyle? style,
    void Function()? onTap,
  }) {
    return AppButton(
      key: key ?? this.key,
      enabled: enabled ?? this.enabled,
      isLoading: isLoading ?? this.isLoading,
      expandWidth: expandWidth ?? this.expandWidth,
      topWidget: topWidget ?? this.topWidget,
      padding: padding ?? this.padding,
      title: title ?? this.title,
      style: style ?? this.style,
      onTap: onTap ?? this.onTap,
    );
  }

  BoxDecoration getButtonDecoration() {
    switch (style) {
      case AppButtonStyle.primary:
        return BoxDecoration(
          color: enabled && !isLoading ? null : AppStyles.disabledColor,
          gradient:
              enabled && !isLoading ? AppStyles.buttonColorGradient : null,
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
        );
      case AppButtonStyle.secondaryDark:
      case AppButtonStyle.secondaryLight:
        return BoxDecoration(
          color: AppStyles.transparentColor,
          borderRadius: AppStyles.borderRadius,
        );
    }
  }

  TextStyle getButtonTextStyle() {
    switch (style) {
      case AppButtonStyle.primary:
        if (enabled) {
          return AppStyles.primaryButtonLabelTextStyle;
        } else {
          return AppStyles.disabledPrimaryButtonLabelTextStyle;
        }
      case AppButtonStyle.secondaryDark:
        if (enabled) {
          return AppStyles.secondaryDarkButtonLabelTextStyle;
        } else {
          return AppStyles.secondaryDarkDisabledButtonLabelTextStyle;
        }
      case AppButtonStyle.secondaryLight:
        return AppStyles.secondaryLightButtonLabelTextStyle;
    }
  }

  Color getLoaderColor() {
    switch (style) {
      case AppButtonStyle.primary:
        return AppStyles.surfaceColor;
      case AppButtonStyle.secondaryDark:
        return AppStyles.primaryColor;
      case AppButtonStyle.secondaryLight:
        return AppStyles.lightPrimaryColor;
    }
  }

  Widget renderButtonContent() {
    if (isLoading) {
      return AppActivityIndicator(
        size: 23,
        color: getLoaderColor(),
      );
    }

    return Text(
      title,
      style: getButtonTextStyle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (topWidget != null) topWidget!,
        Container(
          width: expandWidth ? MediaQuery.of(context).size.width : null,
          decoration: getButtonDecoration(),
          child: Material(
            color: AppStyles.transparentColor,
            borderRadius: AppStyles.borderRadius,
            child: InkWell(
              borderRadius: AppStyles.borderRadius,
              onTap: enabled && !isLoading ? onTap : null,
              child: Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Center(
                  child: renderButtonContent(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum AppButtonStyle {
  /// A button with a [AppStyles.buttonColorGradient] background and a [AppStyles.primaryButtonLabelTextStyle] text style
  primary,

  /// A button with a [AppStyles.transparentColor] background and a [AppStyles.secondaryDarkButtonLabelTextStyle] text style
  secondaryDark,

  /// A button with a [AppStyles.transparentColor] background and a [AppStyles.secondaryLightButtonLabelTextStyle] text style
  secondaryLight;
}
