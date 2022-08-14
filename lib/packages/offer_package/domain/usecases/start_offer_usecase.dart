import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class StartOfferUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  StartOfferUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<AbstractOfferEntity>? call({
    required String offerId,
  }) =>
      _abstractOfferRepository.startOffer(
        offerId: offerId,
      );
}
