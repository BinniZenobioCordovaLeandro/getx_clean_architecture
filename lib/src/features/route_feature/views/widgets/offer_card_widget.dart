import 'package:flutter/material.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/outline_button_widget.dart';
import 'package:pickpointer/src/core/widgets/rank_widget.dart';
import 'package:pickpointer/src/core/widgets/svg_or_image_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class OfferCardWidget extends StatelessWidget {
  final AbstractOfferEntity? abstractOfferEntity;

  const OfferCardWidget({
    Key? key,
    this.abstractOfferEntity,
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
                            'Listo ${abstractOfferEntity?.count} de ${abstractOfferEntity?.maxCount} personas'),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          CircleAvatar(
                            child: SvgOrImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity?.userAvatar}',
                            ),
                          ),
                          CircleAvatar(
                            child: SvgOrImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity?.userCarPhoto}',
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                TextWidget(
                                  '${abstractOfferEntity?.userCarPlate}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextWidget('${abstractOfferEntity?.userName}'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: OutlinedButtonWidget(
                              title: 'S/. ${abstractOfferEntity?.price}',
                              onPressed: () {},
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
              onTap: () {},
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
                            'Listo ${abstractOfferEntity?.count} de ${abstractOfferEntity?.maxCount} personas'),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          CircleAvatar(
                            child: SvgOrImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity?.userAvatar}',
                            ),
                          ),
                          CircleAvatar(
                            child: SvgOrImageWidget(
                              urlSvgOrImage:
                                  '${abstractOfferEntity?.userCarPhoto}',
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                TextWidget(
                                  '${abstractOfferEntity?.userCarPlate}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextWidget('${abstractOfferEntity?.userName}'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: OutlinedButtonWidget(
                              title: 'S/. ${abstractOfferEntity?.price}',
                              onPressed: () {},
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
                      double.tryParse('${abstractOfferEntity?.userRank}') ?? 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}