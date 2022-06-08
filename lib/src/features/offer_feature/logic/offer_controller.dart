import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/vehicle_package/data/datasources/vehicle_datasources/firebase_vehicle_datasource.dart';
import 'package:pickpointer/packages/vehicle_package/data/models/vehicle_model.dart';
import 'package:pickpointer/packages/vehicle_package/domain/usecases/update_vehicle_usecase.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';

class OfferController extends GetxController {
  static OfferController get instance => Get.put(OfferController());

  final MapController mapController = MapController();
  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();

  UpdateVehicleUsecase updateVehicleUsecase = UpdateVehicleUsecase(
    abstractVehicleRepository: FirebaseVehicleDatasource(),
  );

  StreamSubscription<Position>? streamPosition;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var positionTaxi = LatLng(-12.0, -76.0).obs;
  var listWayPoints = <LatLng>[].obs;
  var polylineListLatLng = <LatLng>[].obs;

  moveToMyLocation() {
    WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      mapController.move(positionTaxi.value, 15.0);
    });
  }

  Future<List<LatLng>> getPolylineBetweenCoordinates({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? wayPoints,
  }) {
    isLoading.value = true;
    Future<List<LatLng>> futureListLatLng = polylineProvider!
        .getPolylineBetweenCoordinates(
      origin: origin,
      destination: destination,
      wayPoints: wayPoints,
    )
        .then((List<LatLng> listLatLng) {
      isLoading.value = false;
      return listLatLng;
    });
    return futureListLatLng;
  }

  prepareStreamCurrentPosition() {
    streamPosition =
        geolocatorProvider!.streamPosition().listen((Position position) {
      print('position: $position');
      positionTaxi.value = LatLng(position.latitude, position.longitude);
      mapController.move(positionTaxi.value, 15);
      updateVehicleUsecase.call(
          vehicle: VehicleModel(
        id: '1',
        lat: '${position.latitude}',
        lng: '${position.longitude}',
      ));
    }, onError: (error) {
      print('error: $error');
    }, onDone: () {
      print('done');
    }, cancelOnError: true);
  }

  showOfferPolylineMarkers(AbstractOfferEntity abstractOfferEntity) {
    List<LatLng> listLatLng = [];
    String? wayPoints = abstractOfferEntity.wayPoints;
    if (wayPoints != null && wayPoints.length > 10) {
      List list = jsonDecode(wayPoints);
      listLatLng = list.map((string) {
        var split = string.split(',');
        LatLng latLng = LatLng(
          double.parse(split[0].trim()),
          double.parse(split[1].trim()),
        );
        return latLng;
      }).toList();
    }
    listWayPoints.value = listLatLng;
    getPolylineBetweenCoordinates(
      origin: LatLng(
        double.parse('${abstractOfferEntity.startLat}'),
        double.parse('${abstractOfferEntity.startLng}'),
      ),
      destination: LatLng(
        double.parse('${abstractOfferEntity.endLat}'),
        double.parse('${abstractOfferEntity.endLng}'),
      ),
      wayPoints: listLatLng,
    ).then(
      (value) => polylineListLatLng.value = value,
    );
  }

  @override
  void onInit() {
    prepareStreamCurrentPosition();
    super.onInit();
  }

  @override
  void onReady() {
    AbstractOfferEntity abstractOfferEntity =
        Get.arguments['abstractOfferEntity'];
    showOfferPolylineMarkers(abstractOfferEntity);
    streamPosition!.resume();
    moveToMyLocation();
    super.onReady();
  }

  @override
  void onClose() {
    streamPosition!.cancel();
    super.onClose();
  }
}
