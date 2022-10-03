import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class ListAmountWidget extends StatefulWidget {
  final Function(dynamic value)? onChanged;

  const ListAmountWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ListAmountWidget> createState() => _ListAmountWidgetState();
}

class _ListAmountWidgetState extends State<ListAmountWidget> {
  final List<double> listAmount = [5.00, 10.00, 30.00, 100.00, 300.00];
  double groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: WrapWidget(children: [
        for (var amount in listAmount)
          ListTileRadioWidget(
            groupValue: groupValue,
            value: amount,
            title: TextWidget('S/ $amount'),
            onChanged: (value) {
              setState(() {
                groupValue = value;
                widget.onChanged?.call(value);
              });
            },
          ),
      ]),
    );
  }
}
