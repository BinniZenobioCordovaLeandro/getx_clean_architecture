import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class PaymentResumeWidget extends StatelessWidget {
  final int? quantity;
  final double? subtotal;
  final double? aditional;
  final double? total;

  const PaymentResumeWidget({
    Key? key,
    this.quantity = 1,
    this.subtotal = 1000,
    this.aditional = 1000,
    this.total = 1000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget('Sub Total ($quantity asientos)'),
              const TextWidget('Recojo desde domicilio'),
              const Divider(),
              TextWidget(
                'Total',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidget('S/ ${subtotal?.toStringAsFixed(2)}'),
              TextWidget('+ S/ ${aditional?.toStringAsFixed(2)}'),
              const Divider(),
              TextWidget(
                'S/ ${total?.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          )
        ],
      ),
    );
  }
}
