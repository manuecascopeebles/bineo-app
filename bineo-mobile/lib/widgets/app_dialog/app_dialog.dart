import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_dialog/custom_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:native_dialog_plus/native_dialog_plus.dart';
import 'package:permission_handler/permission_handler.dart';
export 'package:native_dialog_plus/native_dialog_plus.dart'
    show
        NativeDialogPlusAction,
        NativeDialogPlusStyle,
        NativeDialogPlusActionStyle;

class AppDialog {
  AppDialog._();

  static Future<void> showMessage(
    String? title,
    String? message,
    List<NativeDialogPlusAction> buttons,
  ) async {
    await NativeDialogPlus(
      title: title != null ? title : null,
      message: message,
      actions: buttons,
    ).show();
  }

  static Future<void> showOpenSettingsDialog(
    String title,
    String description,
  ) async {
    await AppDialog.showMessage(
      title,
      description,
      [
        NativeDialogPlusAction(
          text: AppStrings.permissionSettingsDialogButton,
          onPressed: () async {
            await openAppSettings();
          },
        ),
      ],
    );
  }

  static Future<void> showCustomMessage(
    BuildContext context, {
    Widget? icon,
    Widget? messageWidget,
    String? title,
    String? message,
    String? defaultCloseActionTitle,
    bool showDefaultCloseAction = false,
    List<CustomAppDialogAction>? buttons,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppStyles.customDialogBackgroundColor,
      useSafeArea: false,
      builder: (_) {
        return Dialog(
          backgroundColor: AppStyles.customDialogBackgroundColor,
          insetPadding: EdgeInsets.all(30),
          child: CustomAppDialog(
            context,
            icon: icon,
            messageWidget: messageWidget,
            title: title,
            message: message,
            defaultCloseActionTitle: defaultCloseActionTitle,
            showDefaultCloseAction: showDefaultCloseAction,
            buttons: buttons,
          ),
        );
      },
    );
  }
}
