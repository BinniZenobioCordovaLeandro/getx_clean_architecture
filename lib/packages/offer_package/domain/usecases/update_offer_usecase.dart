import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class UpdateOfferUsecase {
  final AbstractOfferRepository _abstractOfferRepository;

  UpdateOfferUsecase({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository!;

  Future<AbstractOfferEntity>? call({
    required AbstractOfferEntity abstractOfferEntity,
  }) =>
      _abstractOfferRepository.updateOffer(
        abstractOfferEntity: abstractOfferEntity,
      );
}
