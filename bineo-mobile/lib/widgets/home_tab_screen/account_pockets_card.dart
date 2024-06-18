import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/gradient_box_border.dart';
import 'package:bineo/widgets/app_card.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';

class AccountPocketsCard extends StatelessWidget {
  const AccountPocketsCard({
    super.key,
    required this.hasPockets,
    required this.onTapPocketsCard,
  });

  final bool hasPockets;
  final void Function() onTapPocketsCard;

  Widget renderContent() {
    if (hasPockets) {
      // TODO implement UI
    }

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: SVGs.getSVG(
            svg: SVGs.pocketsIcon,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: Text(
                  AppStrings.youHaveNoPockets,
                  style: AppStyles.caption1TextStyle,
                ),
              ),
              Text(
                AppStrings.createAPocket,
                style: AppStyles.overline1TextStyle,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      minHeight: 0,
      border: GradientBoxBorder(
        gradient: AppStyles.productCardBorderGradient,
        width: 1,
      ),
      onTap: onTapPocketsCard,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: renderContent(),
      ),
    );
  }
}
