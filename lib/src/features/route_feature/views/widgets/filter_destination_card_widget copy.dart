import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class FilterDestinationCardWidget extends StatefulWidget {
  final Function(String? to, String? from) onFilterDestain;

  const FilterDestinationCardWidget({
    Key? key,
    required this.onFilterDestain,
  }) : super(key: key);

  @override
  State<FilterDestinationCardWidget> createState() =>
      _FilterDestinationCardWidgetState();
}

class _FilterDestinationCardWidgetState
    extends State<FilterDestinationCardWidget> {
  String? to;

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: WrapWidget(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextFieldWidget(
                  labelText: 'Destino',
                  onChanged: (String string) {
                    setState(() {
                      to = string;
                      widget.onFilterDestain(string, null);
                    });
                  },
                ),
              ),
              if (to != null && to!.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: TextFieldWidget(
                    labelText: 'Origen',
                    onChanged: (String string) {
                      widget.onFilterDestain(to, string);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          BlurWidget(
            child: child(context),
          ),
          child(context),
        ],
      ),
    );
  }
}
