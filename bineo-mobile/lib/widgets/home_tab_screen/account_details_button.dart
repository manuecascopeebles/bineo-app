import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccountDetailsButton extends StatelessWidget {
  const AccountDetailsButton({
    super.key,
    required this.isLoading,
    required this.accountBalance,
    required this.accountNumber,
    required this.hideAccountNumber,
    required this.onTapAccountDetails,
  });

  final bool isLoading;
  final double accountBalance;
  final String accountNumber;
  final bool hideAccountNumber;
  final void Function() onTapAccountDetails;

  Widget renderSeeMoreIcon() {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.textMediumEmphasisColor.withOpacity(0.25),
        borderRadius: AppStyles.borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          Icons.play_arrow_rounded,
          color: AppStyles.textMediumEmphasisColor,
          size: 15,
        ),
      ),
    );
  }

  Widget renderAccountBalance() {
    return Row(
      children: [
        Text(
          '\$ ${accountBalance.mainString}',
          style: AppStyles.digits1TextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Text(
            '.${accountBalance.decimalString}',
            style: AppStyles.cents1Style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            right: 10,
            left: 20,
          ),
          child: renderSeeMoreIcon(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AccountDetailsSkeleton();
    }
    return Material(
      borderRadius: AppStyles.borderRadius,
      color: AppStyles.transparentColor,
      child: InkWell(
        borderRadius: AppStyles.borderRadius,
        onTap: onTapAccountDetails,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.bineoAccountNumber(
                  accountNumber,
                  isHidden: hideAccountNumber,
                ),
                style: AppStyles.caption1TextStyle,
              ),
              Container(
                margin: const EdgeInsets.only(top: 3),
                child: renderAccountBalance(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountDetailsSkeleton extends StatelessWidget {
  const AccountDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        child: InkWell(
          borderRadius: AppStyles.borderRadius,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.bineoAccountNumber('0', isHidden: false),
                  style: AppStyles.caption1TextStyle,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: Row(
                    children: [
                      Text(
                        '\$ ${500000.0.mainString}',
                        style: AppStyles.digits1TextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 20),
                        height: 15,
                        width: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppStyles.textMediumEmphasisColor
                                .withOpacity(0.25),
                            borderRadius: AppStyles.borderRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: AppStyles.textMediumEmphasisColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
