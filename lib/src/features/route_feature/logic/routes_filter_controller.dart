import 'package:get/get.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasources/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/get_routes_usecase.dart';

class RoutesFilterController extends GetxController {
  static RoutesFilterController get instance =>
      Get.put(RoutesFilterController());

  var routes = <AbstractRouteEntity>[].obs;
  var filteredRoutes = <AbstractRouteEntity>[].obs;

  final GetRoutesUsecase _getRoutesUsecase = GetRoutesUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  filterFromRoutes(String from) {
    RegExp regExpFrom = RegExp(from.toLowerCase());
    filteredRoutes.value = routes.value
        .where((AbstractRouteEntity route) =>
            regExpFrom.hasMatch('${route.from?.toLowerCase()}'))
        .toList();
  }

  filterToRoutes(String to) {
    RegExp regExpTo = RegExp(to.toLowerCase());
    filteredRoutes.value = routes.value
        .where((AbstractRouteEntity route) =>
            regExpTo.hasMatch('${route.to?.toLowerCase()}'))
        .toList();
  }

  @override
  void onReady() {
    _getRoutesUsecase
        .call()!
        .then((List<AbstractRouteEntity> listAbstractRouteEntity) {
      routes.value = listAbstractRouteEntity;
      filteredRoutes.value = listAbstractRouteEntity;
    });
    super.onReady();
  }
}
