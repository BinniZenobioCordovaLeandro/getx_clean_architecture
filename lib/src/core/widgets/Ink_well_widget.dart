import 'package:flutter/material.dart';

class InkWellWidget extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;

  const InkWellWidget({
    Key? key,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }
}
