import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class PopupMarkerTaxiWidget extends StatelessWidget {
  final double meters;

  const PopupMarkerTaxiWidget({
    Key? key,
    required this.meters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 80,
      child: Stack(
        children: [
          Blur(
            child: CardWidget(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    const TextWidget(
                      'El vehiculo esta a',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextWidget(
                      meters > 1000
                          ? (meters / 1000).toStringAsFixed(2)
                          : meters.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextWidget(
                      '${meters > 1000 ? "Kilometros" : "metros"} de ti',
                    ),
                  ],
                ),
              ),
            ),
          ),
          CardWidget(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  const TextWidget(
                    'El vehiculo esta a',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextWidget(
                    meters > 1000
                        ? (meters / 1000).toStringAsFixed(2)
                        : meters.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextWidget(
                    '${meters > 1000 ? "Kilometros" : "metros"} de ti',
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
