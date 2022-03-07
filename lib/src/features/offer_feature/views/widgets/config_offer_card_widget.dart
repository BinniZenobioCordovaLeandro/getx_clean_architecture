import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class ConfigOfferCardWidget extends StatelessWidget {
  const ConfigOfferCardWidget({Key? key}) : super(key: key);

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
                  padding: EdgeInsets.symmetric(
                    vertical: 8.00,
                  ),
                  child: WrapWidget(
                    children: [
                      TextFieldWidget(
                        labelText: 'Asientos',
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: false,
                          signed: false,
                        ),
                      ),
                      TextFieldWidget(
                        labelText: 'Precio',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ProgressStateButtonWidget(
                          success: 'Publicar',
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
                padding: const EdgeInsets.symmetric(
                  vertical: 8.00,
                ),
                child: WrapWidget(
                  children: [
                    const TextFieldWidget(
                      labelText: 'Asientos',
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                    ),
                    const TextFieldWidget(
                      labelText: 'Precio',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ProgressStateButtonWidget(
                        success: 'Publicar',
                        onPressed: () {},
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
