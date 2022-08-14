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
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/vehicle_package/data/datasources/vehicle_datasources/firebase_vehicle_datasource.dart';
import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/usecases/stream_vehicle_usecase.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.put(OrderController());

  MapController mapController = MapController();

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();

  NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final GetOrderUsecase _getOrderUsecase = GetOrderUsecase(
    abstractOrderRepository: FirebaseOrderDatasource(),
  );

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  StreamVehicleUsecase streamVehicleUsecase = StreamVehicleUsecase(
    abstractVehicleRepository: FirebaseVehicleDatasource(),
  );

  StreamSubscription<Position>? streamPosition;
  StreamSubscription<AbstractVehicleEntity>? streamTaxiPosition;

  AbstractOrderEntity? abstractOrderEntity;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var userPickPoint = LatLng(-12.0, -76.0).obs;
  var userDropPoint = LatLng(-12.0, -76.0).obs;
  var polylineListLatLng = <LatLng>[].obs;
  var listWayPoints = <LatLng>[].obs;
  var distanceTaxi = 0.0.obs;
  var userPosition = LatLng(-12.0, -76.0).obs;
  var taxiPosition = LatLng(-12.0, -76.0).obs;

  var orderId = ''.obs;

  var routeTo = ''.obs;
  var routeFrom = ''.obs;
  var userPickPointLat = ''.obs;
  var userPickPointLng = ''.obs;

  var driverAvatar = ''.obs;
  var driverName = ''.obs;
  var driverCarPhoto = ''.obs;
  var driverCarModel = ''.obs;
  var driverCarPlate = ''.obs;
  var driverPhoneNumber = ''.obs;

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
      print(
          'taxiPosition: ${abstractVehicleEntity.latitude}, ${abstractVehicleEntity.longitude}');
      taxiPosition.value = LatLng(
        double.parse(abstractVehicleEntity.latitude!),
        double.parse(abstractVehicleEntity.longitude!),
      );
      distanceTaxi.value = geolocatorProvider!.getDistanceBetweenPoints(
        origin: taxiPosition.value,
        destination: userPosition.value,
      );
      mapController.move(taxiPosition.value, 15);
    });
  }

  streamCurrentPosition() {
    streamPosition =
        geolocatorProvider!.streamPosition().listen((Position position) {
      print('userPosition: ${position.latitude}, ${position.longitude}');
      userPosition.value = LatLng(position.latitude, position.longitude);
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
    abstractOrderEntity = abstractOrderEntity;
    if (abstractOrderEntity.stateId == '1' ||
        abstractOrderEntity.stateId == '0') {
      Get.offAll(
        () => const RoutesPage(),
      );
    } else {
      userDropPoint.value = LatLng(
        double.parse('${abstractOrderEntity.userDropPointLat}'),
        double.parse('${abstractOrderEntity.userDropPointLng}'),
      );
      userPickPoint.value = LatLng(
        double.parse('${abstractOrderEntity.userPickPointLat}'),
        double.parse('${abstractOrderEntity.userPickPointLng}'),
      );

      orderId.value = abstractOrderEntity.id!;
      routeTo.value = abstractOrderEntity.routeTo!;
      routeFrom.value = abstractOrderEntity.routeFrom!;

      userPickPointLat.value = abstractOrderEntity.userPickPointLat!;
      userPickPointLng.value = abstractOrderEntity.userPickPointLng!;

      driverAvatar.value = abstractOrderEntity.driverAvatar!;
      driverName.value = abstractOrderEntity.driverName!;
      driverCarPhoto.value = abstractOrderEntity.driverCarPhoto!;
      driverCarModel.value = abstractOrderEntity.driverCarModel!;
      driverCarPlate.value = abstractOrderEntity.driverCarPlate!;
      driverPhoneNumber.value = abstractOrderEntity.driverPhoneNumber!;

      showOfferPolylineMarkers(abstractOrderEntity);
      streamCurrentPosition();
      streamCurrentTaxiPosition(abstractOrderEntity);
      streamTaxiPosition!.resume();
      streamPosition!.resume();
    }
  }

  Future<bool> finishTrip() async {
    Future<bool> futureBool = _verifySessionUsecase
        .call()
        .then((AbstractSessionEntity abstractSessionEntity) async {
      if (abstractSessionEntity.isSigned!) {
        await _updateSessionUsecase.call(
            abstractSessionEntity: SessionModel(
          isSigned: abstractSessionEntity.isSigned,
          isDriver: abstractSessionEntity.isDriver,
          idSessions: abstractSessionEntity.idSessions,
          idUsers: abstractSessionEntity.idUsers,
          onRoad: false,
          currentOfferId: null,
          currentOrderId: null,
          tokenMessaging: abstractSessionEntity.tokenMessaging,
        ));
        return true;
      }
      return false;
    });
    return futureBool;
  }

  @override
  void onReady() {
    mapController = MapController();
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
