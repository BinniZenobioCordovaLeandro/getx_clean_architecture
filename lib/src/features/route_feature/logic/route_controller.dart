import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offers_by_route_usecase.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';

class RouteController extends GetxController {
  static RouteController get instance => Get.put(RouteController());

  var polylineListLatLng = [].obs;

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();
  final GetOffersByRouteUsecase getOffersByRouteUsecase =
      GetOffersByRouteUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  Future<List<LatLng>> getPolylineBetweenCoordinates({
    required LatLng origin,
    required LatLng destination,
  }) {
    Future<List<LatLng>> futureListLatLng = polylineProvider!
        .getPolylineBetweenCoordinates(
      origin: origin,
      destination: destination,
    )
        .then((List<LatLng> listLatLng) {
      polylineListLatLng.value = listLatLng;
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
}
