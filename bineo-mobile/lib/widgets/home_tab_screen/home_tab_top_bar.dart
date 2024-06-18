import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_icon_button.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';

class HomeTabTopBar extends StatelessWidget {
  const HomeTabTopBar({
    super.key,
    required this.username,
    required this.hasNotifications,
    required this.hideAccountNumber,
    required this.onTapBineoIcon,
    required this.onTapProfileIcon,
    required this.onTapNotificationsIcon,
    required this.onToggleHideAccountNumber,
  });

  final String username;
  final bool hasNotifications;
  final bool hideAccountNumber;
  final void Function() onTapBineoIcon;
  final void Function() onTapProfileIcon;
  final void Function() onTapNotificationsIcon;
  final void Function() onToggleHideAccountNumber;

  Widget renderProfileIcon() {
    return AppIconButton(
      padding: 12,
      backgroundColor: AppStyles.textMediumEmphasisColor,
      onTap: onTapProfileIcon,
      child: Text(
        username[0].toUpperCase(),
        style: AppStyles.heading5PrimaryTextStyle,
      ),
    );
  }

  Widget renderNotificationsIcon() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AppIconButton(
          onTap: onTapNotificationsIcon,
          child: SVGs.getSVG(
            svg: SVGs.notificationsIcon,
            width: 19,
            color: AppStyles.textHighEmphasisColor,
          ),
        ),
        if (hasNotifications)
          Transform.translate(
            offset: Offset(-7, 9),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyles.mediumPasswordColor,
              ),
              height: 10,
              width: 10,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        renderProfileIcon(),
        Row(
          children: [
            AppIconButton(
              onTap: onToggleHideAccountNumber,
              child: Icon(
                hideAccountNumber
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_sharp,
                color: AppStyles.textHighEmphasisColor,
                size: 24,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: renderNotificationsIcon(),
            ),
            AppIconButton(
              onTap: onTapBineoIcon,
              child: SVGs.getSVG(
                svg: SVGs.smallBineoIcon,
                width: 19,
                color: AppStyles.textHighEmphasisColor,
              ),
            ),
          ],
        )
      ],
    );
  }
}
