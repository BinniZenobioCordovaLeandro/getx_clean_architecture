import 'package:flutter/material.dart';

class WrapWidget extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const WrapWidget({
    Key? key,
    required this.children,
    this.spacing = 8,
    this.runSpacing = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
    );
  }
}
