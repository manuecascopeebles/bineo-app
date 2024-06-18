import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/app_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    this.title,
    this.isLoading = false,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? title;
  final bool isLoading;

  final T value;
  final List<T> items;
  final void Function(T?) onChanged;

  BoxDecoration getDecoration() {
    return BoxDecoration(
      gradient: AppStyles.blackColorGradient,
      borderRadius: AppStyles.borderRadius,
      boxShadow: [
        BoxShadow(
          color: AppStyles.darkShadowColor,
          blurRadius: 16,
          blurStyle: BlurStyle.outer,
        ),
        BoxShadow(
          color: AppStyles.lightShadowColor,
          blurRadius: 2,
          blurStyle: BlurStyle.inner,
        ),
      ],
    );
  }

  Widget renderTitle() {
    if (title == null) return Container();

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        title!,
        style: AppStyles.inputLabelTextStyle,
      ),
    );
  }

  Widget renderIcon() {
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.only(right: 15),
        child: AppActivityIndicator(
          size: 13,
          color: AppStyles.bordersColor,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: const Icon(
        CupertinoIcons.arrowtriangle_down_fill,
        size: 13,
        color: AppStyles.bordersColor,
      ),
    );
  }

  Widget renderItem(T item) {
    return Container(
      color: AppStyles.transparentColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: renderItemText(item),
    );
  }

  Widget renderItemText(T item) {
    return Text(
      item.toString(),
      style: AppStyles.body1TextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderTitle(),
        Container(
          decoration: getDecoration(),
          child: Material(
            color: AppStyles.transparentColor,
            borderRadius: AppStyles.borderRadius,
            child: InkWell(
              borderRadius: AppStyles.borderRadius,
              onTap: () {},
              splashFactory: InkSplash.splashFactory,
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<T>(
                  value: value,
                  isDense: true,
                  isExpanded: true,
                  icon: renderIcon(),
                  underline: Container(),
                  onChanged: onChanged,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  borderRadius: AppStyles.borderRadius,
                  dropdownColor: AppStyles.dropdownItemBackgroundColor,
                  items: items.map<DropdownMenuItem<T>>((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: renderItem(value),
                    );
                  }).toList(),
                  selectedItemBuilder: (_) {
                    return items.map((T value) {
                      return renderItemText(value);
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
