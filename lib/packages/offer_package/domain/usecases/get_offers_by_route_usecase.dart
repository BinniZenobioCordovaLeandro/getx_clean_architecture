import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class GetOffersByRouteUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  GetOffersByRouteUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<List<AbstractOfferEntity>>? call({
    required String routeId,
  }) =>
      _abstractOfferRepository.getOffersByRoute(routeId: routeId);
}
