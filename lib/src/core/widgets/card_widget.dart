import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? elevation;
  final ShapeBorder? shape;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final bool? borderOnForeground;
  final double? width;

  const CardWidget({
    Key? key,
    this.child,
    this.padding = const EdgeInsets.all(2.0),
    this.elevation = 0,
    this.shape,
    this.color,
    this.margin = EdgeInsets.zero,
    this.borderOnForeground = true,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        elevation: elevation,
        shape: shape,
        color: color ?? Theme.of(context).cardTheme.color,
        margin: margin,
        borderOnForeground: true,
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    );
  }
}
