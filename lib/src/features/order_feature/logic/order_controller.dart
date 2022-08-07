import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/order_package/data/datasources/firebase_order_datasource.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/usecases/get_order_usecase.dart';
import 'package:pickpointer/packages/vehicle_package/data/datasources/vehicle_datasources/firebase_vehicle_datasource.dart';
import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/usecases/stream_vehicle_usecase.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.put(OrderController());

  final MapController mapController = MapController();

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();

  NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final GetOrderUsecase _getOrderUsecase = GetOrderUsecase(
    abstractOrderRepository: FirebaseOrderDatasource(),
  );

  StreamVehicleUsecase streamVehicleUsecase = StreamVehicleUsecase(
    abstractVehicleRepository: FirebaseVehicleDatasource(),
  );

  StreamSubscription<Position>? streamPosition;
  StreamSubscription<AbstractVehicleEntity>? streamTaxiPosition;

  AbstractOrderEntity? abstractOrderEntity;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var polylineListLatLng = <LatLng>[].obs;
  var listWayPoints = <LatLng>[].obs;
  var polylineTaxiListLatLng = <LatLng>[].obs;
  var distanceTaxi = 0.0.obs;
  var clientPosition = LatLng(-12.0, -76.0).obs;
  var taxiPosition = LatLng(-12.0, -76.0).obs;
  var pickPoint = LatLng(-12.0, -76.0).obs;
  var latLngBounds = <LatLng>[].obs;

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

  Future<bool>? sendNotification() {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'title',
          body: 'body',
        )
        .then((value) => value);
    return futureBool;
  }

  streamCurrentTaxiPosition(AbstractOrderEntity abstractOrderEntity) {
    streamTaxiPosition = streamVehicleUsecase
        .call(
      vehicleId: '${abstractOrderEntity.driverCarPlate}',
    )
        .listen((AbstractVehicleEntity abstractVehicleEntity) {
      print('abstractVehicleEntity');
      print(abstractVehicleEntity);
      taxiPosition.value = LatLng(
        double.parse(abstractVehicleEntity.lat!),
        double.parse(abstractVehicleEntity.lng!),
      );
      mapController.move(taxiPosition.value, 15);
    });
  }

  streamCurrentPosition() {
    streamPosition =
        geolocatorProvider!.streamPosition().listen((Position position) {
      print('position: $position');
      clientPosition.value = LatLng(position.latitude, position.longitude);
    });
  }

  showOfferPolylineMarkers(AbstractOrderEntity abstractOrderEntity) {
    List<LatLng> listLatLng = [];
    String? wayPoints = abstractOrderEntity.offerWayPoints;
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
        double.parse('${abstractOrderEntity.routeStartLat}'),
        double.parse('${abstractOrderEntity.routeStartLng}'),
      ),
      destination: LatLng(
        double.parse('${abstractOrderEntity.routeEndLat}'),
        double.parse('${abstractOrderEntity.routeEndLng}'),
      ),
      wayPoints: listLatLng,
    ).then(
      (value) => polylineListLatLng.value = value,
    );
  }

  void refreshOrder() {
    final String orderId = abstractOrderEntity!.id!;
    _getOrderUsecase
        .call(orderId: orderId)
        ?.then((AbstractOrderEntity? abstractOrderEntity) {
      initialize(abstractOrderEntity!);
    });
  }

  void initialize(AbstractOrderEntity abstractOrderEntity) {
    LatLng origin = LatLng(
      double.parse('${abstractOrderEntity.routeStartLat}'),
      double.parse('${abstractOrderEntity.routeStartLng}'),
    );
    LatLng destination = LatLng(
      double.parse('${abstractOrderEntity.userPickPointLat}'),
      double.parse('${abstractOrderEntity.userPickPointLng}'),
    );
    pickPoint.value = LatLng(
      double.parse('${abstractOrderEntity.userPickPointLat}'),
      double.parse('${abstractOrderEntity.userPickPointLng}'),
    );
    latLngBounds.value = [origin, destination];
    polylineTaxiListLatLng.value = [origin, destination];
    distanceTaxi.value = geolocatorProvider!.getDistanceBetweenPoints(
      origin: origin,
      destination: destination,
    );
    showOfferPolylineMarkers(abstractOrderEntity);
    streamCurrentPosition();
    streamCurrentTaxiPosition(abstractOrderEntity);
    streamTaxiPosition!.resume();
    streamPosition!.resume();
  }

  @override
  void onReady() {
    String? abstractOrderEntityId = Get.arguments['abstractOrderEntityId'];
    if (abstractOrderEntityId != null) {
      _getOrderUsecase
          .call(orderId: abstractOrderEntityId)
          ?.then((AbstractOrderEntity? abstractOrderEntity) {
        initialize(abstractOrderEntity!);
      });
    } else {
      abstractOrderEntity = Get.arguments['abstractOrderEntity'];
      initialize(abstractOrderEntity!);
    }
    super.onReady();
  }

  @override
  void onClose() {
    streamTaxiPosition!.cancel();
    streamPosition!.cancel();
    super.onClose();
  }
}
