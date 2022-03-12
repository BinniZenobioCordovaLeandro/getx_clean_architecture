import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final Widget child;
  final WillPopCallback? onWillPop;
  final VoidCallback? onChanged;
  final AutovalidateMode? autovalidateMode;

  const FormWidget({
    Key? key,
    required this.child,
    this.onWillPop,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: child,
      onWillPop: onWillPop,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
    );
  }
}
