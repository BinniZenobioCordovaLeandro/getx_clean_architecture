import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class RouteRepository implements AbstractRouteRepository {
  final AbstractRouteRepository? _abstractRouteRepository;

  RouteRepository({
    required AbstractRouteRepository? abstractRouteRepository,
  })  : assert(abstractRouteRepository != null),
        _abstractRouteRepository = abstractRouteRepository!;

  @override
  Future<List<AbstractRouteEntity>>? getRoutes() {
    return _abstractRouteRepository!.getRoutes();
  }

  @override
  Future<AbstractRouteEntity>? getRoute({
    required String routeId,
  }) {
    return _abstractRouteRepository!.getRoute(
      routeId: routeId,
    );
  }

  @override
  Future<AbstractRouteEntity>? setRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return _abstractRouteRepository!.setRoute(
      abstractRouteEntity: abstractRouteEntity,
    );
  }

  @override
  Future<AbstractRouteEntity>? addRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return _abstractRouteRepository!.addRoute(
      abstractRouteEntity: abstractRouteEntity,
    );
  }

  @override
  Future<AbstractRouteEntity>? addRequestRoute({
    required AbstractRouteEntity abstractRouteEntity,
    required String userId,
  }) {
    return _abstractRouteRepository!.addRequestRoute(
      abstractRouteEntity: abstractRouteEntity,
      userId: userId,
    );
  }
}
