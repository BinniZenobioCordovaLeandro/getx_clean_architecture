import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String? title;
  final void Function()? onPressed;
  final Color? color;
  final bool? enabled;
  final OutlinedBorder? shape;

  const ElevatedButtonWidget({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.enabled = true,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: color == null
            ? shape != null
                ? ElevatedButton.styleFrom(shape: shape)
                : Theme.of(context).elevatedButtonTheme.style
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return color!;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return color!;
                  }
                  return color!;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return color!;
                  }
                  return Colors.transparent;
                }),
              ),
        onPressed: (enabled == true && onPressed != null)
            ? () {
                onPressed!();
              }
            : null,
        child: Text(
          '$title',
        ),
      ),
    );
  }
}
