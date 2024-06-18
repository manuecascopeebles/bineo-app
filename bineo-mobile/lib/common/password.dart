class Password {
  Password(
    this.password, {
    required this.name,
    required this.clientNumber,
  });

  String password;
  final String name;
  final int clientNumber;

  bool get hasValidLength => password.length >= 8 && password.length <= 12;

  bool get hasNumber => password.contains(RegExp(r'[0-9]'));

  bool get hasSymbol => password.contains(RegExp(r'[^a-zA-Z0-9]'));

  bool get hasLowercaseLetter => password.contains(RegExp(r'[a-z]'));

  bool get hasUppercaseLetter => password.contains(RegExp(r'[A-Z]'));

  bool get has3ConsecutiveEqualCharacters =>
      password.contains(RegExp(r'(.)\1\1'));

  bool get has3ConsecutiveNumbers =>
      password.contains(RegExp(r'(012|123|234|345|456|567|678|789)'));

  bool get has3ConsecutiveLowercaseLetters => password.contains(RegExp(
      r'(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mnñ|nño|ñop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)'));

  bool get has3ConsecutiveUppercaseLetters => password.contains(RegExp(
      r'(ABC|BCD|CDE|DEF|EFG|FGH|GHI|HIJ|IJK|JKL|KLM|LMN|MNÑ|NÑO|ÑOP|OPQ|PQR|QRS|RST|STU|TUV|UVW|VWX|WXY|XYZ)'));

  bool get hasBineoString => password.toLowerCase().contains('bineo');

  bool get hasName => password.toLowerCase().contains(name.toLowerCase());

  bool get hasClientNumber => password.contains('$clientNumber');

  bool get isValid =>
      hasValidLength &&
      hasNumber &&
      hasSymbol &&
      hasLowercaseLetter &&
      hasUppercaseLetter &&
      !has3ConsecutiveEqualCharacters &&
      !has3ConsecutiveNumbers &&
      !has3ConsecutiveLowercaseLetters &&
      !has3ConsecutiveUppercaseLetters &&
      !hasBineoString &&
      !hasName &&
      !hasClientNumber;

  PasswordStrength get strength {
    int strengthCounter = 0;

    if (hasValidLength) strengthCounter++;
    if (hasNumber && hasSymbol) strengthCounter++;
    if (hasLowercaseLetter && hasUppercaseLetter) strengthCounter++;
    if (!has3ConsecutiveEqualCharacters &&
        !has3ConsecutiveNumbers &&
        !has3ConsecutiveLowercaseLetters &&
        !has3ConsecutiveUppercaseLetters) strengthCounter++;
    if (!hasBineoString && !hasName && !hasClientNumber) strengthCounter++;

    switch (strengthCounter) {
      case 0:
      case 1:
        return PasswordStrength.veryWeak;
      case 2:
      case 3:
        return PasswordStrength.weak;
      case 4:
        return PasswordStrength.medium;
      case 5:
        return PasswordStrength.strong;
      default:
        return PasswordStrength.veryWeak;
    }
  }
}

enum PasswordStrength {
  strong,
  medium,
  weak,
  veryWeak;
}
