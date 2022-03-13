import 'package:flutter/material.dart';

class SingleChildScrollViewWidget extends StatelessWidget {
  final Widget? child;
  const SingleChildScrollViewWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
