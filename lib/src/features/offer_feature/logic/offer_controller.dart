import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/http_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/offer_order_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/cancel_offer_usecase.dart';
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
import 'package:pickpointer/src/core/util/decode_list_waypoints.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
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

  final CancelOfferUsecase _cancelOfferUsecase = CancelOfferUsecase(
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
  var userCarPhoto = ''.obs;
  var listOrders = [].obs;
  var travelTime = const Duration().obs;
  var travelDistance = 0.0.obs;
  var polylineListLatLng = <LatLng>[].obs;

  var offerId = ''.obs;
  var offerTo = ''.obs;
  var offerFrom = ''.obs;
  var offerTotal = 0.0.obs;
  var offerCount = 0.obs;
  var offerMaxCount = 0.obs;
  var offerEndLatLng = LatLng(0, 0).obs;
  var offerStartLatLng = LatLng(0, 0).obs;
  var offerListWayPoints = <LatLng>[].obs;
  var offerOrders = <OfferOrderEntity>[].obs;
  var closeOfferOrders = <OfferOrderEntity>[].obs;
  var offerOrdersNotified = [];
  DateTime? offerDateTime;

  var offerStateId = ''
      .obs; // Esperando -1, enCarretera 2 , enListo 3, Completado 1, Cancelado 0

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

  moveMapToLocation(LatLng latLng) {
    WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      mapController!
          .move(latLng, closeOfferOrders.value.isNotEmpty ? 17.0 : 15.0);
    });
  }

  Future<bool> getPolylineBetweenCoordinates({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? wayPoints,
  }) {
    isLoading.value = true;
    Future<bool> futureListLatLng = polylineProvider!
        .getPolylineBetweenCoordinates(
      origin: origin,
      destination: destination,
      wayPoints: wayPoints,
    )
        .then((PolylineResult polylineResult) {
      List<LatLng> listLatLng =
          polylineProvider!.convertPointToLatLng(polylineResult.points);
      polylineListLatLng.value = listLatLng;
      travelTime.value = polylineResult.duration;
      travelDistance.value = polylineResult.meters;
      isLoading.value = false;
      return true;
    }).catchError((error) {
      errorMessage.value = error.toString();
      isLoading.value = false;
    });
    return futureListLatLng;
  }

  filterCloseOrders({
    int isCloseMetters = 1000,
  }) {
    var localCloseOfferOrders = <OfferOrderEntity>[];
    if (offerStateId.value == '2') {
      for (var order in offerOrders.value) {
        if (distanceBetween(
              start: positionTaxi.value,
              end: LatLng(
                double.parse(order.pickPointLat!),
                double.parse(order.pickPointLng!),
              ),
            ) <
            isCloseMetters) {
          localCloseOfferOrders.add(order);
          bool orderNotified = offerOrdersNotified.contains(order.orderId);
          if (orderNotified == false) {
            firebaseNotificationProvider?.sendMessage(
              to: ['${order.tokenMessaging}'],
              title: '¡Vehiculo ${userCarPlate.value} CERCA a ti!',
              body:
                  'Alistate!, estamos a poco de llegar, Auto PLACA ${userCarPlate.value}',
              isMessage: true,
              link: '/order/${order.orderId}',
              image: userCarPhoto.value,
            );
            offerOrdersNotified.add(order.orderId);
          }
        }
      }
    }
    closeOfferOrders.value = localCloseOfferOrders;
  }

  prepareStreamCurrentPosition() {
    streamPosition =
        geolocatorProvider!.onPositionChanged.listen((Position position) {
      positionTaxi.value = LatLng(position.latitude, position.longitude);
      moveMapToLocation(positionTaxi.value);
      _updateVehicleUsecase
          .call(
              vehicle: VehicleModel(
        id: userCarPlate.value,
        latitude: '${position.latitude}',
        longitude: '${position.longitude}',
        offerId: offerId.value,
        stateId: offerStateId.value,
      ))
          .then((AbstractVehicleEntity abstractVehicleEntity) {
        errorMessage.value = '';
        print('value: ${abstractVehicleEntity.latitude}');
        filterCloseOrders();
      }).catchError((error) {
        errorMessage.value = 'Activa tu conección a internet.';
        print('error: $error');
      });
    });
  }

  getCurrentPosition() {
    geolocatorProvider?.getCurrentPosition()?.then((Position? position) {
      if (position != null) {
        positionTaxi.value = LatLng(
          position.latitude,
          position.longitude,
        );
        moveMapToLocation(positionTaxi.value);
        filterCloseOrders();
        prepareStreamCurrentPosition();
        getPolylineBetweenCoordinates(
          origin: positionTaxi.value,
          destination: offerEndLatLng.value,
          wayPoints: offerListWayPoints,
        );
      }
      isLoading.value = false;
    }).catchError((error) {
      print(error);
      errorMessage.value = error.toString();
      print('error trying get position');
    });
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
        GetxSnackbarWidget(
          title: 'INICIO MANUAL',
          subtitle:
              'Recoge a todos los pasajeros, ellos ya fueron notificados.',
        );
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

  Future<bool> cancelTrip() {
    isLoading.value = true;
    Future<bool>? futureBool = _cancelOfferUsecase
        .call(
      offerId: offerId.value,
    )
        ?.then((AbstractOfferEntity abstractOfferEntity) {
      isLoading.value = false;
      if (abstractOfferEntity.stateId == '0') {
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
          isPhoneVerified: abstractSessionEntity.isPhoneVerified,
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
    offerTo.value = abstractOfferEntity.routeTo!;
    offerFrom.value = abstractOfferEntity.routeFrom!;
    offerCount.value = abstractOfferEntity.count!;
    offerTotal.value = abstractOfferEntity.total!;
    offerMaxCount.value = abstractOfferEntity.maxCount!;
    offerStateId.value = abstractOfferEntity.stateId!;
    offerOrders.value = abstractOfferEntity.orders!;
    offerDateTime = abstractOfferEntity.dateTime!;
    userCarPlate.value = abstractOfferEntity.userCarPlate!;
    userCarPhoto.value = abstractOfferEntity.userCarPhoto!;
    if (abstractOfferEntity.stateId == '1' ||
        abstractOfferEntity.stateId == '0') {
      cleanSession().then((bool boolean) {
        if (boolean) {
          if (abstractOfferEntity.stateId == '1') {
            GetxSnackbarWidget(
              title: 'MAGNIFICO!',
              subtitle: 'Estas listo para ofrecer otro viaje?!',
            );
          }
          Get.offAll(
            () => const RoutesPage(),
          );
        }
      });
    } else {
      offerEndLatLng.value = LatLng(
        double.parse('${abstractOfferEntity.endLat}'),
        double.parse('${abstractOfferEntity.endLng}'),
      );
      offerStartLatLng.value = LatLng(
        double.parse('${abstractOfferEntity.startLat}'),
        double.parse('${abstractOfferEntity.startLng}'),
      );
      List<LatLng> listLatLng = [];
      String? wayPoints = abstractOfferEntity.wayPoints;
      if (wayPoints != null && wayPoints.length > 10) {
        listLatLng = decodeListWaypoints(wayPoints);
      }
      offerListWayPoints.value = listLatLng;
      getCurrentPosition();
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
