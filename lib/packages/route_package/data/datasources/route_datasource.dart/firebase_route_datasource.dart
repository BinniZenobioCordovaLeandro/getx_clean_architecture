import 'package:pickpointer/packages/route_package/data/models/route_model.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class FirebaseRouteDatasource implements AbstractRouteRepository {
  FirebaseRouteDatasource();

  @override
  Future<List<AbstractRouteEntity>>? getRoutes() {
    return Future.value(<AbstractRouteEntity>[
      const RouteModel(
        id: '1',
        description: 'Route 1',
        startLat: '-23.5',
        startLng: '-46.6',
        endLat: '-12.1216227',
        endLng: '-76.8518628',
      ),
      const RouteModel(
        id: '2',
        description: 'Route 2',
        startLat: '-25.5',
        startLng: '-44.6',
        endLat: '-12.1216227',
        endLng: '-76.8518628',
      ),
    ]);
  }

  @override
  Future<AbstractRouteEntity>? getRoute({
    required int userId,
  }) {
    return null;
  }

  @override
  Future<AbstractRouteEntity>? setRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return null;
  }

  @override
  Future<AbstractRouteEntity>? addRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return null;
  }
}
