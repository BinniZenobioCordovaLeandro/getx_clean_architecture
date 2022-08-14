import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class FinishOfferUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  FinishOfferUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<AbstractOfferEntity>? call({
    required String offerId,
  }) =>
      _abstractOfferRepository.finishOffer(
        offerId: offerId,
      );
}
