import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          const BlurWidget(
            child: CardWidget(
              color: Colors.transparent,
              child: FractionallySizedBoxWidget(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: WrapWidget(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextFieldWidget(
                          labelText: 'CVV',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CardWidget(
            color: Colors.transparent,
            child: FractionallySizedBoxWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: WrapWidget(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFieldWidget(
                        labelText: 'CVV',
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
