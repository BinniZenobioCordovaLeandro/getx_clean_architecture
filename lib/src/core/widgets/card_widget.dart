import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? elevation;
  final ShapeBorder? shape;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final bool? borderOnForeground;
  final bool? withBorder;
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
    this.withBorder = false,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShapeBorder? shapeBorder;
    if (shape == null) {
      shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Theme.of(context).cardTheme.shadowColor!,
          width: withBorder == true ? 2 : 0,
        ),
      );
    }
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        elevation: elevation,
        shape: shape ?? shapeBorder,
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
