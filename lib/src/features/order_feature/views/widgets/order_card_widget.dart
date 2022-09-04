import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final String routeTo;
  final String routeFrom;
  final String userPickPointLat;
  final String userPickPointLng;

  const OrderCardWidget({
    Key? key,
    required this.routeTo,
    required this.routeFrom,
    required this.userPickPointLat,
    required this.userPickPointLng,
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
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextWidget(
                  'Destino: $routeTo',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextWidget(
                  'Origen: $routeFrom',
                  textAlign: TextAlign.justify,
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  const Icon(
                    Icons.person_pin_circle_sharp,
                    color: Colors.blue,
                  ),
                  VerticalDivider(
                    color: Theme.of(context).primaryColor,
                    thickness: 2.00,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextWidget(
                        'Punto de encuentro: $userPickPointLat, $userPickPointLng',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
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
