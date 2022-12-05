import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class OfferRepository implements AbstractOfferRepository {
  final AbstractOfferRepository? _abstractOfferRepository;

  OfferRepository({
    required AbstractOfferRepository? abstractOfferRepository,
  })  : assert(abstractOfferRepository != null),
        _abstractOfferRepository = abstractOfferRepository;

  @override
  Future<List<AbstractOfferEntity>>? getOffers() {
    return _abstractOfferRepository!.getOffers();
  }

  @override
  Future<Map<String, List<AbstractOfferEntity>>>? getOffersGrouped() {
    return _abstractOfferRepository!.getOffersGrouped();
  }

  @override
  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  }) {
    return _abstractOfferRepository!.getOffersByRoute(
      routeId: routeId,
    );
  }

  @override
  Future<AbstractOfferEntity>? getOffer({
    required String offerId,
  }) {
    return _abstractOfferRepository!.getOffer(
      offerId: offerId,
    );
  }

  @override
  Future<AbstractOfferEntity>? setOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    return _abstractOfferRepository!.setOffer(
      abstractOfferEntity: abstractOfferEntity,
    );
  }

  @override
  Future<AbstractOfferEntity>? addOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    return _abstractOfferRepository!.addOffer(
      abstractOfferEntity: abstractOfferEntity,
    );
  }

  @override
  Future<AbstractOfferEntity>? updateOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    return _abstractOfferRepository!.updateOffer(
      abstractOfferEntity: abstractOfferEntity,
    );
  }

  @override
  Future<AbstractOfferEntity>? startOffer({
    required String offerId,
  }) {
    return _abstractOfferRepository!.startOffer(
      offerId: offerId,
    );
  }

  @override
  Future<AbstractOfferEntity>? finishOffer({
    required String offerId,
  }) {
    return _abstractOfferRepository!.finishOffer(
      offerId: offerId,
    );
  }
}
