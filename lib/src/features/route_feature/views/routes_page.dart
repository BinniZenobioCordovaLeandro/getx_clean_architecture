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
import 'package:pickpointer/src/core/widgets/shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/routes_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/new_route_page.dart';
import 'package:pickpointer/src/features/route_feature/views/route_page.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/popup_marker_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/search_destination_card_widget.dart';
import 'package:pickpointer/src/features/user_feature/views/sign_in_user_page.dart';
import 'package:pickpointer/src/features/user_feature/views/user_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final RoutesController routesController = RoutesController.instance;
  final Debouncer debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBarWidget(
          title: 'PickPointer',
          actions: [
            if (routesController.isDriver.value == true)
              IconButton(
                onPressed: () async {
                  Get.to(
                    () => const NewRoutePage(),
                    arguments: {},
                  );
                },
                tooltip: 'Solicitar nueva ruta',
                icon: Icon(
                  Icons.add_location_alt_rounded,
                  color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
                ),
              ),
            IconButton(
              onPressed: () async {
                if (routesController.isSigned.value == false) {
                  await routesController.verifySession();
                }
                if (routesController.isSigned.value == true) {
                  Get.to(
                    () => const UserPage(),
                    arguments: {},
                  );
                } else {
                  Get.to(
                    () => const SignInUserPage(),
                  );
                }
              },
              tooltip: 'Mis datos',
              icon: Icon(
                Icons.co_present_outlined,
                color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              child: FlutterMapWidget(
                mapController: routesController.mapController,
                center: routesController.position.value,
                children: [
                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 20.0,
                          height: 20.0,
                          point: routesController.position.value,
                          anchorPos: AnchorPos.align(
                            AnchorAlign.top,
                          ),
                          builder: (BuildContext context) => Icon(
                            Icons.person_pin_circle_sharp,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
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
                              routesController.verifySession();
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
            if (!routesController.isLoading.value)
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  onPressed: () => routesController.moveToMyLocation(),
                  tooltip: 'Ir a mi ubicación',
                  icon: const Icon(
                    Icons.my_location,
                  ),
                ),
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
                          ?.then((LatLng latLng) => routesController
                              .mapController
                              .move(latLng, 15.0));
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
            Positioned(
              bottom: 0,
              right: 0,
              child: ShimmerWidget(
                enabled: routesController.isLoading.value,
                child: TextWidget(
                  'version ${routesController.version.value}',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: Theme.of(context).primaryColor,
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
