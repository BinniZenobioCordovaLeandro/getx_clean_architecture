import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/offer_feature/logic/offer_controller.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/accept_passenger_card_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/finish_trip_card_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/offer_card_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/popup_marker_passenger_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/widgets/start_trip_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/offer_card_widget.dart';
import 'package:progress_state_button/progress_button.dart';

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
          title: 'Offer ${offerController.offerId.value}',
          actions: [
            IconButton(
              tooltip: 'Refrescar',
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              onPressed: () => offerController.refreshOffer(),
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
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Finalizar viaje"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  ModalBottomSheetHelper(
                    context: context,
                    title: 'Finalizar viaje',
                    child: SizedBox(
                      width: double.infinity,
                      child: FractionallySizedBoxWidget(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WrapWidget(
                            children: [
                              TextWidget(
                                '¿Estás seguro de que deseas finalizar el viaje?',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              TextWidget(
                                'Si finalizas el viaje, no podrás volver a acceder a él. \nAdemas, si finalizas sin haber completado el viaje llegaras a afectar tu calificación. \n\nSolo hazlo si estás seguro de no tener pasajeros en el viaje o a la espera.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              ProgressStateButtonWidget(
                                state: offerController.isLoading.value
                                    ? ButtonState.loading
                                    : ButtonState.success,
                                success: 'Finalizar',
                                onPressed: () {
                                  offerController.finishTrip();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              child: FlutterMapWidget(
                onMapCreated: (MapController mapController) {
                  offerController.mapController = mapController;
                },
                children: [
                  PolylineLayerWidget(
                    options: PolylineLayerOptions(
                      polylines: [
                        Polyline(
                          points: <LatLng>[
                            ...offerController.polylineListLatLng.value,
                          ],
                          strokeWidth: 5,
                          color: Colors.black,
                          isDotted: true,
                          gradientColors: <Color>[
                            Colors.blue,
                            Colors.red,
                            Colors.red,
                            Colors.red,
                            Colors.red,
                            Colors.red,
                          ],
                        ),
                      ],
                    ),
                  ),
                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        for (var wayPoint
                            in offerController.listWayPoints.value)
                          Marker(
                            width: 10,
                            height: 10,
                            anchorPos: AnchorPos.align(AnchorAlign.center),
                            point: wayPoint,
                            builder: (BuildContext context) => Icon(
                              Icons.circle,
                              color: Theme.of(context).primaryColor,
                              size: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                  for (var order in offerController.listOrders.value)
                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 50,
                            height: 50,
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            point: LatLng(
                              double.parse(order["pickPointLat"]),
                              double.parse(order["pickPointLng"]),
                            ),
                            builder: (BuildContext context) => Icon(
                              Icons.person_pin,
                              color: Theme.of(context).primaryColor,
                              size: 50,
                            ),
                          ),
                        ],
                        popupBuilder: (BuildContext context, Marker marker) {
                          return PopupMarkerPassengerWidget(
                            meters: offerController.distanceBetween(
                              start: offerController.positionTaxi.value,
                              end: LatLng(
                                double.parse(order["pickPointLat"]),
                                double.parse(order["pickPointLng"]),
                              ),
                            ),
                            avatar: order['avatar'],
                            fullName: order['fullName'],
                          );
                        },
                      ),
                    ),
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 50,
                          height: 50,
                          anchorPos: AnchorPos.align(AnchorAlign.center),
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
                          meters: 0,
                          avatar:
                              'https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png',
                          fullName: 'Driver position',
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
                  onPressed: () {
                    offerController.move(offerController.positionTaxi.value);
                  },
                  tooltip: 'Ir a mi ubicación',
                  icon: const Icon(
                    Icons.my_location,
                  ),
                ),
              ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: SafeAreaWidget(
                child: FractionallySizedBoxWidget(
                  child: ShimmerWidget(
                    enabled: offerController.isLoading.value,
                    child: OfferDescriptionCardWidget(
                      to: offerController.offerTo.value,
                      from: offerController.offerFrom.value,
                      price: offerController.offerPrice.value,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 0.0,
              right: 0.0,
              child: SafeAreaWidget(
                child: SizedBox(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    child: FractionallySizedBoxWidget(
                      child: SingleChildScrollViewWidget(
                        child: WrapWidget(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (var order in offerController.listOrders.value)
                              (offerController.distanceBetween(
                                        start:
                                            offerController.positionTaxi.value,
                                        end: LatLng(
                                          double.parse(order["pickPointLat"]),
                                          double.parse(order["pickPointLng"]),
                                        ),
                                      ) <
                                      1000)
                                  ? AcceptPassengerCardWidget(
                                      avatar: order['avatar'],
                                      fullName: order['fullName'],
                                      phoneNumber: order['phoneNumber'],
                                      onPressed: () {
                                        offerController
                                            .firebaseNotificationProvider
                                            ?.sendMessage(
                                          to: [order['tokenMessaging']],
                                          title: '¡Bienvenido a bordo!',
                                          body:
                                              'Procura usar mascarilla y saludar, ${order['fullName']}',
                                          isMessage: true,
                                          link: '/order/${order["orderId"]}',
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                            if (offerController.distanceBetween(
                                  start: offerController.positionTaxi.value,
                                  end: offerController.offerEnd.value,
                                ) <
                                2000)
                              FinishTripCardWidget(
                                isLoading: offerController.isLoading.value,
                                onPressed: () {
                                  offerController.finishTrip();
                                },
                              ),
                            if (offerController.offerStateId.value == '-1')
                              StartTripCardWidget(
                                isLoading: offerController.isLoading.value,
                                customersAvatar: [
                                  for (var order
                                      in offerController.listOrders.value)
                                    order['avatar'],
                                ],
                                onPressed: () {
                                  offerController
                                      .startTrip()
                                      .then((bool boolean) {
                                    if (boolean == true) {
                                      offerController.refreshOffer();
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
