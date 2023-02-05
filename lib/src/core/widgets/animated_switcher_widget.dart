import 'package:flutter/material.dart';

class AnimatedSwitcherWidget extends StatelessWidget {
  final Widget? child;
  final Duration duration;
  final Curve switchOutCurve;
  final Curve switchInCurve;

  const AnimatedSwitcherWidget({
    Key? key,
    required this.child,
    this.switchOutCurve = Curves.easeOutExpo,
    this.switchInCurve = Curves.easeInExpo,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchOutCurve: switchOutCurve,
      switchInCurve: switchInCurve,
      transitionBuilder: (widget, animation) {
        return ScaleTransition(
          scale: animation,
          child: widget,
        );
      },
      child: child!,
    );
  }
}
