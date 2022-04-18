import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';

abstract class AbstractRouteRepository {
  Future<List<AbstractRouteEntity>>? getRoutes();

  Future<AbstractRouteEntity>? getRoute({
    required String routeId,
  });

  Future<AbstractRouteEntity>? setRoute({
    required AbstractRouteEntity abstractRouteEntity,
  });

  Future<AbstractRouteEntity>? addRoute({
    required AbstractRouteEntity abstractRouteEntity,
  });

  Future<AbstractRouteEntity>? addRequestRoute({
    required AbstractRouteEntity abstractRouteEntity,
    required String userId,
  });
}
