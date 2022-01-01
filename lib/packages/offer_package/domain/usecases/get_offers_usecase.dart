import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class GetOffersUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  GetOffersUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<List<AbstractOfferEntity>>? call() =>
      _abstractOfferRepository.getOffers();
}
