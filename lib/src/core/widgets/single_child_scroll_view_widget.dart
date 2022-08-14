import 'package:flutter/material.dart';

class SingleChildScrollViewWidget extends StatelessWidget {
  final Widget? child;
  final Axis scrollDirection;

  const SingleChildScrollViewWidget({
    Key? key,
    this.child,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
