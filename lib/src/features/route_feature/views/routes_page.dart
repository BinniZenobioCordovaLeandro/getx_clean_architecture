import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/card_alert_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/route_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/search_destination_card_widget.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final RouteController routeController = RouteController.instance;
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(
          title: 'PickPointer routes',
        ),
        body: Obx(() {
          WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
            mapController.move(routeController.position.value, 13.0);
          });
          return Stack(
            children: [
              SizedBox(
                child: FlutterMapWidget(
                  mapController: mapController,
                  center: routeController.position.value,
                  layers: [
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 20,
                          height: 20,
                          point: routeController.position.value,
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
                    MarkerLayerOptions(
                      // ignore: invalid_use_of_protected_member
                      markers: routeController.markers.value,
                    ),
                    PolylineLayerOptions(
                      // ignore: invalid_use_of_protected_member
                      polylines: routeController.polylines.value,
                    )
                  ],
                ),
              ),
              if (routeController.errorMessage.value.length >= 3)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: SafeAreaWidget(
                    child: FractionallySizedBoxWidget(
                      child: CardAlertWidget(
                        title: 'Error',
                        message: routeController.errorMessage.value,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SafeAreaWidget(
                  child: SizedBox(
                    width: double.infinity,
                    child: FractionallySizedBoxWidget(
                      child: SearchDestinationCardWidget(
                        // ignore: invalid_use_of_protected_member
                        predictions: routeController.predictions.value,
                        onTapPrediction: (Prediction prediction) {
                          // ignore: avoid_print
                          print(prediction);
                        },
                        onChanged: (String string) {
                          routeController.getPredictions(string);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
