import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasource.dart/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/get_routes_usecase.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/places_provider.dart';

class RouteController extends GetxController {
  static RouteController get instance => Get.put(RouteController());

  var errorMessage = ''.obs;
  var futureListAbstractRouteEntity = Future.value(<AbstractRouteEntity>[]).obs;
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var position = LatLng(-12.0, -76.0).obs;
  var predictions = <Prediction>[].obs;

  final GetRoutesUsecase _getRoutesUsecase = GetRoutesUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();
  final PlacesProvider? placesProvider = PlacesProvider.getInstance();

  @override
  void onReady() {
    geolocatorProvider?.checkPermission().then((bool boolean) {
      if (boolean) {
        geolocatorProvider?.getCurrentPosition()?.then((Position? position) {
          if (position != null) {
            this.position.value = LatLng(
              position.latitude,
              position.longitude,
            );
          }
        });
      }
    }, onError: (dynamic error) {
      errorMessage.value = error.toString();
    });

    futureListAbstractRouteEntity.value = _getRoutesUsecase
        .call()!
        .then((List<AbstractRouteEntity> listAbstractRouteEntity) {
      List<Marker> listMarker = List<Marker>.empty(growable: true);
      List<Polyline> listPolyline = List<Polyline>.empty(growable: true);

      for (var abstractRouteEntity in listAbstractRouteEntity) {
        listMarker.add(
          Marker(
            width: 20,
            height: 20,
            point: LatLng(
              double.tryParse('${abstractRouteEntity.endLat}') ?? 0,
              double.tryParse('${abstractRouteEntity.endLng}') ?? 0,
            ),
            builder: (BuildContext context) => IconButton(
              icon: Icon(
                Icons.my_location_outlined,
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
              onPressed: () {
                position.value = LatLng(
                  double.tryParse('${abstractRouteEntity.endLat}') ?? 0,
                  double.tryParse('${abstractRouteEntity.endLng}') ?? 0,
                );
              },
            ),
          ),
        );
        listMarker.add(
          Marker(
            width: 20,
            height: 20,
            point: LatLng(
              double.tryParse('${abstractRouteEntity.startLat}') ?? 0,
              double.tryParse('${abstractRouteEntity.startLng}') ?? 0,
            ),
            builder: (BuildContext context) => IconButton(
              icon: Icon(
                Icons.mode_standby,
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
              onPressed: () {
                position.value = LatLng(
                  double.tryParse('${abstractRouteEntity.startLat}') ?? 0,
                  double.tryParse('${abstractRouteEntity.startLng}') ?? 0,
                );
              },
            ),
          ),
        );
        listPolyline.add(
          Polyline(
              points: <LatLng>[
                LatLng(
                  double.tryParse('${abstractRouteEntity.startLat}') ?? 0,
                  double.tryParse('${abstractRouteEntity.startLng}') ?? 0,
                ),
                LatLng(
                  double.tryParse('${abstractRouteEntity.endLat}') ?? 0,
                  double.tryParse('${abstractRouteEntity.endLng}') ?? 0,
                ),
              ],
              strokeWidth: 5,
              color: Colors.black,
              isDotted: true,
              gradientColors: <Color>[
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey[50]!.withOpacity(0.3),
                Colors.grey.withOpacity(0.3),
                Colors.grey,
              ]),
        );
      }

      markers.value = listMarker;
      polylines.value = listPolyline;

      return listAbstractRouteEntity;
    });
  }

  getPredictions(String string) {
    placesProvider?.getPredictions(string).then(
      (List<Prediction> listPrediction) {
        errorMessage.value = '';
        predictions.value = listPrediction.sublist(0, 3);
      },
      onError: (dynamic error) {
        errorMessage.value = error.toString();
      },
    );
  }
}
