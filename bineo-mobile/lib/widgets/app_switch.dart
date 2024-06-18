import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.text,
    required this.onChanged,
  });

  final bool value;
  final String text;
  final void Function(bool) onChanged;

  WidgetStateProperty<Icon> renderThumb() {
    return WidgetStatePropertyAll(
      Icon(
        Icons.circle,
        color: AppStyles.textHighEmphasisColor,
      ),
    );
  }

  Widget renderText() {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: AppStyles.body3TextStyle,
    );
  }

  Widget renderSwitch() {
    return Container(
      height: 32,
      child: Switch(
        value: value,
        activeTrackColor: AppStyles.primaryColor,
        activeColor: AppStyles.textHighEmphasisColor,
        inactiveThumbColor: AppStyles.textHighEmphasisColor,
        inactiveTrackColor: AppStyles.disabledColor,
        trackOutlineWidth: WidgetStatePropertyAll(0),
        thumbIcon: renderThumb(),
        activeThumbImage: null,
        inactiveThumbImage: null,
        trackOutlineColor: WidgetStatePropertyAll(
          AppStyles.transparentColor,
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: renderText(),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: renderSwitch(),
        ),
      ],
    );
  }
}
