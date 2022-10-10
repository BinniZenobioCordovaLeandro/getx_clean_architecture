import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class OfferOrderCardWidget extends StatelessWidget {
  final String? fullname;
  final int? count;
  final double? subtotal;
  final double? total;
  final Function()? onTap;

  const OfferOrderCardWidget({
    Key? key,
    this.fullname,
    this.count,
    this.subtotal,
    this.total,
    this.onTap,
  }) : super(key: key);

  Widget child(BuildContext context) {
    double? aditional = 0.0;
    if (total != null && subtotal != null) {
      aditional = total! - subtotal!;
    }
    return CardWidget(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: FractionallySizedBoxWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                CircleAvatar(
                  child: TextWidget(
                    '+ $count',
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: TextWidget(
                    '$fullname',
                  ),
                ),
                const VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      '+ S/ ${(total! - aditional).toStringAsFixed(2)}',
                    ),
                    if (aditional > 0)
                      TextWidget(
                        '+ S/ ${aditional.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                  ],
                ),
              ],
            ),
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
