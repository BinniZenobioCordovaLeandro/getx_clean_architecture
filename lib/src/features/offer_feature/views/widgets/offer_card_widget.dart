import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class OfferDescriptionCardWidget extends StatelessWidget {
  final String? to;
  final String? from;
  final double? price;

  const OfferDescriptionCardWidget({
    Key? key,
    this.to,
    this.from,
    this.price,
  }) : super(key: key);

  Widget child(BuildContext context) {
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
              SizedBox(
                width: double.infinity,
                child: TextWidget(
                  'Precio: S/. ${price?.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
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
