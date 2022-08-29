import 'package:flutter/material.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class PopupMarkerCardWidget extends StatelessWidget {
  final AbstractRouteEntity? abstractRouteEntity;
  final Function()? onTap;

  const PopupMarkerCardWidget({
    Key? key,
    this.abstractRouteEntity,
    this.onTap,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                    'Desde: S/. ${abstractRouteEntity?.price}',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextWidget(
                    'Destino: ${abstractRouteEntity?.to}',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextWidget(
                    'Origen: ${abstractRouteEntity?.from}',
                    textAlign: TextAlign.justify,
                  ),
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
      width: 300,
      height: 120,
      child: Stack(
        children: [
          BlurWidget(
            child: child(context),
          ),
          child(context),
        ],
      ),
    );
  }
}
