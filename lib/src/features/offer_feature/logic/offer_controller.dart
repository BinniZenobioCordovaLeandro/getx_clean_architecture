import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/http_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/finish_offer_usecase.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offer_usecase.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/start_offer_usecase.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/vehicle_package/data/datasources/vehicle_datasources/firebase_vehicle_datasource.dart';
import 'package:pickpointer/packages/vehicle_package/data/models/vehicle_model.dart';
import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/usecases/update_vehicle_usecase.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';

class OfferController extends GetxController {
  static OfferController get instance => Get.put(OfferController());

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();

  final UpdateVehicleUsecase _updateVehicleUsecase = UpdateVehicleUsecase(
    abstractVehicleRepository: FirebaseVehicleDatasource(),
  );

  final StartOfferUsecase _startOfferUsecase = StartOfferUsecase(
    abstractOfferRepository: HttpOfferDatasource(),
  );

  final FinishOfferUsecase _finishOfferUsecase = FinishOfferUsecase(
    abstractOfferRepository: HttpOfferDatasource(),
  );

  final GetOfferUsecase _getOfferUsecase = GetOfferUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  MapController? mapController;

  StreamSubscription<Position>? streamPosition;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var positionTaxi = LatLng(-12.0, -76.0).obs;
  var userCarPlate = ''.obs;
  var offerEnd = LatLng(0, 0).obs;
  var listWayPoints = <LatLng>[].obs;
  var listOrders = [].obs;
  var polylineListLatLng = <LatLng>[].obs;

  var offerId = ''.obs;
  var offerStateId =
      ''.obs; // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0

  double distanceBetween({
    required LatLng start,
    required LatLng end,
  }) {
    return geolocatorProvider!.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  move(LatLng latLng) {
    WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      mapController!.move(latLng, 15.0);
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

  prepareStreamCurrentPosition(AbstractOfferEntity abstractOfferEntity) {
    print('prepareStreamCurrentPosition');
    streamPosition = geolocatorProvider!.streamPosition().listen(
      (Position position) {
        print('position: $position');
        positionTaxi.value = LatLng(position.latitude, position.longitude);
        move(positionTaxi.value);
        _updateVehicleUsecase
            .call(
                vehicle: VehicleModel(
          id: '${abstractOfferEntity.userCarPlate}',
          latitude: '${position.latitude}',
          longitude: '${position.longitude}',
        ))
            .then((AbstractVehicleEntity abstractVehicleEntity) {
          print('value: ${abstractVehicleEntity.latitude}');
        }).catchError((error) {
          print('error: $error');
        });
      },
      onError: (error) {
        print('error: $error');
      },
      onDone: () {
        print('done');
      },
      cancelOnError: false,
    );
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

  showDynamicsMarkers(AbstractOfferEntity abstractOfferEntity) {
    List localListOrders = [];
    String? orders = abstractOfferEntity.orders;
    if (orders != null && orders.length > 10) {
      localListOrders = jsonDecode(orders);
    }
    listOrders.value = localListOrders;
  }

  Future<bool> startTrip() async {
    isLoading.value = true;
    Future<bool>? futureBool = _startOfferUsecase
        .call(
      offerId: offerId.value,
    )
        ?.then((AbstractOfferEntity abstractOfferEntity) {
      isLoading.value = false;
      if (abstractOfferEntity.stateId == '2') {
        initialize(abstractOfferEntity);
        return true;
      }
      return false;
    }).catchError((onError) {
      isLoading.value = false;
      errorMessage.value = onError.toString();
      return false;
    });
    return futureBool!;
  }

  Future<bool> finishTrip() async {
    isLoading.value = true;
    Future<bool>? futureBool = _finishOfferUsecase
        .call(
      offerId: offerId.value,
    )
        ?.then((AbstractOfferEntity abstractOfferEntity) {
      isLoading.value = false;
      if (abstractOfferEntity.stateId == '1') {
        initialize(abstractOfferEntity);
        return true;
      }
      return false;
    }).catchError((onError) {
      isLoading.value = false;
      errorMessage.value = onError.toString();
      return false;
    });
    return futureBool!;
  }

  Future<bool> cleanSession() {
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

  void refreshOffer() {
    print('offerId, $offerId');
    _getOfferUsecase
        .call(offerId: offerId.value)
        ?.then((AbstractOfferEntity? abstractOfferEntity) {
      initialize(abstractOfferEntity!);
    });
  }

  void initialize(AbstractOfferEntity abstractOfferEntity) {
    offerId.value = abstractOfferEntity.id!;
    offerStateId.value = abstractOfferEntity.stateId!;
    userCarPlate.value = abstractOfferEntity.userCarPlate!;
    if (abstractOfferEntity.stateId == '1' ||
        abstractOfferEntity.stateId == '0') {
      cleanSession().then((bool boolean) {
        if (boolean) {
          Get.offAll(
            () => const RoutesPage(),
          );
        }
      });
    } else {
      offerEnd.value = LatLng(
        double.parse('${abstractOfferEntity.endLat}'),
        double.parse('${abstractOfferEntity.endLng}'),
      );
      prepareStreamCurrentPosition(abstractOfferEntity);
      showOfferPolylineMarkers(abstractOfferEntity);
      showDynamicsMarkers(abstractOfferEntity);
      streamPosition?.resume();
    }
  }

  @override
  void onReady() {
    String? abstractOfferEntityId;
    if (Get.arguments != null && Get.arguments['abstractOfferEntity'] != null) {
      initialize(Get.arguments['abstractOfferEntity']);
    } else if (Get.arguments != null &&
        Get.arguments['abstractOfferEntityId'] != null) {
      abstractOfferEntityId = Get.arguments['abstractOfferEntityId'];
    } else {
      abstractOfferEntityId = Get.parameters['abstractOfferEntityId'];
    }
    _getOfferUsecase
        .call(offerId: abstractOfferEntityId!)
        ?.then((AbstractOfferEntity? abstractOfferEntity) {
      initialize(abstractOfferEntity!);
    });
    super.onReady();
  }

  @override
  void onClose() {
    streamPosition?.cancel();
    super.onClose();
  }
}
