import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? color;
  final BorderRadius? borderRadius;

  const BlurWidget({
    Key? key,
    required this.child,
    this.blur = 2.0,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Blur(
      blur: blur,
      blurColor: (color != null) ? color! : Theme.of(context).backgroundColor,
      child: child,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    );
  }
}
