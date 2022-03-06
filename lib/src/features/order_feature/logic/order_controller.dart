import 'dart:convert';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/order_package/data/datasources/firebase_order_datasource.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/usecases/get_order_usecase.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.put(OrderController());

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var polylineListLatLng = <LatLng>[].obs;
  var listWayPoints = <LatLng>[].obs;
  var polylineTaxiListLatLng = <LatLng>[].obs;
  var distanceTaxi = 0.0.obs;
  var positionTaxi = LatLng(-12.0, -76.0).obs;
  var pickPoint = LatLng(-12.0, -76.0).obs;
  var latLngBounds = <LatLng>[].obs;

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();

  NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  GetOrderUsecase getOrderUsecase = GetOrderUsecase(
    abstractOrderRepository: FirebaseOrderDatasource(),
  );

  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();

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

  @override
  void onReady() {
    AbstractOrderEntity abstractOrderEntity =
        Get.arguments['abstractOrderEntity'];
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
    positionTaxi.value = origin;
    latLngBounds.value = [origin, destination];
    polylineTaxiListLatLng.value = [origin, destination];
    distanceTaxi.value = geolocatorProvider!.getDistanceBetweenPoints(
      origin: origin,
      destination: destination,
    );
    showOfferPolylineMarkers(abstractOrderEntity);
  }

  showOfferPolylineMarkers(AbstractOrderEntity abstractOrderEntity) {
    List<LatLng> listLatLng = [];
    String? wayPoints = abstractOrderEntity.routeWayPoints;
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
}
