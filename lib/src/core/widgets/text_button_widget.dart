import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';

class TextButtonWidget extends StatelessWidget {
  final String? title;
  final void Function()? onPressed;
  final Color? color;

  const TextButtonWidget({
    Key? key,
    required this.title,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: ColoredBox(
        color: Colors.transparent,
        child: FractionallySizedBoxWidget(
          child: Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: (onPressed != null) ? 1 : 0.7,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '$title',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: color ??
                            ((onPressed != null)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor),
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
