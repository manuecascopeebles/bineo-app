import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';

class CustomAppDialog extends StatefulWidget {
  CustomAppDialog(
    BuildContext context, {
    super.key,
    this.icon,
    this.messageWidget,
    this.title,
    this.message,
    this.defaultCloseActionTitle,
    this.showDefaultCloseAction = false,
    this.buttons,
  });

  final Widget? icon;
  final Widget? messageWidget;
  final String? title;
  final String? message;
  final String? defaultCloseActionTitle;
  final bool showDefaultCloseAction;
  final List<CustomAppDialogAction>? buttons;

  @override
  State<CustomAppDialog> createState() => _CustomAppDialogState();
}

class _CustomAppDialogState extends State<CustomAppDialog> {
  List<CustomAppDialogAction> buttons = [];

  @override
  initState() {
    super.initState();

    buttons = [...?widget.buttons];

    if (widget.showDefaultCloseAction) {
      buttons.insert(
        0,
        CustomAppDialogAction(
          title: widget.defaultCloseActionTitle ?? AppStrings.close,
          type: CustomAppDialogActionType.secondary,
          onTap: Navigator.of(context).pop,
        ),
      );
    }
  }

  Widget renderMessage() {
    if (widget.messageWidget != null) return widget.messageWidget!;

    return Text(
      '${widget.message}',
      style: AppStyles.heading4TextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget renderButton(CustomAppDialogAction button) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: button.type == CustomAppDialogActionType.primary
            ? null
            : AppStyles.transparentColor,
        gradient: button.type == CustomAppDialogActionType.primary
            ? AppStyles.buttonColorGradient
            : null,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(32),
        color: AppStyles.transparentColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: button.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 13,
            ),
            child: Text(
              button.title,
              style: AppStyles.smallButtonTextStyle(
                button.type == CustomAppDialogActionType.primary
                    ? AppStyles.buttonLabelColor
                    : AppStyles.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> renderButtons() {
    bool isFirstButton = false;
    List<Widget> buttonWidgets = [];

    for (CustomAppDialogAction button in buttons) {
      buttonWidgets.add(
        Container(
          margin: EdgeInsets.only(
            top: isFirstButton ? 0 : 15,
          ),
          child: renderButton(button),
        ),
      );

      isFirstButton = false;
    }

    return buttonWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppStyles.borderRadius,
        gradient: AppStyles.darkBlackColorGradient,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.icon != null) widget.icon!,
            if (widget.title != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  widget.title!,
                  style: AppStyles.heading2TextStyle,
                ),
              ),
            if (widget.message != null || widget.messageWidget != null)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: renderMessage(),
              ),
            ...renderButtons(),
          ],
        ),
      ),
    );
  }
}

class CustomAppDialogAction {
  final String title;
  final CustomAppDialogActionType type;
  final void Function() onTap;

  CustomAppDialogAction({
    required this.title,
    this.type = CustomAppDialogActionType.primary,
    required this.onTap,
  });
}

enum CustomAppDialogActionType {
  primary,
  secondary;
}
