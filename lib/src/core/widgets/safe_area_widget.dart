import 'package:flutter/material.dart';

class SafeAreaWidget extends StatelessWidget {
  final Widget child;
  final bool maintainBottomViewPadding;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const SafeAreaWidget({
    Key? key,
    required this.child,
    this.maintainBottomViewPadding = false,
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: maintainBottomViewPadding,
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: child,
    );
  }
}
