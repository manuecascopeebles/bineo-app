extension FormattedAmounts on double {
  String get decimalString {
    String string = '$this'.split('.').last;

    if (string.length == 0) {
      return '00';
    } else if (string.length == 1) {
      return '${string}0';
    } else {
      return string.substring(0, 2);
    }
  }

  String get mainString {
    int counter = 0;
    String string = '$this'.split('.').first;
    String returnString = '';

    for (int i = string.length - 1; i >= 0; i--) {
      if (returnString.length > 0 && counter == 3) {
        counter = 0;
        returnString = '.$returnString';
      }

      returnString = '${string[i]}$returnString';
      counter++;
    }

    return returnString;
  }
}
