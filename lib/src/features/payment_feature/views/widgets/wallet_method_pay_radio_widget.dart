import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class WalletMethodPayRadioWidget extends StatelessWidget {
  final String? title;
  final Widget? child;
  final dynamic groupValue;
  final dynamic value;
  final bool toRecharge;
  final void Function()? onPressed;
  final Function(dynamic value)? onChanged;

  const WalletMethodPayRadioWidget({
    Key? key,
    this.title,
    this.child,
    this.groupValue,
    this.value,
    this.toRecharge = false,
    this.onPressed,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileRadioCardWidget(
      groupValue: groupValue,
      value: value,
      onChanged: onChanged,
      leading: Icon(
        Icons.account_balance_wallet_outlined,
        color: Theme.of(context).primaryColor,
      ),
      title: TextWidget(
        '$title',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      body: toRecharge
          ? SizedBox(
              width: double.infinity,
              child: FractionallySizedBoxWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: WrapWidget(
                    children: [
                      const Center(
                        child: TextWidget(
                          'Recarga S/. 0.20 para pagar con tu monedero',
                        ),
                      ),
                      ElevatedButtonWidget(
                        title: 'Recargar Ahora',
                        onPressed: onPressed,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
