import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.text,
    this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String text;
  final String? subtitle;
  final void Function(bool) onChanged;

  Widget renderCheckbox() {
    return Transform.scale(
      scale: 1.3,
      child: Checkbox(
        value: value,
        activeColor: AppStyles.primaryColor,
        checkColor: AppStyles.textHighEmphasisColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.checkboxBorderRadius,
        ),
        side: BorderSide(
          color:
              value ? AppStyles.primaryColor : AppStyles.textHighEmphasisColor,
          width: 1,
        ),
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (newValue) {
          onChanged(newValue ?? !value);
        },
      ),
    );
  }

  Widget renderText() {
    return Text(
      text,
      style: AppStyles.body2HighEmphasisTextStyle,
    );
  }

  Widget renderSubtitle() {
    return Text(
      subtitle ?? '',
      style: AppStyles.overline1TextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: renderCheckbox(),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: AppStyles.borderRadius,
                  onTap: () {
                    onChanged(!value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: renderText(),
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: renderSubtitle(),
            ),
        ],
      ),
    );
  }
}
