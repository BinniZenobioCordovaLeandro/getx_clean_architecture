import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/animated_switcher_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_switch_widget.dart';

class ListTileSwitchCardWidget extends StatelessWidget {
  final ShapeBorder? shape;
  final dynamic value;
  final Function(dynamic value)? onChanged;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? body;
  final bool isSwitch;
  final bool? showBorder;

  const ListTileSwitchCardWidget({
    Key? key,
    this.shape,
    this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.leading,
    this.body,
    this.isSwitch = true,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      shape: showBorder != true
          ? null
          : (isSwitch == true)
              ? (value)
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
              shape: (value) ? const RoundedRectangleBorder() : null,
              value: value,
              onChanged: onChanged,
              title: title,
              subtitle: subtitle,
              leading: leading,
            ),
          if (body != null)
            AnimatedSwitcherWidget(
              child: (value) ? body : Container(),
            )
        ],
      ),
    );
  }
}
