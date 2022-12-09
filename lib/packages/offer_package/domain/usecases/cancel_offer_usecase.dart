import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class CancelOfferUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  CancelOfferUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<AbstractOfferEntity>? call({
    required String offerId,
  }) =>
      _abstractOfferRepository.cancelOffer(
        offerId: offerId,
      );
}
