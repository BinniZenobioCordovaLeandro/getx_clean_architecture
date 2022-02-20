import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';

class ListTileSwitchWidget extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final dynamic value;
  final dynamic groupValue;
  final ShapeBorder? shape;
  final Function(dynamic value)? onChanged;
  final bool isSwitch;

  const ListTileSwitchWidget({
    Key? key,
    this.title,
    this.subtitle,
    this.leading,
    this.value,
    this.groupValue,
    this.shape,
    this.onChanged,
    this.isSwitch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CardWidget(
        color: Colors.transparent,
        shape: (shape != null)
            ? shape
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: (value == groupValue)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardTheme.shadowColor!,
                  width: 2,
                ),
              ),
        child: Stack(
          children: [
            BlurWidget(
              child: ListTile(
                  title: title,
                  subtitle: subtitle,
                  leading: leading,
                  selected: value == groupValue,
                  onTap: () {
                    if (onChanged != null) onChanged!(value);
                  },
                  trailing: (isSwitch == true)
                      ? Switch(
                          value: value,
                          onChanged: (dynamic value) {},
                        )
                      : null),
            ),
            ListTile(
                title: title,
                subtitle: subtitle,
                leading: leading,
                selected: value == groupValue,
                onTap: () {
                  if (onChanged != null) onChanged!(value);
                },
                trailing: (isSwitch == true)
                    ? Switch(
                        value: value,
                        onChanged: (dynamic value) {
                          if (onChanged != null) onChanged!(value);
                        },
                      )
                    : null),
          ],
        ),
      ),
    );
  }
}
