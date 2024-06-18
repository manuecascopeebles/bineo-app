import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedAppIcon extends StatefulWidget {
  const AnimatedAppIcon({
    super.key,
    required this.onAnimationFinished,
  });

  final void Function() onAnimationFinished;

  @override
  State<AnimatedAppIcon> createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<AnimatedAppIcon> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 5),
      widget.onAnimationFinished,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/bineo-splash.json',
      repeat: false,
    );
  }
}
