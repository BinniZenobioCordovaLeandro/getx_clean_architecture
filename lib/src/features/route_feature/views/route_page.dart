import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/providers/share_provider.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
import 'package:pickpointer/src/core/widgets/linear_progress_indicator_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/new_offer_page.dart';
import 'package:pickpointer/src/features/offer_feature/views/offer_page.dart';
import 'package:pickpointer/src/features/payment_feature/views/payment_page.dart';
import 'package:pickpointer/src/features/route_feature/logic/route_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/new_offer_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/offer_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/offers_empty_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/popup_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/route_card_widget.dart';
import 'package:pickpointer/src/features/user_feature/views/sign_in_user_page.dart';
import 'package:pickpointer/src/features/user_feature/views/user_page.dart';

class RoutePage extends StatefulWidget {
  final String? abstractRouteEntityId;
  final AbstractRouteEntity? abstractRouteEntity;

  const RoutePage({
    Key? key,
    this.abstractRouteEntity,
    this.abstractRouteEntityId,
  }) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final RouteController routeController = RouteController.instance;

  newOfferModal() {
    ModalBottomSheetHelper(
      key: const Key('newOfferModal'),
      context: context,
      title: 'Realizar ruta',
      child: NewOfferPage(
        key: const Key('newOfferPageModal'),
        abstractRouteEntity: routeController.abstractRouteEntity!,
      ),
      complete: () {
        routeController.onReady();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: 'PickPointer',
          showGoback: true,
          actions: [
            if (routeController.isDriver.value)
              IconButton(
                onPressed: () async {
                  if (routeController.isSigned.value) {
                    if (routeController.onRoad.value) {
                      ModalBottomSheetHelper(
                        context: context,
                        title: 'Ya estas en cola en una ruta!',
                        child: SizedBox(
                          width: double.infinity,
                          child: FractionallySizedBoxWidget(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: ElevatedButtonWidget(
                                title: 'IR A RUTA',
                                onPressed: () {
                                  Get.to(
                                    () => OfferPage(
                                      abstractOfferEntityId:
                                          routeController.currentOfferId.value,
                                    ),
                                    arguments: {
                                      'abstractOfferEntityId':
                                          routeController.currentOfferId.value,
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      newOfferModal();
                    }
                  } else {
                    Get.to(
                      () => const SignInUserPage(),
                    );
                  }
                },
                tooltip: 'Realizar ruta',
                icon: Icon(
                  Icons.taxi_alert_outlined,
                  color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
                ),
              ),
            IconButton(
              tooltip: 'Compartir',
              icon: const Icon(
                Icons.ios_share_rounded,
              ),
              onPressed: () {
                ShareProvider().string(
                  'pickpointer://pickpointer.com/route/${routeController.routeId.value}',
                  subject: 'Comparte esta popular ruta',
                );
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Desactivar notificacion"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  routeController.unsubscribeToRouteTopic();
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            FlutterMapWidget(
              onMapCreated: (MapController controller) {
                routeController.mapController = controller;
              },
              children: [
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                    markers: [
                      Marker(
                        key: Key(
                            '${routeController.abstractRouteEntity?.id}_end'),
                        width: 50,
                        height: 50,
                        anchorPos: AnchorPos.align(
                          AnchorAlign.top,
                        ),
                        point: LatLng(
                          double.tryParse(
                                  '${routeController.abstractRouteEntity?.endLat}') ??
                              0,
                          double.tryParse(
                                  '${routeController.abstractRouteEntity?.endLng}') ??
                              0,
                        ),
                        builder: (BuildContext context) => const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    ],
                    popupBuilder: (BuildContext context, Marker marker) {
                      return PopupCardWidget(
                        message:
                            "Hasta:\n${routeController.abstractRouteEntity?.to}",
                        onTap: () {},
                      );
                    },
                  ),
                ),
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                    markers: [
                      Marker(
                        key: Key(
                            '${routeController.abstractRouteEntity?.id}_start'),
                        width: 50,
                        height: 50,
                        anchorPos: AnchorPos.align(
                          AnchorAlign.center,
                        ),
                        point: LatLng(
                          double.tryParse(
                                  '${routeController.abstractRouteEntity?.startLat}') ??
                              0,
                          double.tryParse(
                                  '${routeController.abstractRouteEntity?.startLng}') ??
                              0,
                        ),
                        builder: (BuildContext context) => const Icon(
                          Icons.taxi_alert_outlined,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    ],
                    popupBuilder: (BuildContext context, Marker marker) {
                      return PopupCardWidget(
                        message:
                            "Desde:\n${routeController.abstractRouteEntity?.from}",
                        onTap: () {},
                      );
                    },
                  ),
                ),
                MarkerLayerWidget(
                  options: MarkerLayerOptions(
                    markers: [
                      for (var wayPoint in routeController.listWayPoints.value)
                        Marker(
                          width: 20,
                          height: 20,
                          anchorPos: AnchorPos.align(
                            AnchorAlign.top,
                          ),
                          point: wayPoint,
                          builder: (BuildContext context) => Icon(
                            Icons.person_pin,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                PolylineLayerWidget(
                  options: PolylineLayerOptions(
                    // ignore: invalid_use_of_protected_member
                    polylines: [
                      Polyline(
                        points: <LatLng>[
                          ...routeController.polylineListLatLng.value,
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
              ],
            ),
            if (routeController.isLoading.value)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicatorWidget(),
              ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: SafeAreaWidget(
                child: FractionallySizedBoxWidget(
                  child: ShimmerWidget(
                    enabled: routeController.isLoading.value,
                    child: RouteCardWidget(
                      to: routeController.routeTo.value,
                      from: routeController.routeFrom.value,
                      duration: routeController.travelTime.value,
                      meters: routeController.travelDistance.value,
                    ),
                  ),
                ),
              ),
            ),
            if (routeController.listAbstractOfferEntity.isEmpty &&
                !routeController.isDriver.value &&
                !routeController.isLoading.value)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SafeAreaWidget(
                  child: FractionallySizedBoxWidget(
                    child: OffersEmptyCardCardWidget(
                      isLoading: routeController.isLoading.value,
                      onPressed: () {
                        routeController.subscribeToRouteTopic();
                      },
                    ),
                  ),
                ),
              ),
            if (routeController.listAbstractOfferEntity.isEmpty &&
                routeController.isDriver.value &&
                !routeController.isLoading.value)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SafeAreaWidget(
                  child: FractionallySizedBoxWidget(
                    child: NewOfferCardWidget(
                      price: routeController.routePrice.value,
                      isLoading: routeController.isLoading.value,
                      onPressed: newOfferModal,
                    ),
                  ),
                ),
              ),
            if (routeController.listAbstractOfferEntity.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
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
                            children: <Widget>[
                              for (final AbstractOfferEntity abstractOfferEntity
                                  in routeController
                                      .listAbstractOfferEntity.value)
                                if (routeController.onRoad.value &&
                                    !(routeController.currentOfferId.value ==
                                        abstractOfferEntity.id))
                                  SizedBox(
                                    child: TextWidget(
                                      '${abstractOfferEntity.userName} esperando...',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  )
                                else
                                  OfferCardWidget(
                                    abstractOfferEntity: abstractOfferEntity,
                                    onTap: (abstractOfferEntity) {
                                      routeController.mapController
                                          ?.fitBounds(LatLngBounds(
                                        LatLng(
                                            double.parse(
                                                '${abstractOfferEntity.startLat}'),
                                            double.parse(
                                                '${abstractOfferEntity.startLng}')),
                                        LatLng(
                                            double.parse(
                                                '${abstractOfferEntity.endLat}'),
                                            double.parse(
                                                '${abstractOfferEntity.endLng}')),
                                      ));
                                      routeController.showOfferPolylineMarkers(
                                          abstractOfferEntity);
                                    },
                                    onPressed: !routeController.onRoad.value
                                        ? (abstractOfferEntity) async {
                                            if (routeController
                                                        .isSigned.value ==
                                                    false ||
                                                routeController.isPhoneVerified
                                                        .value ==
                                                    false) {
                                              await routeController
                                                  .verifySession();
                                            }
                                            if (routeController
                                                .isSigned.value) {
                                              if (routeController
                                                      .isPhoneVerified.value ==
                                                  false) {
                                                GetxSnackbarWidget(
                                                  title:
                                                      'VERIFICA TU NUMERO DE CELULAR',
                                                  subtitle:
                                                      'Por favor agrega y verifica tu número de dispositivo.',
                                                );
                                                Get.to(
                                                  () => const UserPage(),
                                                  arguments: {},
                                                );
                                              } else {
                                                Get.to(
                                                  () => PaymentPage(
                                                    abstractOfferEntity:
                                                        abstractOfferEntity,
                                                  ),
                                                  arguments: {
                                                    'abstractOfferEntity':
                                                        abstractOfferEntity,
                                                  },
                                                );
                                              }
                                            } else {
                                              Get.to(
                                                () => const SignInUserPage(),
                                              );
                                            }
                                          }
                                        : null,
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
