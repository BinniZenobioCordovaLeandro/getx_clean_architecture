import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          BlurWidget(
            child: CardWidget(
              color: Colors.transparent,
              child: FractionallySizedBoxWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: TextWidget(
                            'Listo ${abstractOfferEntity.count} de ${abstractOfferEntity.maxCount} personas'),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          SizedBox(
                            child: CircleAvatarImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity.userAvatar}',
                            ),
                          ),
                          SizedBox(
                            child: CircleAvatarImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity.userCarPhoto}',
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                TextWidget(
                                  'Hyundai Negro',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextWidget('${abstractOfferEntity.userName}'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Opacity(
                              opacity: 0,
                              child: OutlinedButtonWidget(
                                title: 'S/. ${abstractOfferEntity.price}',
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CardWidget(
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
                      SizedBox(
                        width: double.infinity,
                        child: TextWidget(
                            'Listo ${abstractOfferEntity.count} de ${abstractOfferEntity.maxCount} personas'),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          SizedBox(
                            child: CircleAvatarImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity.userAvatar}',
                            ),
                          ),
                          SizedBox(
                            child: CircleAvatarImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity.userCarPhoto}',
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                TextWidget(
                                  'Hyundai Negro',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextWidget('${abstractOfferEntity.userName}'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: OutlinedButtonWidget(
                              title: 'S/. ${abstractOfferEntity.price}',
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
          ),
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
