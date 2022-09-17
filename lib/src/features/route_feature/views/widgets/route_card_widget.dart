import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class RouteCardWidget extends StatelessWidget {
  final String? to;
  final String? from;

  const RouteCardWidget({
    Key? key,
    this.to,
    this.from,
  }) : super(key: key);

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
