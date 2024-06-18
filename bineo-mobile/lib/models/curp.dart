class Curp {
  final String value;
  DateTime get date {
    if (value.length < 18) return DateTime.now();

    String year = value.substring(4, 6);
    String month = value.substring(6, 8);
    String day = value.substring(8, 10);

    int intYear = int.parse(year);
    int intMonth = int.parse(month);
    int intDay = int.parse(day);

    // Determinar el siglo a partir del primer carácter del CURP
    if (value[16].toUpperCase() == '0' || value[16].toUpperCase() == '1') {
      // Siglo 20 (1900s)
      intYear += 1900;
    } else {
      // Siglo 21 (2000s)
      intYear += 2000;
    }

    return DateTime(intYear, intMonth, intDay);
  }

  String get dateString {
    if (value.length < 18) return '';

    String year = value.substring(4, 6);
    String month = value.substring(6, 8);
    String day = value.substring(8, 10);

    int intYear = int.parse(year);
    // Determinar el siglo a partir del primer carácter del CURP
    if (value[16].toUpperCase() == '0' || value[16].toUpperCase() == '1') {
      // Siglo 20 (1900s)
      intYear += 1900;
    } else {
      // Siglo 21 (2000s)
      intYear += 2000;
    }

    return '${day}/${month}/${intYear}';
  }

  String get birthEntity {
    if (value.length < 18) return '';

    return value.substring(11, 13).toUpperCase();
  }

  String get gender {
    if (value.length < 18) return '';

    return value.substring(10, 11).toUpperCase();
  }

  bool get isForeigner {
    return birthEntity == 'NE';
  }

  const Curp(this.value);
}
