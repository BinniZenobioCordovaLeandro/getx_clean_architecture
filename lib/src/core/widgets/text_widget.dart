import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const TextWidget(
    this.data, {
    Key? key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style ?? Theme.of(context).textTheme.bodyText1,
    );
  }
}
