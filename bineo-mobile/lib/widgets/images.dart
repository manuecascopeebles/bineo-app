import 'package:flutter/material.dart';

class Images {
  Images._();

  static Widget getImage({
    required String image,
    double? width,
    Color? color,
  }) {
    return Image.asset(
      image,
      width: width,
      color: color,
    );
  }

  static const String ineId = 'assets/images/ine-id.png';
  static const String success = 'assets/images/success.png';
  static const String bineoLoan = 'assets/images/bineo-loan.png';
  static const String ineIdPerson = 'assets/images/ine-id-person.png';
  static const String bineoAccount = 'assets/images/bineo-account.png';
  static const String ineAddressData = 'assets/images/ine-address-data.png';
  static const String inePersonalData = 'assets/images/ine-personal-data.png';
  static const String bineoCreditCard = 'assets/images/bineo-credit-card.png';
  static const String ipab = 'assets/images/ipab.png';
  static const String congratulations = 'assets/images/congratulations.png';
}
