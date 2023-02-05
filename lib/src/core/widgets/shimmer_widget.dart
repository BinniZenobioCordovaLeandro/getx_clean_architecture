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
        baseColor: Theme.of(context).colorScheme.background,
        highlightColor: Theme.of(context).primaryColor,
        child: child!,
      );
    } else {
      return child!;
    }
  }
}
