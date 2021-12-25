import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class GetRoutesUsecase {
  final AbstractRouteRepository _abstractRouteRepository;

  GetRoutesUsecase({
    required AbstractRouteRepository? abstractRouteRepository,
  })  : assert(abstractRouteRepository != null),
        _abstractRouteRepository = abstractRouteRepository!;

  Future<List<AbstractRouteEntity>>? call() =>
      _abstractRouteRepository.getRoutes();
}
