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

class StartWaitingTripCardWidget extends StatelessWidget {
  final bool isLoading;
  final DateTime? dateTime;
  final Function()? onPressed;

  const StartWaitingTripCardWidget({
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
                  '¡Esperando a que completen los pasajeros!',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              else
                TextWidget(
                  '¡Estamos buscando pasajeros!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              TextWidget(
                'Estamos trabajando para vender los asientos para tu viaje del dia y hora',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (isOnDate)
                ProgressStateButtonWidget(
                  state: isLoading ? ButtonState.loading : ButtonState.success,
                  success: 'Iniciar viaje YA!',
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
