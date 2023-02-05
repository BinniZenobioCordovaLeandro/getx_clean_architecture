import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final String? title;
  final Function()? onPressed;

  const OutlinedButtonWidget({
    Key? key,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Center(
        child: TextWidget(
          '$title',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}
