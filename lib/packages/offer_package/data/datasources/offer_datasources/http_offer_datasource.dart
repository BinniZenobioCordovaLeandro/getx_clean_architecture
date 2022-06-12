import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class HttpOfferDatasource implements AbstractOfferRepository {
  @override
  Future<List<AbstractOfferEntity>>? getOffers() {}

  @override
  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  }) {}

  @override
  Future<AbstractOfferEntity>? getOffer({
    required String offerId,
  }) {}

  @override
  Future<AbstractOfferEntity>? setOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {}

  @override
  Future<AbstractOfferEntity>? addOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {}
}
