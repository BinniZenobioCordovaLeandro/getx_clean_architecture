import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/animated_switcher_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_widget.dart';

class ListTileRadioCardWidget extends StatelessWidget {
  final ShapeBorder? shape;
  final dynamic groupValue;
  final dynamic value;
  final Function(dynamic value)? onChanged;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? body;
  final bool isRadio;

  const ListTileRadioCardWidget({
    Key? key,
    this.shape,
    this.groupValue,
    this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.leading,
    this.body,
    this.isRadio=true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      shape: (isRadio == true)
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
            ListTileRadioWidget(
              isRadius: isRadio,
              shape: (groupValue == value)
                  ? const RoundedRectangleBorder()
                  : null,
              groupValue: groupValue,
              value: value,
              onChanged: onChanged,
              title: title,
              subtitle: subtitle,
              leading: leading,
            ),
          AnimatedSwitcherWidget(
            child: (groupValue == value) ? body : Container(),
          )
        ],
      ),
    );
  }
}
