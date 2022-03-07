import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/config_offer_card_widget.dart';

class OfferPage extends StatefulWidget {
  final AbstractRouteEntity abstractRouteEntity;

  const OfferPage({
    Key? key,
    required this.abstractRouteEntity,
  }) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    final MapController mapController = MapController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppBarWidget(
        title: 'Offer',
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            child: FlutterMapWidget(
              mapController: mapController,
              bounds: LatLngBounds(
                LatLng(
                  double.tryParse('${widget.abstractRouteEntity.startLat}') ??
                      0,
                  double.tryParse('${widget.abstractRouteEntity.startLng}') ??
                      0,
                ),
                LatLng(
                  double.tryParse('${widget.abstractRouteEntity.endLat}') ?? 0,
                  double.tryParse('${widget.abstractRouteEntity.endLng}') ?? 0,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SafeAreaWidget(
              child: FractionallySizedBoxWidget(
                child: ConfigOfferCardWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
