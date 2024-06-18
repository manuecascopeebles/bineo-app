import 'dart:io';

import 'package:bineo/common/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppActivityIndicator extends StatelessWidget {
  const AppActivityIndicator({
    super.key,
    this.color = AppStyles.primaryColor,
    this.size = 10,
  });

  final Color color;
  final double size;

  Widget renderIndicator() {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        color: color,
        radius: size * 0.55,
      );
    }

    return CircularProgressIndicator(
      color: color,
      strokeWidth: 2.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: renderIndicator(),
    );
  }
}
