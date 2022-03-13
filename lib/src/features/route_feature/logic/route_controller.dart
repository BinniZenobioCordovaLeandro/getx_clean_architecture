import 'dart:convert';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offers_by_route_usecase.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';

class RouteController extends GetxController {
  static RouteController get instance => Get.put(RouteController());

  var isSigned = false.obs;
  var isLoading = false.obs;
  var polylineListLatLng = <LatLng>[].obs;
  var listAbstractOfferEntity = <AbstractOfferEntity>[].obs;
  var listWayPoints = <LatLng>[].obs;

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  final GetOffersByRouteUsecase getOffersByRouteUsecase =
      GetOffersByRouteUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

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

  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  }) {
    Future<List<AbstractOfferEntity>>? futureListAbstractOfferEntity =
        getOffersByRouteUsecase.call(
      routeId: routeId,
    );
    return futureListAbstractOfferEntity;
  }

  verifySession() {
    _verifySessionUsecase.call().then(
          (abstractSessionEntity) =>
              isSigned.value = abstractSessionEntity.isSigned!,
        );
  }

  @override
  void onReady() {
    AbstractRouteEntity _abstractRouteEntity =
        Get.arguments['abstractRouteEntity'];
    getPolylineBetweenCoordinates(
      origin: LatLng(
        double.parse('${_abstractRouteEntity.startLat}'),
        double.parse('${_abstractRouteEntity.startLng}'),
      ),
      destination: LatLng(
        double.parse('${_abstractRouteEntity.endLat}'),
        double.parse('${_abstractRouteEntity.endLng}'),
      ),
    ).then(
      (value) => polylineListLatLng.value = value,
    );
    getOffersByRoute(routeId: '${_abstractRouteEntity.id}')?.then(
      (value) => listAbstractOfferEntity.value = value,
    );
    verifySession();
    super.onReady();
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
}
