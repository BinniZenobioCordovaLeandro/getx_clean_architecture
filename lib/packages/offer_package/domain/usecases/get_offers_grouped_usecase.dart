import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class GetOffersGroupedUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  GetOffersGroupedUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<Map<String, List<AbstractOfferEntity>>>? call() =>
      _abstractOfferRepository.getOffersGrouped();
}
