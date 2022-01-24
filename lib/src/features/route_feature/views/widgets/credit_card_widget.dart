import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          BlurWidget(
            child: CardWidget(
              color: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: const [
                    SizedBox(
                      height: 8,
                    ),
                    TextFieldWidget(
                      labelText: 'CVV',
                    ),
                  ],
                ),
              ),
            ),
          ),
          CardWidget(
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextFieldWidget(
                    labelText: 'CVV',
                    onChanged: (value) {
                      print('$value');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
