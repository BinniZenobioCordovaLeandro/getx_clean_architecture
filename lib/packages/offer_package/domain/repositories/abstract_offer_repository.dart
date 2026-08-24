import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';

abstract class AbstractOfferRepository {
  Future<List<AbstractOfferEntity>>? getOffers();

  Future<Map<String, List<AbstractOfferEntity>>>? getOffersGrouped();

  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  });

  Future<AbstractOfferEntity>? getOffer({
    required String offerId,
  });

  Future<AbstractOfferEntity>? setOffer({
    required AbstractOfferEntity abstractOfferEntity,
  });

  Future<AbstractOfferEntity>? addOffer({
    required AbstractOfferEntity abstractOfferEntity,
  });

  Future<AbstractOfferEntity>? updateOffer({
    required AbstractOfferEntity abstractOfferEntity,
  });

  Future<AbstractOfferEntity>? startOffer({
    required String offerId,
  });

  Future<AbstractOfferEntity>? cancelOffer({
    required String offerId,
  });

  Future<AbstractOfferEntity>? finishOffer({
    required String offerId,
  });
}
