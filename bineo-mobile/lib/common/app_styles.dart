import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  // Colors:
  static const Color transparentColor = Colors.transparent;
  static const Color surfaceColor = Color.fromRGBO(27, 31, 34, 1);
  static const Color errorColor = Color.fromRGBO(255, 111, 102, 1);
  static const Color primaryColor = Color.fromRGBO(255, 130, 0, 1);
  static const Color disabledColor = Color.fromRGBO(76, 76, 76, 1);
  static const Color successColor = Color.fromRGBO(58, 170, 53, 1);
  static const Color bordersColor = Color.fromRGBO(102, 102, 102, 1);
  static const Color buttonLabelColor = Color.fromRGBO(85, 41, 0, 1);
  static const Color darkShadowColor = Color.fromRGBO(0, 0, 0, 0.25);
  static const Color darkDividerColor = Color.fromRGBO(12, 13, 14, 1);
  static const Color weakPasswordColor = Color.fromRGBO(255, 130, 0, 1);
  static const Color mediumPasswordColor = Color.fromRGBO(255, 222, 0, 1);
  static const Color lightPrimaryColor = Color.fromRGBO(255, 212, 166, 1);
  static const Color lightShadowColor = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color disabledTextColor = Color.fromRGBO(255, 255, 255, 0.4);
  static const Color strongPasswordColor = Color.fromRGBO(110, 211, 106, 1);
  static const Color veryWeakPasswordColor = Color.fromRGBO(231, 51, 12, 1);
  static const Color lightDividerColor = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color textHighEmphasisColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color customDialogBackgroundColor = Color.fromRGBO(1, 1, 1, 0.8);
  static const Color unselectedTabItemColor = Color.fromRGBO(187, 187, 187, 1);
  static const Color dropdownItemBackgroundColor =
      Color.fromRGBO(42, 45, 50, 1);
  static const Color textMediumEmphasisColor =
      Color.fromRGBO(255, 255, 255, 0.64);

  // Gradients:
  static const LinearGradient buttonColorGradient = LinearGradient(
    colors: [
      Color.fromRGBO(251, 151, 47, 1),
      Color.fromRGBO(255, 130, 0, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient blackColorGradient = LinearGradient(
    colors: [
      Color.fromRGBO(42, 45, 50, 1),
      Color.fromRGBO(35, 38, 42, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient darkBlackColorGradient = LinearGradient(
    colors: [
      Color.fromRGBO(35, 38, 40, 1),
      Color.fromRGBO(31, 34, 35, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient productCardBorderGradient = LinearGradient(
    colors: [
      Color.fromRGBO(255, 130, 0, 0.6),
      Color.fromRGBO(255, 130, 0, 0),
      Color.fromRGBO(255, 130, 0, 0),
    ],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  // Text styles:
  static const TextStyle heading1TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 32,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle digits1TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 32,
    fontFamily: 'OpenSans',
    height: 40 / 32,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle heading2TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 24,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  );
  static const TextStyle heading3TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 24,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
    height: 32 / 24,
  );
  static const TextStyle codeTextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 24,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle disabledCodeTextStyle = TextStyle(
    color: disabledTextColor,
    fontSize: 24,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle digits2TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 24,
    fontFamily: 'OpenSans',
    height: 32 / 24,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle cents1Style = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 19,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle heading4TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
    height: 24 / 16,
  );
  static const TextStyle heading5PrimaryTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
    height: 0.9,
  );
  static const TextStyle diabledInputTextStyle = TextStyle(
    color: disabledTextColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle primaryButtonLabelTextStyle = TextStyle(
    color: buttonLabelColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );
  static const TextStyle disabledPrimaryButtonLabelTextStyle = TextStyle(
    color: surfaceColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );
  static const TextStyle secondaryDarkButtonLabelTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );
  static const TextStyle secondaryDarkDisabledButtonLabelTextStyle = TextStyle(
    color: disabledColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );
  static const TextStyle secondaryLightButtonLabelTextStyle = TextStyle(
    color: lightPrimaryColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );
  static const TextStyle body1TextStyle = heading4TextStyle;
  static const TextStyle heading5TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  );
  static const TextStyle spanTextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 16,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );
  static TextStyle accountTitleTextStyle({
    bool isBold = false,
    bool isItalic = false,
  }) {
    return TextStyle(
      color: primaryColor,
      fontSize: 16,
      fontFamily: 'OpenSans',
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
    );
  }

  static const TextStyle body2HighEmphasisTextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle caption1TextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  );
  static const TextStyle body2MediumEmphasisTextStyle = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle body2PrimaryTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle body2BoldPrimaryTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  );
  static const TextStyle subtitleTextStyle = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle inputLabelTextStyle = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 14,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  );
  static TextStyle smallButtonTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w600,
    );
  }

  static const TextStyle body3TextStyle = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 13,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static TextStyle passwordStrengthTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 13,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.normal,
    );
  }

  static const TextStyle overline1HighEmphasisTextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 12,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle inputErrorTextStyle = TextStyle(
    color: errorColor,
    fontSize: 12,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
    height: 1.1,
  );
  static const TextStyle overline1TextStyle = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 12,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle overline2TextStyle = TextStyle(
    color: textMediumEmphasisColor,
    fontSize: 11,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
    height: 12 / 11,
  );
  static const TextStyle selectedTabLabelTextStyle = TextStyle(
    color: textHighEmphasisColor,
    fontSize: 10,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );
  static const TextStyle unselectedTabLabelTextStyle = TextStyle(
    color: unselectedTabItemColor,
    fontSize: 10,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.normal,
  );

  // Border:
  static BorderRadius borderRadius = BorderRadius.circular(8);
  static BorderRadius checkboxBorderRadius = BorderRadius.circular(5);
  static BorderRadius smallButtonRadius = BorderRadius.circular(4);
}
