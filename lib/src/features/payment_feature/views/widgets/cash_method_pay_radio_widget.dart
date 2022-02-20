import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class CashMethodPayRadioWidget extends StatelessWidget {
  final String? title;
  final Widget? child;
  final dynamic groupValue;
  final dynamic value;
  final Function(dynamic value)? onChanged;

  const CashMethodPayRadioWidget({
    Key? key,
    this.title,
    this.child,
    this.groupValue,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileRadioCardWidget(
      leading: Icon(
        Icons.attach_money_rounded,
        color: Theme.of(context).primaryColor,
      ),
      groupValue: groupValue,
      value: value,
      onChanged: onChanged,
      title: TextWidget(
        'Cash',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
