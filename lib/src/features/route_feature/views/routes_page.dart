import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/util/debounder_util.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/card_alert_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/linear_progress_indicator_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/routes_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/route_page.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/popup_marker_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/search_destination_card_widget.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final RoutesController routesController = RoutesController.instance;
  final MapController mapController = MapController();
  final Debouncer debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBarWidget(
          title: 'PickPointer',
          actions: [
            IconButton(
              onPressed: () {},
              tooltip: 'Create route',
              icon: Icon(
                Icons.add_location_alt_rounded,
                color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
              ),
            ),
          ],
        ),
        body: Obx(() {
          WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
            mapController.move(routesController.position.value, 15.0);
          });
          return Stack(
            children: [
              SizedBox(
                child: FlutterMapWidget(
                  mapController: mapController,
                  center: routesController.position.value,
                  children: [
                    MarkerLayerWidget(
                      options: MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 20,
                            height: 20,
                            point: routesController.position.value,
                            anchorPos: AnchorPos.align(
                              AnchorAlign.top,
                            ),
                            builder: (BuildContext context) => IconButton(
                              icon: Icon(
                                Icons.location_history,
                                color: Theme.of(context).primaryColor,
                                size: 50.0,
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                    PolylineLayerWidget(
                      options: PolylineLayerOptions(
                        // ignore: invalid_use_of_protected_member
                        polylines: routesController.polylines.value,
                      ),
                    ),
                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                        // ignore: invalid_use_of_protected_member
                        markers: routesController.markers.value,
                        popupAnimation: const PopupAnimation.fade(
                          duration: Duration(
                            milliseconds: 700,
                          ),
                        ),
                        markerTapBehavior: MarkerTapBehavior.togglePopup(),
                        markerCenterAnimation: const MarkerCenterAnimation(),
                        popupBuilder: (BuildContext context, Marker marker) {
                          RegExp regExp = RegExp(r"'(.*)'");
                          String? idAbstractRouteEntity = regExp
                              .firstMatch('${marker.key.reactive.value}')
                              ?.group(1);
                          if (idAbstractRouteEntity != null) {
                            AbstractRouteEntity abstractRouteEntity =
                                routesController
                                    .mapRoutes
                                    // ignore: invalid_use_of_protected_member
                                    .value[idAbstractRouteEntity];
                            return PopupMarkerCardWidget(
                              abstractRouteEntity: abstractRouteEntity,
                              onTap: () {
                                Get.to(
                                  () => RoutePage(
                                    abstractRouteEntity: abstractRouteEntity,
                                  ),
                                  arguments: {
                                    'abstractRouteEntity': abstractRouteEntity,
                                  },
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (routesController.isLoading.value)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicatorWidget(),
                ),
              if (routesController.errorMessage.value.length >= 3)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: SafeAreaWidget(
                    child: FractionallySizedBoxWidget(
                      child: CardAlertWidget(
                        title: 'Error',
                        message: routesController.errorMessage.value,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SafeAreaWidget(
                  child: FractionallySizedBoxWidget(
                    child: SearchDestinationCardWidget(
                      // ignore: invalid_use_of_protected_member
                      predictions: routesController.predictions.value,
                      onTapPrediction: (Prediction prediction) {
                        routesController
                            .getPlaceDetail('${prediction.placeId}')
                            ?.then((LatLng latLng) =>
                                mapController.move(latLng, 15.0));
                        routesController.cleanPredictions();
                      },
                      onChanged: (String string) {
                        if (string.length >= 3) {
                          debouncer.run(() {
                            routesController.getPredictions(string);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
