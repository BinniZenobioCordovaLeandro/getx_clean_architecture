import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:progress_state_button/progress_button.dart';

class OffersEmptyCardCardWidget extends StatelessWidget {
  final bool? isLoading;
  final Function? onPressed;

  const OffersEmptyCardCardWidget({
    Key? key,
    this.isLoading = false,
    this.onPressed,
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
                'Todos los vehiculos en esta ruta estan servicio',
                style: Theme.of(context).textTheme.headline6,
              ),
              const TextWidget(
                '¿Quieres recibir una notificación cuando tengamos autos disponibles a esta ruta?',
              ),
              ProgressStateButtonWidget(
                success: 'Enviarme una notificación',
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
