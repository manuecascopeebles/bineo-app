import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class TransfersTabScreen extends StatelessWidget {
  const TransfersTabScreen({
    super.key,
    required this.globalNavigator,
  });

  /// Use this to navigate on top of the bottom bar. Use it instead of Navigator.of(context)
  final NavigatorState globalNavigator;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideBackButton: true,
      body: Text(
        'TransfersTabScreen',
        style: AppStyles.heading1TextStyle,
      ),
    );
  }
}
