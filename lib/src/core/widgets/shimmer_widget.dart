import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget? child;
  final bool? enabled;

  const ShimmerWidget({
    Key? key,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enabled == true) {
      return Shimmer.fromColors(
        enabled: enabled!,
        child: child!,
        baseColor: Theme.of(context).backgroundColor,
        highlightColor: Theme.of(context).primaryColor,
      );
    } else {
      return child!;
    }
  }
}
