import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasources/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/get_routes_usecase.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/providers/package_info_provider.dart';
import 'package:pickpointer/src/core/providers/places_provider.dart';

class RoutesController extends GetxController {
  static RoutesController get instance => Get.put(RoutesController());

  MapController? mapController;
  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var routes = <AbstractRouteEntity>[].obs;
  var filteredRoutes = <AbstractRouteEntity>[].obs;
  var mapRoutes = {}.obs;
  var futureListAbstractRouteEntity = Future.value().obs;
  var futureAbstractSessionEntity = Future.value().obs;
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var position = LatLng(-12.0, -76.0).obs;
  var predictions = <Prediction>[].obs;
  var version = 'x.x.x'.obs;

  final GetRoutesUsecase _getRoutesUsecase = GetRoutesUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();
  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();
  final PlacesProvider? placesProvider = PlacesProvider.getInstance();
  StreamSubscription<Position>? streamPosition;

  moveToMyLocation() {
    WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      mapController?.move(position.value, 15.0);
    });
  }

  prepareStreamCurrentPosition() {
    streamPosition =
        geolocatorProvider!.onPositionChanged.listen((Position streamPosition) {
      print('position: $streamPosition');
      position.value =
          LatLng(streamPosition.latitude, streamPosition.longitude);
    });
  }

  getCurrentPosition() {
    geolocatorProvider?.getCurrentPosition()?.then((Position? position) {
      if (position != null) {
        this.position.value = LatLng(
          position.latitude,
          position.longitude,
        );
        moveToMyLocation();
        prepareStreamCurrentPosition();
      }
      isLoading.value = false;
    }).catchError((error) {
      print(error);
      errorMessage.value = error.toString();
      print('error trying get position');
    });
  }

  getPredictions(String string) {
    placesProvider?.getPredictions(string).then(
      (List<Prediction> listPrediction) {
        errorMessage.value = '';
        if (listPrediction.length > 3) {
          predictions.value = listPrediction.sublist(0, 3);
        } else {
          predictions.value = listPrediction;
        }
      },
      onError: (dynamic error) {
        errorMessage.value = error.toString();
      },
    );
  }

  onFilterDestain(
    String? to,
    String? from,
  ) {
    if (to != null && from != null) {
      RegExp regExpFrom = RegExp(from.toLowerCase());
      RegExp regExpTo = RegExp(to.toLowerCase());
      filteredRoutes.value = routes.value
          .where((AbstractRouteEntity route) =>
              regExpFrom.hasMatch('${route.from?.toLowerCase()}') &&
              regExpTo.hasMatch('${route.to?.toLowerCase()}'))
          .toList();
    } else if (to != null) {
      RegExp regExpTo = RegExp(to.toLowerCase());
      filteredRoutes.value = routes.value
          .where((AbstractRouteEntity route) =>
              regExpTo.hasMatch('${route.to?.toLowerCase()}'))
          .toList();
    }
  }

  Future<LatLng>? getPlaceDetail(String placeId) {
    Future<LatLng>? futureLatLng =
        placesProvider?.getPlaceDetails(placeId).then(
      (PlacesDetailsResponse placeDetailsResponse) {
        errorMessage.value = '';
        LatLng latLng = LatLng(
          placeDetailsResponse.result.geometry!.location.lat,
          placeDetailsResponse.result.geometry!.location.lng,
        );
        return latLng;
      },
      onError: (dynamic error) {
        errorMessage.value = error.toString();
      },
    );
    return futureLatLng;
  }

  cleanPredictions() {
    predictions.value = <Prediction>[];
  }

  @override
  void onReady() {
    isLoading.value = true;

    notificationProvider?.checkPermission();
    getCurrentPosition();

    futureListAbstractRouteEntity.value = _getRoutesUsecase
        .call()!
        .then((List<AbstractRouteEntity> listAbstractRouteEntity) {
      List<Marker> listMarker = List<Marker>.empty(growable: true);
      List<Polyline> listPolyline = List<Polyline>.empty(growable: true);
      Map<String, AbstractRouteEntity> mapStringAbstractRouteEntity = {};

      for (var abstractRouteEntity in listAbstractRouteEntity) {
        listMarker.add(
          Marker(
            key: Key('${abstractRouteEntity.id}_end'),
            width: 50,
            height: 50,
            anchorPos: AnchorPos.align(
              AnchorAlign.top,
            ),
            point: LatLng(
              double.tryParse('${abstractRouteEntity.endLat}') ?? 0,
              double.tryParse('${abstractRouteEntity.endLng}') ?? 0,
            ),
            builder: (BuildContext context) => const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 50,
            ),
          ),
        );
        mapStringAbstractRouteEntity['${abstractRouteEntity.id}_end'] =
            abstractRouteEntity;
        listMarker.add(
          Marker(
            key: Key('${abstractRouteEntity.id}_start'),
            width: 50,
            height: 50,
            anchorPos: AnchorPos.align(
              AnchorAlign.center,
            ),
            point: LatLng(
              double.tryParse('${abstractRouteEntity.startLat}') ?? 0,
              double.tryParse('${abstractRouteEntity.startLng}') ?? 0,
            ),
            builder: (BuildContext context) => const Icon(
              Icons.taxi_alert_outlined,
              color: Colors.blue,
              size: 50,
            ),
          ),
        );
        mapStringAbstractRouteEntity['${abstractRouteEntity.id}_start'] =
            abstractRouteEntity;
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
              Colors.blue.withOpacity(0.3),
              Colors.red.withOpacity(0.3),
            ],
          ),
        );
      }

      markers.value = listMarker;
      polylines.value = listPolyline;
      routes.value = listAbstractRouteEntity;
      mapRoutes.value = mapStringAbstractRouteEntity;

      return listAbstractRouteEntity;
    });
    super.onReady();
  }

  @override
  void onClose() {
    streamPosition?.cancel();
    super.onClose();
  }
}
