import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/features/offer_feature/logic/offer_controller.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/popup_marker_passenger_widget.dart';

class OfferPage extends StatefulWidget {
  final String? abstractOfferEntityId;
  final AbstractOfferEntity? abstractOfferEntity;

  const OfferPage({
    Key? key,
    this.abstractOfferEntity,
    this.abstractOfferEntityId,
  }) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  final OfferController offerController = OfferController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBarWidget(
          title: 'On Road!',
          actions: [
            IconButton(
              tooltip: 'Compartir',
              icon: const Icon(
                Icons.ios_share_rounded,
              ),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Mensajes',
              icon: const Icon(
                Icons.message_rounded,
              ),
              onPressed: () {
                offerController.scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              child: FlutterMapWidget(
                mapController: offerController.mapController,
                children: [
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 50,
                          height: 50,
                          anchorPos: AnchorPos.align(
                            AnchorAlign.center,
                          ),
                          point: offerController.positionTaxi.value,
                          builder: (BuildContext context) => Icon(
                            Icons.local_taxi_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ),
                      ],
                      popupBuilder: (BuildContext context, Marker marker) {
                        return const PopupMarkerPassengerWidget(
                          meters: 199,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (!offerController.isLoading.value)
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  onPressed: () => offerController.moveToMyLocation(),
                  tooltip: 'Ir a mi ubicación',
                  icon: const Icon(
                    Icons.my_location,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
