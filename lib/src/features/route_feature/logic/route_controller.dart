import 'package:get/get.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasource.dart/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/get_routes_usecase.dart';

class RouteController extends GetxController {
  static RouteController get instance => Get.put(RouteController());

  var futureListAbstractRouteEntity = Future.value(<AbstractRouteEntity>[]).obs;

  final GetRoutesUsecase _getRoutesUsecase = GetRoutesUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  @override
  void onReady() {
    futureListAbstractRouteEntity.value = _getRoutesUsecase
        .call()!
        .then((List<AbstractRouteEntity> listAbstractRouteEntity) {
      return listAbstractRouteEntity;
    });
  }
}
