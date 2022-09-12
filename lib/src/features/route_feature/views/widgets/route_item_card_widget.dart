import 'package:flutter/material.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/Ink_well_widget.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class RouteItemCardWidget extends StatelessWidget {
  final AbstractRouteEntity? abstractRouteEntity;
  final void Function()? onTap;

  const RouteItemCardWidget({
    Key? key,
    this.abstractRouteEntity,
    this.onTap,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      child: InkWellWidget(
        onTap: onTap,
        child: FractionallySizedBoxWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: WrapWidget(
              runSpacing: 2,
              spacing: 2,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: TextWidget(
                    'Destino: ${abstractRouteEntity?.to}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextWidget(
                    'Desde S/. ${abstractRouteEntity?.price}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          child(context),
        ],
      ),
    );
  }
}
