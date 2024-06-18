import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_card.dart';
import 'package:bineo/widgets/app_radio.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.isSelected,
    this.showBanner = false,
    this.subtitle,
    required this.title,
    this.features = const [],
    required this.onToggleSelection,
  });

  final bool isSelected;
  final bool showBanner;
  final String? subtitle;
  final AccountCardTitle title;
  final List<AccountCardFeature> features;
  final void Function(bool) onToggleSelection;

  Widget renderBanner() {
    return SizedBox(
      height: 24,
      width: 22,
      child: Stack(
        children: [
          SVGs.getSVG(
            svg: SVGs.bannerBackground,
          ),
          Align(
            alignment: Alignment(0, -0.6),
            child: SVGs.getSVG(
              svg: SVGs.bannerStar,
              width: 14.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderRadio() {
    return AppRadio(
      isSelected: isSelected,
      onChanged: (bool) => onToggleSelection(bool),
    );
  }

  Widget renderTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${AppStrings.bineoAccount} ',
            style: AppStyles.heading5TextStyle,
          ),
          TextSpan(
            text: title.title,
            style: AppStyles.accountTitleTextStyle(
              isBold: title.isBold,
              isItalic: title.isItalic,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDivider(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Column(
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppStyles.darkDividerColor,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppStyles.lightDividerColor,
          ),
        ],
      ),
    );
  }

  Widget renderFeature(AccountCardFeature feature) {
    List<TextSpan> textSpans = [];

    textSpans.add(
      TextSpan(
        text: '•  ${feature.featureText}',
        style: AppStyles.body2HighEmphasisTextStyle,
      ),
    );

    if (feature.boldFeatureText != null) {
      textSpans.add(
        TextSpan(
          text: feature.boldFeatureText,
          style: AppStyles.spanTextStyle,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  Widget renderFeatures() {
    List<Widget> featureWidgets = [];

    for (AccountCardFeature feature in features) {
      featureWidgets.add(
        renderFeature(feature),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: featureWidgets,
    );
  }

  Widget renderSubtitle() {
    return Text(
      subtitle ?? '',
      style: AppStyles.body3TextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 21,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: renderRadio(),
                    ),
                    renderTitle(),
                  ],
                ),
              ),
              if (showBanner)
                Container(
                  margin: const EdgeInsets.only(right: 28),
                  child: renderBanner(),
                ),
            ],
          ),
          renderDivider(context),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 17,
              horizontal: 21,
            ),
            child: renderFeatures(),
          ),
          if (subtitle != null)
            Container(
              margin: const EdgeInsets.only(
                right: 21,
                left: 21,
                bottom: 17,
              ),
              child: renderSubtitle(),
            ),
        ],
      ),
    );
  }
}

class AccountCardTitle {
  final String title;
  final bool isBold;
  final bool isItalic;

  AccountCardTitle({
    required this.title,
    this.isBold = false,
    this.isItalic = false,
  });
}

class AccountCardFeature {
  final String featureText;
  final String? boldFeatureText;

  AccountCardFeature({
    required this.featureText,
    this.boldFeatureText,
  });
}
