import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.isScrollable = true,
    this.hideBackButton = false,
    this.body,
    this.submitButton,
    this.centerBody = false,
    this.topSpacing = 35,
    this.padding,
  });

  final bool isScrollable;
  final bool hideBackButton;
  final Widget? body;
  final Widget? submitButton;
  final bool centerBody;
  final double topSpacing;
  final EdgeInsetsGeometry? padding;

  Widget renderBody() {
    Widget bodyWidget = Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: body ?? Container(),
    );

    if (isScrollable) {
      bodyWidget = SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: bodyWidget,
      );
    }

    if (centerBody) {
      return Center(child: bodyWidget);
    } else {
      return bodyWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.surfaceColor,
      body: SafeArea(
        child: Container(
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: topSpacing,
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 15,
                  left: 15,
                  right: 20,
                ),
                child: hideBackButton || !Navigator.of(context).canPop()
                    ? Container()
                    : AppBackButton(),
              ),
              Expanded(
                child: renderBody(),
              ),
              if (submitButton != null)
                KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: isKeyboardVisible ? 0 : 20,
                        left: isKeyboardVisible ? 0 : 20,
                        right: isKeyboardVisible ? 0 : 20,
                        top: isScrollable ? 0 : 20,
                      ),
                      child: isKeyboardVisible ? Container() : submitButton!,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
