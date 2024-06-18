import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGs {
  SVGs._();

  static Widget getSVG({
    required String svg,
    double? width,
    Color? color,
  }) {
    return SvgPicture.asset(
      svg,
      width: width,
      color: color,
    );
  }

  static const String card = 'assets/svgs/card.svg';
  static const String close = 'assets/svgs/close.svg';
  static const String ineId = 'assets/svgs/ine-id.svg';
  static const String faceId = 'assets/svgs/face-id.svg';
  static const String success = 'assets/svgs/success.svg';
  static const String banorte = 'assets/svgs/banorte.svg';
  static const String logo = 'assets/svgs/logo-bineo.svg';
  static const String homeTab = 'assets/svgs/home-tab.svg';
  static const String cardsTab = 'assets/svgs/cards-tab.svg';
  static const String bannerStar = 'assets/svgs/banner-star.svg';
  static const String mexicoFlag = 'assets/svgs/mexico_flag.svg';
  static const String personalTab = 'assets/svgs/personal-tab.svg';
  static const String pocketsIcon = 'assets/svgs/pockets-icon.svg';
  static const String transfersTab = 'assets/svgs/transfers-tab.svg';
  static const String homeBackground = 'assets/svgs/home-background.svg';
  static const String smallBineoIcon = 'assets/svgs/small-bineo-icon.svg';
  static const String bannerBackground = 'assets/svgs/banner-background.svg';
  static const String notificationsIcon = 'assets/svgs/notifications-icon.svg';
}
