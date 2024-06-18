import 'package:bineo/common/app_strings.dart';

typedef _Validator = String? Function(String? inputText);
typedef _EqualityValidator = String? Function(
  String? inputText,
  String? equals,
);

class AppValidators {
  AppValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final RegExp _curpRegExp = RegExp(
    r'^[A-Z]{1}[AEIOUX]{1}[A-Z]{2}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[HM]{1}(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$',
  );

  static _Validator get requiredInput {
    return (String? text) {
      if (text == null || text.isEmpty) {
        return '';
      }

      return null;
    };
  }

  static _Validator get curpInput {
    return (String? text) {
      if (text == null || text.isEmpty) {
        return AppStrings.invalidCurpError;
      }

      if (!_curpRegExp.hasMatch(text)) {
        return AppStrings.invalidCurpError;
      }

      return null;
    };
  }

  static _Validator get emailInput {
    return (String? text) {
      if (text == null || text.isEmpty) {
        return '';
      }

      if (!_emailRegExp.hasMatch(text)) {
        return AppStrings.invalidEmailError;
      }

      return null;
    };
  }

  static _EqualityValidator get confirmationEmailInput {
    return (String? text, String? email) {
      if (text == null || text.isEmpty) {
        return '';
      }

      if (text != email) {
        return AppStrings.confirmationEmailError;
      }

      return null;
    };
  }

  static _EqualityValidator get confirmationPasswordInput {
    return (String? text, String? password) {
      if (text == null || text.isEmpty) {
        return '';
      }

      if (text != password) {
        return AppStrings.confirmationPasswordError;
      }

      return null;
    };
  }

  static _EqualityValidator get confirmationPasscodeInput {
    return (String? text, String? passcode) {
      if (text == null || text.isEmpty) {
        return '';
      }

      if (text != passcode) {
        return AppStrings.confirmationPasscodeError;
      }

      return null;
    };
  }
}
