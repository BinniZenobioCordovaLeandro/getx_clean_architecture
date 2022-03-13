import 'package:flutter/material.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class RouteCardWidget extends StatelessWidget {
  final AbstractRouteEntity? abstractRouteEntity;

  const RouteCardWidget({
    Key? key,
    this.abstractRouteEntity,
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
                    vertical: 16.0,
                  ),
                  child: WrapWidget(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: TextWidget(
                          'Destino: ${abstractRouteEntity?.to}',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
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
          ),
          CardWidget(
            color: Colors.transparent,
            child: FractionallySizedBoxWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: WrapWidget(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: TextWidget(
                        'Destino: ${abstractRouteEntity?.to}',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
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
        ],
      ),
    );
  }
}
