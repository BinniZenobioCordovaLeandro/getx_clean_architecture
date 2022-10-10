import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/circle_avatar_image_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:progress_state_button/progress_button.dart';

class StartTripCardWidget extends StatelessWidget {
  final bool isLoading;
  final Function()? onPressed;

  const StartTripCardWidget({
    Key? key,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: WrapWidget(
            children: [
              TextWidget(
                '¡Esperando a que completen los pasajeros!',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextWidget(
                'Si decides iniciar YA!, no se buscaran mas pasajeros para tu viaje y TENDRAS QUE INICIAR EL VIAJE.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ProgressStateButtonWidget(
                state: isLoading ? ButtonState.loading : ButtonState.success,
                success: 'Iniciar viaje YA!',
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
      child: Stack(children: [
        BlurWidget(
          child: child(context),
        ),
        child(context),
      ]),
    );
  }
}
