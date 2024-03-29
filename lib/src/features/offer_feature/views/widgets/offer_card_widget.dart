import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class OfferDescriptionCardWidget extends StatelessWidget {
  final String? to;
  final String? from;
  final DateTime? dateTime;
  final int? count;
  final int? maxCount;
  final double? total;

  const OfferDescriptionCardWidget({
    Key? key,
    this.to,
    this.from,
    this.dateTime,
    this.count,
    this.maxCount,
    this.total,
  }) : super(key: key);

  Widget child(BuildContext context) {
    String? dateString = (dateTime != null)
        ? DateFormat('dd/MM/yyyy kk:mm a').format(dateTime!)
        : null;
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
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
                  'Destino: $to',
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
                  'Origen: $from',
                  textAlign: TextAlign.justify,
                ),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      'Listo $count de $maxCount',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.right,
                    ),
                    TextWidget(
                      'Total: S/ ${total?.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
