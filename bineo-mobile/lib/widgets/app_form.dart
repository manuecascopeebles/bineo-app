import 'package:bineo/widgets/app_button.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  AppForm({
    super.key,
    this.hideBackButton = true,
    this.hasFloatingButton = true,
    this.formKey,
    required this.children,
    required this.submitButton,
    this.topWidget,
    this.padding,
    this.validateOnRender = false,
  });

  final bool hideBackButton;
  final bool hasFloatingButton;
  final GlobalKey<FormState>? formKey;
  final AppButton submitButton;
  final EdgeInsets? padding;
  final bool validateOnRender;

  /// All inputs for the form go here. They will be validated automatically
  /// when the form is submitted
  final List<Widget> children;
  final Widget? topWidget;

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  bool enabled = false;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    formKey = widget.formKey ?? GlobalKey<FormState>();

    if (widget.validateOnRender) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        validateForm();
      });
    }
  }

  Widget renderButton() {
    return widget.submitButton.copyWith(
      enabled: widget.submitButton.enabled && enabled,
    );
  }

  Widget renderContent() {
    List<Widget> children = [...widget.children];

    if (!widget.hasFloatingButton) {
      children.add(renderButton());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  void validateForm() {
    bool isValid = formKey.currentState!.validate();

    if (isValid != enabled) {
      setState(() {
        enabled = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: widget.padding,
      hideBackButton: widget.hideBackButton,
      submitButton: widget.hasFloatingButton ? renderButton() : null,
      body: Column(
        children: [
          if (widget.topWidget != null) widget.topWidget!,
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: validateForm,
            child: renderContent(),
          ),
        ],
      ),
    );
  }
}
