import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class GetRouteUsecase {
  final AbstractRouteRepository _abstractRouteRepository;

  GetRouteUsecase({
    required AbstractRouteRepository? abstractRouteRepository,
  })  : assert(abstractRouteRepository != null),
        _abstractRouteRepository = abstractRouteRepository!;

  Future<AbstractRouteEntity>? call({
    required String routeId,
  }) =>
      _abstractRouteRepository.getRoute(routeId: routeId);
}
