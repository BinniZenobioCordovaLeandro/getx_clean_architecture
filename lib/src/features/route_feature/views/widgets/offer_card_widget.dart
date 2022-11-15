import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/circle_avatar_image_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/outline_button_widget.dart';
import 'package:pickpointer/src/core/widgets/rank_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class OfferCardWidget extends StatelessWidget {
  final AbstractOfferEntity abstractOfferEntity;
  final Function(AbstractOfferEntity abstractOfferEntity)? onTap;
  final Function(AbstractOfferEntity abstractOfferEntity)? onPressed;

  const OfferCardWidget({
    Key? key,
    required this.abstractOfferEntity,
    this.onTap,
    this.onPressed,
  }) : super(key: key);

  child(BuildContext context) {
    DateTime currentDateTime = DateTime.now();
    bool? isOnDate = abstractOfferEntity.dateTime?.isBefore(currentDateTime);
    String? dateString =
        DateFormat('dd/MM/yyyy kk:mm a').format(abstractOfferEntity.dateTime!);
    int? availableSeat =
        abstractOfferEntity.maxCount! - abstractOfferEntity.count!;
    return CardWidget(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap!(abstractOfferEntity);
        },
        child: FractionallySizedBoxWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Column(
              children: <Widget>[
                if (isOnDate == true)
                  SizedBox(
                    width: double.infinity,
                    child: TextWidget(
                      'SALE AHORA',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: TextWidget(
                      'SALIDA $dateString',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: TextWidget(
                      '$availableSeat asiento${availableSeat > 1 ? "s" : ""} disponible${availableSeat > 1 ? "s" : ""}'),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      child: CircleAvatarImageWidget(
                        urlSvgOrImage: '${abstractOfferEntity.userAvatar}',
                      ),
                    ),
                    SizedBox(
                      child: CircleAvatarImageWidget(
                        urlSvgOrImage: '${abstractOfferEntity.userCarPhoto}',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          TextWidget(
                            '${abstractOfferEntity.userCarModel} ${abstractOfferEntity.userCarColor}',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          TextWidget('${abstractOfferEntity.userName}'),
                        ],
                      ),
                    ),
                    if (onPressed != null)
                      Expanded(
                        flex: 1,
                        child: OutlinedButtonWidget(
                          title: 'S/ ${abstractOfferEntity.price}',
                          onPressed: () {
                            onPressed!(abstractOfferEntity);
                          },
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
          BlurWidget(child: child(context)),
          child(context),
          Positioned(
            top: -10,
            right: -45,
            child: SizedBox(
              child: Transform.scale(
                scale: 0.5,
                child: RankWidget(
                  value:
                      double.tryParse('${abstractOfferEntity.userRank}') ?? 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
