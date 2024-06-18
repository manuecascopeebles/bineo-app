import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/onboarding/ine/ine_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/onboarding/account_card.dart';
import 'package:flutter/material.dart';

class AccountsMenuScreen extends StatefulWidget {
  const AccountsMenuScreen({super.key});

  @override
  State<AccountsMenuScreen> createState() => _AccountsMenuScreenState();
}

class _AccountsMenuScreenState extends State<AccountsMenuScreen> {
  bool totalAccountSelected = false;

  void continueOnboarding() {
    if (totalAccountSelected) {
      // TODO go to total account flow
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const INEScreen()),
      );
    }
  }

  Widget renderTitle() {
    return Text(
      AppStrings.chooseYourAccount,
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderSubtitle() {
    return Text(
      AppStrings.accountChoicesDescription,
      style: AppStyles.body2MediumEmphasisTextStyle,
    );
  }

  Widget renderAccountCards() {
    return Column(
      children: [
        AccountCard(
          showBanner: true,
          isSelected: totalAccountSelected,
          title: AccountCardTitle(
            title: AppStrings.total,
            isBold: true,
          ),
          features: [
            AccountCardFeature(
              featureText: '${AppStrings.monthlyDeposits} ',
              boldFeatureText: AppStrings.unlimited,
            ),
            AccountCardFeature(
              featureText: AppStrings.getItIn9Minutes,
            ),
          ],
          subtitle: AppStrings.ineRequiresStreetAndNumber,
          onToggleSelection: (_) {
            setState(() {
              totalAccountSelected = true;
            });
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: AccountCard(
            isSelected: !totalAccountSelected,
            title: AccountCardTitle(
              title: AppStrings.light,
              isItalic: true,
            ),
            features: [
              AccountCardFeature(
                featureText: '${AppStrings.getItIn} ',
                boldFeatureText: AppStrings.fourMinutes,
              ),
              AccountCardFeature(
                featureText: AppStrings.max23000Deposits,
              ),
            ],
            subtitle: AppStrings.ammountEquivalentTo3000Udis,
            onToggleSelection: (_) {
              setState(() {
                totalAccountSelected = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget renderButton() {
    return AppButton(
      title: AppStrings.continueString,
      onTap: continueOnboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          renderTitle(),
          Container(
            margin: const EdgeInsets.only(
              top: 8,
              bottom: 20,
            ),
            child: renderSubtitle(),
          ),
          renderAccountCards(),
        ],
      ),
      submitButton: renderButton(),
    );
  }
}
