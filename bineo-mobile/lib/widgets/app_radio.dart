import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';

class AppRadio extends StatefulWidget {
  const AppRadio({
    super.key,
    required this.isSelected,
    required this.onChanged,
  });

  final bool isSelected;
  final void Function(bool) onChanged;

  @override
  State<AppRadio> createState() => _AppRadioState();
}

class _AppRadioState extends State<AppRadio>
    with TickerProviderStateMixin, ToggleableStateMixin {
  @override
  void initState() {
    super.initState();

    animateToValue();
  }

  @override
  void didUpdateWidget(AppRadio oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != oldWidget.isSelected) {
      animateToValue();
    }
  }

  @override
  ValueChanged<bool?>? get onChanged {
    return (newValue) {
      return widget.onChanged(newValue!);
    };
  }

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: widget.isSelected,
        selected: widget.isSelected,
        child: buildToggleable(
          mouseCursor: WidgetStatePropertyAll(
            MouseCursor.uncontrolled,
          ),
          size: Size(24, 24),
          painter: _AppRadioPainter()
            ..position = position
            ..reaction = reaction
            ..reactionFocusFade = reactionFocusFade
            ..reactionHoverFade = reactionHoverFade
            ..inactiveReactionColor =
                AppStyles.textHighEmphasisColor.withOpacity(0.25)
            ..reactionColor = AppStyles.primaryColor.withOpacity(0.25)
            ..hoverColor = AppStyles.transparentColor
            ..focusColor = AppStyles.transparentColor
            ..splashRadius = 22
            ..downPosition = downPosition
            ..isFocused = states.contains(WidgetState.focused)
            ..isHovered = states.contains(WidgetState.hovered)
            ..activeColor = AppStyles.primaryColor
            ..inactiveColor = AppStyles.textHighEmphasisColor,
        ),
      ),
    );
  }
}

class _AppRadioPainter extends ToggleablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Offset center = (Offset.zero & size).center;

    // Outer circle
    final Paint paint = Paint()
      ..color = Color.lerp(inactiveColor, activeColor, position.value)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, 12.5, paint);

    // Inner circle
    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, 5.5 * position.value, paint);
    }
  }
}
