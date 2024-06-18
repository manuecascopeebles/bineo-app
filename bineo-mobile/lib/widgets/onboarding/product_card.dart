import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/common/gradient_box_border.dart';
import 'package:bineo/widgets/app_card.dart';
import 'package:bineo/widgets/images.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final String description;
  final String imagePath;
  final void Function() onTap;

  BoxBorder getBorder() {
    return GradientBoxBorder(
      gradient: AppStyles.productCardBorderGradient,
      width: 1,
    );
  }

  Widget renderTitle() {
    return Text(
      title,
      style: AppStyles.heading5TextStyle,
    );
  }

  Widget renderDescription() {
    return Text(
      description,
      style: AppStyles.body3TextStyle,
    );
  }

  Widget renderSeeMore() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: Text(
            AppStrings.seeMore,
            style: AppStyles.body2BoldPrimaryTextStyle,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppStyles.disabledColor,
            borderRadius: AppStyles.smallButtonRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppStyles.textMediumEmphasisColor,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget renderSvg() {
    return Images.getImage(
      image: imagePath,
      width: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      border: getBorder(),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 22,
                bottom: 22,
                left: 22,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        renderTitle(),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: renderDescription(),
                        ),
                      ],
                    ),
                  ),
                  renderSeeMore(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 17,
              top: 10,
              bottom: 10,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: renderSvg(),
            ),
          ),
        ],
      ),
    );
  }
}
