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
  var position = LatLng(-12.0, -76.0).obs;
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
    Future<bool>? futureBool = notificationProvider?.sendNotification(
      title: 'title',
      body: 'body',
    ).then((value) => value);
    return futureBool;
  }

  @override
  void onReady() {
    // AbstractOrderEntity _abstractOrderEntity =
    //     Get.arguments['abstractOrderEntity'];
    getOrderUsecase
        .call(orderId: '1')
        ?.then((AbstractOrderEntity abstractOrderEntity) {
      LatLng origin = LatLng(
        double.parse('${abstractOrderEntity.routeStartLat}'),
        double.parse('${abstractOrderEntity.routeStartLng}'),
      );
      LatLng destination = LatLng(
        double.parse('${abstractOrderEntity.userPickPointLat}'),
        double.parse('${abstractOrderEntity.userPickPointLng}'),
      );
      latLngBounds.value = [origin, destination];
      polylineListLatLng.value = [origin, destination];
      // getPolylineBetweenCoordinates( // TODO: HIGHT COST
      //   origin: origin,
      //   destination: destination,
      // ).then(
      //   (value) => polylineListLatLng.value = value,
      // );
    });
  }
}
