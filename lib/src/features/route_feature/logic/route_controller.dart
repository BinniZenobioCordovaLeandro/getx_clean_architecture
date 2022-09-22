import 'dart:convert';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offers_by_route_usecase.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasources/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/get_route_usecase.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';

class RouteController extends GetxController {
  static RouteController get instance => Get.put(RouteController());

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  final GetRouteUsecase _getRouteUsecase = GetRouteUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  final GetOffersByRouteUsecase getOffersByRouteUsecase =
      GetOffersByRouteUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  MapController? mapController;
  AbstractRouteEntity? abstractRouteEntity;

  var isSigned = false.obs;
  var isPhoneVerified = false.obs;
  var isDriver = false.obs;
  var onRoad = false.obs;
  var currentOfferId = ''.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var travelTime = const Duration().obs;
  var travelDistance = 0.0.obs;
  var polylineListLatLng = <LatLng>[].obs;
  var listAbstractOfferEntity = <AbstractOfferEntity>[].obs;
  var listWayPoints = <LatLng>[].obs;

  var routeId = ''.obs;

  var routeTo = ''.obs;
  var routeFrom = ''.obs;

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
      // '${( / 60).toStringAsFixed(2)} horas de viaje';
      travelDistance.value = polylineResult.meters;
      // '${(polylineResult.meters / 1000).toStringAsFixed(2)} Kilometros de viaje ';
      isLoading.value = false;
      return true;
    }).catchError((error) {
      errorMessage.value = error.toString();
      isLoading.value = false;
    });
    return futureListLatLng;
  }

  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  }) {
    Future<List<AbstractOfferEntity>>? futureListAbstractOfferEntity =
        getOffersByRouteUsecase.call(
      routeId: routeId,
    );
    return futureListAbstractOfferEntity;
  }

  Future<bool> verifySession() {
    Future<bool> futureBool =
        _verifySessionUsecase.call().then((abstractSessionEntity) {
      isSigned.value = abstractSessionEntity.isSigned!;
      isPhoneVerified.value = abstractSessionEntity.isPhoneVerified ?? false;
      isDriver.value = abstractSessionEntity.isDriver ?? false;
      onRoad.value = abstractSessionEntity.onRoad ?? false;
      currentOfferId.value = abstractSessionEntity.currentOfferId ?? '';
      return isSigned.value;
    });
    return futureBool;
  }

  subscribeToRouteTopic() {
    isLoading.value = true;
    String topicRoute = 'route_${routeId.value}';
    firebaseNotificationProvider!
        .subscribeToTopic(topic: topicRoute)
        .then((value) {
      isLoading.value = false;
      GetxSnackbarWidget(
        title: 'BIEN!, TE NOTIFICAREMOS!',
        subtitle:
            'Te noficaremos cada que tengamos un nuevo vehiculo en ruta ;)',
      );
    }).catchError((onError) {
      isLoading.value = false;
    });
  }

  unsubscribeToRouteTopic() {
    isLoading.value = true;
    String topicRoute = 'route_${routeId.value}';
    firebaseNotificationProvider!
        .unsubscribeFromTopic(topic: topicRoute)
        .then((value) {
      isLoading.value = false;
      GetxSnackbarWidget(
        title: 'DEJAREMOS DE NOTIFICARTE!',
        subtitle: 'Hola, dejaremos de notificarte en esta ruta.',
      );
    }).catchError((onError) {
      isLoading.value = false;
    });
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
    );
  }

  centerRouteMap(AbstractRouteEntity abstractRouteEntity) {
    mapController?.fitBounds(LatLngBounds(
      LatLng(
        double.tryParse('${abstractRouteEntity.startLat}') ?? 0,
        double.tryParse('${abstractRouteEntity.startLng}') ?? 0,
      ),
      LatLng(
        double.tryParse('${abstractRouteEntity.endLat}') ?? 0,
        double.tryParse('${abstractRouteEntity.endLng}') ?? 0,
      ),
    ));
  }

  void initialize(AbstractRouteEntity abstractRouteEntity) {
    routeId.value = abstractRouteEntity.id!;
    routeTo.value = abstractRouteEntity.to!;
    routeFrom.value = abstractRouteEntity.from!;
    this.abstractRouteEntity = abstractRouteEntity;
    centerRouteMap(abstractRouteEntity);
    getPolylineBetweenCoordinates(
      origin: LatLng(
        double.parse('${abstractRouteEntity.startLat}'),
        double.parse('${abstractRouteEntity.startLng}'),
      ),
      destination: LatLng(
        double.parse('${abstractRouteEntity.endLat}'),
        double.parse('${abstractRouteEntity.endLng}'),
      ),
    );
    getOffersByRoute(routeId: '${abstractRouteEntity.id}')?.then(
      (value) => listAbstractOfferEntity.value = value,
    );
    verifySession();
  }

  @override
  void onReady() {
    String? abstractRouteEntityId;
    if (Get.arguments != null && Get.arguments['abstractRouteEntity'] != null) {
      initialize(Get.arguments['abstractRouteEntity']);
    } else if (Get.arguments != null &&
        Get.arguments['abstractRouteEntityId'] != null) {
      abstractRouteEntityId = Get.arguments['abstractRouteEntityId'];
    } else {
      abstractRouteEntityId = Get.parameters['abstractRouteEntityId'];
    }
    _getRouteUsecase
        .call(routeId: abstractRouteEntityId!)
        ?.then((AbstractRouteEntity? abstractRouteEntity) {
      initialize(abstractRouteEntity!);
    });

    super.onReady();
  }
}
