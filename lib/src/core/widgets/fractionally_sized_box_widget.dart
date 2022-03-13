import 'package:flutter/material.dart';

class FractionallySizedBoxWidget extends StatelessWidget {
  final Widget? child;
  final double? widthFactor;

  const FractionallySizedBoxWidget({
    Key? key,
    this.child,
    this.widthFactor = 0.9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: child,
    );
  }
}
