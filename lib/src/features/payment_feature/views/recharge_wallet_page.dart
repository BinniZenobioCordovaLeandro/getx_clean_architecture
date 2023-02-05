import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/payment_feature/views/enums/credit_card_type.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/list_amount_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/list_tile_credit_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/list_tile_new_credit_card_widget.dart';

class RechargeWalletPage extends StatefulWidget {
  final double amount;

  const RechargeWalletPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  State<RechargeWalletPage> createState() => _RechargeWalletPageState();
}

class _RechargeWalletPageState extends State<RechargeWalletPage> {
  CreditCardType creditCardType = CreditCardType.creditCard;
  double groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldScrollWidget(
      title: 'Recargar Monedero',
      footer: ElevatedButtonWidget(
        title: 'Recargar S/ 9.00',
        onPressed: (groupValue > 0) ? () {} : null,
      ),
      children: [
        SizedBox(
          width: double.infinity,
          child: TextWidget(
            'Monto de recarga',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListAmountWidget(onChanged: (value) {}),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: TextWidget(
            'Metodos de recarga',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTileCreditCardWidget(
          groupValue: creditCardType,
          value: CreditCardType.creditCard,
          onChanged: (value) {
            setState(() {
              creditCardType = value as CreditCardType;
            });
          },
        ),
        ListTileNewCreditCardWidget(
          groupValue: creditCardType,
          value: CreditCardType.newCreditCard,
          onChanged: (value) {
            setState(() {
              creditCardType = value as CreditCardType;
            });
          },
        ),
      ],
    );
  }
}
