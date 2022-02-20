import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/animated_switcher_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_switch_widget.dart';

class ListTileSwitchCardWidget extends StatelessWidget {
  final ShapeBorder? shape;
  final dynamic groupValue;
  final dynamic value;
  final Function(dynamic value)? onChanged;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? body;
  final bool isSwitch;

  const ListTileSwitchCardWidget({
    Key? key,
    this.shape,
    this.groupValue,
    this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.leading,
    this.body,
    this.isSwitch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      shape: (isSwitch == true)
          ? (groupValue == value)
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                )
              : const RoundedRectangleBorder()
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            ListTileSwitchWidget(
              isSwitch: isSwitch,
              shape:
                  (groupValue == value) ? const RoundedRectangleBorder() : null,
              groupValue: groupValue,
              value: value,
              onChanged: onChanged,
              title: title,
              subtitle: subtitle,
              leading: leading,
            ),
          if (body != null)
            AnimatedSwitcherWidget(
              child: (groupValue == value) ? body : Container(),
            )
        ],
      ),
    );
  }
}
