import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/credit_card_widget.dart';

class ListTileCreditCardWidget extends StatelessWidget {
  final dynamic groupValue;
  final dynamic value;
  final Function(dynamic value)? onChanged;

  const ListTileCreditCardWidget({
    Key? key,
    this.groupValue,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListTileRadioCardWidget(
        groupValue: groupValue,
        value: value,
        onChanged: onChanged,
        title: TextWidget(
          '511842** **** 4219',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        body: const SizedBox(
          width: double.infinity,
          child: FractionallySizedBoxWidget(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: CreditCardWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
