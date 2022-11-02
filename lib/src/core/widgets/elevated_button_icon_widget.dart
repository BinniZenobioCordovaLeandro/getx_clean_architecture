import 'package:flutter/material.dart';

class ElevatedButtonIconWidget extends StatelessWidget {
  final IconData icon;
  final String? title;
  final void Function()? onPressed;
  final Color? color;
  final bool? enabled;
  final OutlinedBorder? shape;

  const ElevatedButtonIconWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onPressed,
    this.color,
    this.enabled = true,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton.icon(
        icon: Icon(icon),
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
        label: Text(
          '$title',
        ),
      ),
    );
  }
}
