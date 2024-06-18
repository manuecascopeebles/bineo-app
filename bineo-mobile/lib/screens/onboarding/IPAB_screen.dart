import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/onboarding/create_password_screen.dart';
import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/images.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';

class IPABScreen extends StatelessWidget {
  const IPABScreen({super.key});

  Widget renderInfo() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: AppStrings.whoWeAre,
            style: AppStyles.heading4TextStyle,
          ),
          TextSpan(
            text: AppStrings.ipab,
            style: AppStyles.heading4TextStyle
                .copyWith(color: AppStyles.primaryColor),
          ),
          TextSpan(
            text: AppStrings.thatAssuresYourSavings,
            style: AppStyles.heading4TextStyle,
          ),
        ],
      ),
    );
  }

  void onContinue(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isScrollable: false,
      hideBackButton: true,
      submitButton: Column(
        children: [
          Text(
            AppStrings.valueApproximated,
            style: AppStyles.overline2TextStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: AppButton(
              title: AppStrings.continueString,
              onTap: () => onContinue(context),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.yourMoneyIsProtected,
                  style: AppStyles.heading2TextStyle,
                ),
                const SizedBox(height: 18),
                Text(
                  AppStrings.yourMoneyIsProtectedDescription,
                  style: AppStyles.heading4TextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                renderInfo()
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SVGs.getSVG(
                  svg: SVGs.banorte,
                ),
                Images.getImage(
                  image: Images.ipab,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
