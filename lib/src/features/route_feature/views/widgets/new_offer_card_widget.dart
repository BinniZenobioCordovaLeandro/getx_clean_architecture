import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:progress_state_button/progress_button.dart';

class NewOfferCardWidget extends StatelessWidget {
  final bool? isLoading;
  final Function? onPressed;
  final double? price;

  const NewOfferCardWidget({
    Key? key,
    this.isLoading = false,
    this.onPressed,
    this.price,
  }) : super(key: key);

  Widget child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: WrapWidget(
            children: [
              TextWidget(
                'Es hora de ganar extra ;) .',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextWidget(
                'Realiza esta ruta desde S/. ${price?.toStringAsFixed(2)} por asiento.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextWidget(
                'Te eviaremos una notificación cada que un pasajero compre un asiento, para que puedas estar listo para iniciar tu viaje.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              ProgressStateButtonWidget(
                success: 'Realizar Ruta',
                state: isLoading == true
                    ? ButtonState.loading
                    : ButtonState.success,
                onPressed: onPressed,
              )
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
          child(context)
        ],
      ),
    );
  }
}
