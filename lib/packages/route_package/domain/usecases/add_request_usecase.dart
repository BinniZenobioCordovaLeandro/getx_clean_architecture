import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class AddRequestRouteUsecase {
  final AbstractRouteRepository _abstractRouteRepository;

  AddRequestRouteUsecase({
    required AbstractRouteRepository? abstractRouteRepository,
  })  : assert(abstractRouteRepository != null),
        _abstractRouteRepository = abstractRouteRepository!;

  Future<AbstractRouteEntity>? call({
    required AbstractRouteEntity abstractRouteEntity,
  }) =>
      _abstractRouteRepository.addRequestRoute(
        abstractRouteEntity: abstractRouteEntity,
      );
}
