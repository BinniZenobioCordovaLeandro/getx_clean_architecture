import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;

  const TextWidget(
    this.data, {
    Key? key,
    this.style,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style ?? Theme.of(context).textTheme.bodyLarge,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
