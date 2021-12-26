import 'package:flutter/material.dart';

class WrapWidget extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const WrapWidget({
    Key? key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
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
