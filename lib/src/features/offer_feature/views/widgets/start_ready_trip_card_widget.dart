import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_icon_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:progress_state_button/progress_button.dart';

class StartReadyTripCardWidget extends StatelessWidget {
  final bool isLoading;
  final DateTime? dateTime;
  final Function()? onPressed;

  const StartReadyTripCardWidget({
    Key? key,
    this.isLoading = false,
    this.dateTime,
    this.onPressed,
  }) : super(key: key);

  child(BuildContext context) {
    bool isOnDate = dateTime != null && dateTime!.isBefore(DateTime.now());
    String? dateString = DateFormat('dd/MM/yyyy kk:mm a').format(dateTime!);
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: WrapWidget(
            children: [
              if (isOnDate)
                TextWidget(
                  '¡Asientos vendidos!',
                  style: Theme.of(context).textTheme.headline6,
                )
              else
                TextWidget(
                  '¡Vendimos los asientos, espera la fecha para que puedas INICIAR!',
                  style: Theme.of(context).textTheme.headline6,
                ),
              if (isOnDate)
                TextWidget(
                  'Hurray!, todos los asientos se vendieron.\nAHORA pulsa el boton "Iniciar viaje YA!", para notificar a los usuarios que iniciaste el recorrido y estas en camino.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (isOnDate)
                TextWidget(
                  'RECUERDA MANTENERTE EN ESTA PAGINA DURANTE EL VIAJE Y CONECTADO A INTERNET, Para que podamos notificar a los usuarios de tu ubicación.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              if (isOnDate)
                ProgressStateButtonWidget(
                  state: isLoading ? ButtonState.loading : ButtonState.success,
                  success: 'Vendido, Iniciar viaje YA!',
                  onPressed: onPressed,
                )
              else
                ElevatedButtonIconWidget(
                  icon: Icons.alarm_rounded,
                  title: dateString,
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
