import 'package:flutter/material.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/core/widgets/outline_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/offer_card_widget.dart';

class StackOfferCardWidget extends StatelessWidget {
  final List<AbstractOfferEntity> listAbstractOfferEntity;
  final Function(AbstractOfferEntity abstractOfferEntity)? onTap;
  final Function(String? routeId)? onTapRoute;

  const StackOfferCardWidget({
    Key? key,
    required this.listAbstractOfferEntity,
    this.onTap,
    this.onTapRoute,
  }) : super(key: key);

  child(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Destino: ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Theme.of(context).primaryColor),
                          children: [
                            TextSpan(
                              text: '${listAbstractOfferEntity[0].routeTo}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          ],
                        ),
                      ),
                      TextWidget(
                        'Origen: ${listAbstractOfferEntity[0].routeFrom}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButtonWidget(
                  title: 'Ver ruta',
                  onPressed: () {
                    if (onTapRoute != null) {
                      onTapRoute!(listAbstractOfferEntity[0].routeId);
                    }
                  },
                ),
              ),
            ],
          ),
          for (var i = 0; i < listAbstractOfferEntity.length; i++)
            Container(
              padding: const EdgeInsets.only(left: 2, top: 2),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      width: 1.0, color: Theme.of(context).primaryColor),
                ),
              ),
              child: OfferCardWidget(
                abstractOfferEntity: listAbstractOfferEntity[i],
                onPressed: onTap,
                onTap: onTap,
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // BlurWidget(child: child(context)),
          child(context),
        ],
      ),
    );
  }
}
