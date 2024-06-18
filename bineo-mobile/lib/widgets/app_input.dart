import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.placeholder,
    this.initialValue = '',
    this.maxLength,
    this.isEnabled = true,
    this.showEmptyTextError = false,
    required this.type,
    this.focusNode,
    this.textInputAction,
    this.controller,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });

  final String title;
  final String subtitle;
  final String? placeholder;
  final String initialValue;
  final int? maxLength;
  final bool isEnabled;
  final bool showEmptyTextError;
  final AppInputType type;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool isTextHidden = widget.type == AppInputType.password;
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialValue;

    super.initState();
  }

  Color getColor({bool hasError = false, bool hasFocus = false}) {
    if (hasError && hasFocus) {
      return AppStyles.errorColor;
    }
    if (!widget.isEnabled || !hasFocus) {
      return AppStyles.bordersColor;
    }
    return AppStyles.textHighEmphasisColor;
  }

  Color getBackgroundColor() {
    if (!widget.isEnabled) {
      return AppStyles.disabledColor;
    }
    return AppStyles.transparentColor;
  }

  TextStyle getTextStyle() {
    if (!widget.isEnabled) {
      return AppStyles.diabledInputTextStyle;
    }
    return AppStyles.body1TextStyle;
  }

  InputBorder getBorderStyle({bool hasError = false, bool hasFocus = false}) {
    Color color = getColor(hasError: hasError, hasFocus: hasFocus);

    return OutlineInputBorder(
      borderRadius: AppStyles.borderRadius,
      borderSide: BorderSide(
        color: color,
        width: 1,
      ),
    );
  }

  TextInputType getKeyboardType() {
    switch (widget.type) {
      case AppInputType.text:
        return TextInputType.text;
      case AppInputType.email:
        return TextInputType.emailAddress;
      case AppInputType.password:
        return TextInputType.visiblePassword;
      case AppInputType.numeric:
        return TextInputType.phone;
    }
  }

  Widget? renderSuffixIcon() {
    switch (widget.type) {
      case AppInputType.password:
        return Container(
          margin: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              setState(() {
                isTextHidden = !isTextHidden;
              });
            },
            icon: Icon(
              isTextHidden
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_sharp,
              color: AppStyles.textHighEmphasisColor,
              size: 22,
            ),
          ),
        );
      case AppInputType.text:
      case AppInputType.email:
      case AppInputType.numeric:
        return null;
    }
  }

  Widget renderTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        widget.title,
        style: AppStyles.inputLabelTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget renderSubtitle() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          if (widget.subtitle.isNotEmpty)
            Text(
              widget.subtitle,
              style: AppStyles.overline1TextStyle,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) renderTitle(),
        TextFormField(
          maxLines: 1,
          maxLength: widget.maxLength,
          keyboardType: getKeyboardType(),
          onFieldSubmitted: widget.onSubmitted,
          focusNode: focusNode,
          controller: controller,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          enabled: widget.isEnabled,
          obscureText: isTextHidden,
          onChanged: widget.onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: getColor(),
          cursorErrorColor: getColor(hasError: true),
          onTap: () => focusNode.requestFocus(),
          onTapOutside: (_) => focusNode.unfocus(),
          style: getTextStyle(),
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            errorStyle: AppStyles.inputErrorTextStyle.copyWith(height: 0),
            filled: true,
            fillColor: getBackgroundColor(),
            suffixIcon: renderSuffixIcon(),
            suffixIconConstraints: BoxConstraints(
              maxWidth: 24 * 1.7,
              maxHeight: 24 * 1.7,
            ),
            isDense: true,
            enabled: widget.isEnabled,
            hintText: widget.placeholder,
            hintStyle: AppStyles.diabledInputTextStyle,
            border: getBorderStyle(),
            errorBorder: getBorderStyle(hasError: true),
            focusedBorder: getBorderStyle(hasFocus: true),
            enabledBorder: getBorderStyle(),
            disabledBorder: getBorderStyle(),
            focusedErrorBorder: getBorderStyle(hasError: true, hasFocus: true),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 12),
            ),
            contentPadding: const EdgeInsets.only(
              top: 11,
              bottom: 11,
              right: 12,
            ),
            counterText: '',
          ),
        ),
        if (widget.subtitle.isNotEmpty) renderSubtitle(),
      ],
    );
  }
}

enum AppInputType {
  /// An input for entering text in a single line
  text,

  /// An input for entering an email
  email,

  /// An input for entering numbers
  numeric,

  /// An input for entering a password. Has a button to toggle obscuring the password
  password,
}
