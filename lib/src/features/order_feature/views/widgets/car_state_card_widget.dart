import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class CarStateCardWidget extends StatelessWidget {
  final String?
      carStateId; // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0

  const CarStateCardWidget({
    Key? key,
    this.carStateId,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.00,
          ),
          child: WrapWidget(
            children: [
              if (carStateId == '-1')
                const Expanded(
                  child: TextWidget(
                    'Por favor ESPERA unos minutos, estamos trabajando en vender los asientos restantes.\nTe notificaremos cuando el VEHICULO inicie el viaje.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              if (carStateId == '2')
                const Expanded(
                  child: TextWidget(
                    'Perfecto!, el vehiculo se encuentra en CAMINO!',
                    textAlign: TextAlign.justify,
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
