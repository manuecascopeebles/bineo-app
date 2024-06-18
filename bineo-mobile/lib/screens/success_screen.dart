import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_icon_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/images.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    required this.showCloseButton,
    required this.title,
    required this.description,
    this.subtitleStyle = AppStyles.digits2TextStyle,
    required this.onClose,
  });

  /// If this is true, there is a close button. If this is false, the screen is
  /// closed automatically after 1200 milliseconds
  final bool showCloseButton;
  final String title;
  final String description;
  final TextStyle subtitleStyle;
  final void Function() onClose;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    if (!widget.showCloseButton) {
      Future.delayed(
        const Duration(milliseconds: 1200),
        () {
          widget.onClose();
        },
      );
    }
  }

  Widget renderCloseButton() {
    return AppIconButton(
      onTap: widget.onClose,
      child: Icon(
        Icons.close,
        color: AppStyles.textHighEmphasisColor,
        size: 25,
      ),
    );
  }

  Widget renderBackgroundContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppStyles.borderRadius,
        gradient: AppStyles.darkBlackColorGradient,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 65,
            ),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppStyles.heading2TextStyle,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            child: Text(
              widget.description,
              textAlign: TextAlign.center,
              style: widget.subtitleStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      topSpacing: 0,
      isScrollable: false,
      hideBackButton: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 45,
              child: widget.showCloseButton ? renderCloseButton() : Container(),
            ),
          ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 90),
                child: renderBackgroundContainer(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: Offset(0, 35),
                  child: Images.getImage(
                    image: Images.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
