import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final String routeTo;
  final String routeFrom;
  final DateTime? dateTime;
  final String userPickPointLat;
  final String userPickPointLng;
  final int? count;
  final double? total;

  const OrderCardWidget({
    Key? key,
    required this.routeTo,
    required this.routeFrom,
    this.dateTime,
    required this.userPickPointLat,
    required this.userPickPointLng,
    this.count = 1,
    this.total,
  }) : super(key: key);

  child(BuildContext context) {
    String? dateString = (dateTime != null)
        ? DateFormat('dd/MM/yyyy kk:mm a').format(dateTime!)
        : null;
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: WrapWidget(
            spacing: 2,
            runSpacing: 2,
            children: <Widget>[
              if (dateTime != null)
                SizedBox(
                  width: double.infinity,
                  child: TextWidget(
                    'Fecha de salida: $dateString',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              if (dateTime != null) const Divider(),
              SizedBox(
                width: double.infinity,
                child: TextWidget(
                  'Destino: $routeTo',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
              if (total != null) const Divider(),
              if (total != null)
                SizedBox(
                  width: double.infinity,
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (count != null)
                        TextWidget(
                          '$count asiento(s)',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.right,
                        ),
                      TextWidget(
                        'Total: S/ ${total?.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right,
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
