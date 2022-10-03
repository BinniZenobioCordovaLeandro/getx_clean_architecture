import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class RouteCardWidget extends StatelessWidget {
  final String? to;
  final String? from;
  final double? meters;
  final Duration? duration;

  const RouteCardWidget({
    Key? key,
    this.to,
    this.from,
    this.meters,
    this.duration,
  }) : super(key: key);

  String? getDistanceString(double meters) {
    if (meters > 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} Kilometros';
    }
    return '${meters.toStringAsFixed(2)} metros';
  }

  String? getDurationString(Duration duration) {
    if (duration.inMinutes > 60) return '${duration.inHours} horas';
    return '${duration.inMinutes} minutos';
  }

  Widget child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: WrapWidget(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextWidget(
                        'Destino: $to',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const VerticalDivider(),
                    const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextWidget(
                        'Origen: $from',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const VerticalDivider(),
                    const Icon(
                      Icons.taxi_alert_outlined,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              if (duration != null)
                SizedBox(
                  width: double.infinity,
                  child: WrapWidget(
                    children: [
                      TextWidget(
                        'Tiempo: ${getDurationString(duration!)}',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      TextWidget(
                        'Distancia: ${getDistanceString(meters!)}',
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
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
          child(context)
        ],
      ),
    );
  }
}
