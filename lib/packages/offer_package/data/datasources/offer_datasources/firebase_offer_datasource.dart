import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class FirebaseOfferDatasource implements AbstractOfferRepository {
  CollectionReference? offers;

  FirebaseOfferDatasource() {
    offers = FirebaseFirestore.instance.collection('c_offers');
  }

  @override
  Future<List<AbstractOfferEntity>>? getOffers() {
    return offers
        ?.where('state_id', isEqualTo: '-1')
        .orderBy('created_at')
        .get()
        .then((snapshot) {
      List<AbstractOfferEntity> offers = [];
      for (DocumentSnapshot offer in snapshot.docs) {
        offers.add(OfferModel.fromMap(offer.data() as Map<String, dynamic>));
      }
      return offers;
    });
  }

  @override
  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  }) {
    return offers
        ?.where('route_id', isEqualTo: routeId)
        .where('state_id', isEqualTo: '-1')
        .orderBy('created_at')
        .get()
        .then((snapshot) {
      List<AbstractOfferEntity> offers = [];
      for (DocumentSnapshot offer in snapshot.docs) {
        offers.add(OfferModel.fromMap(offer.data() as Map<String, dynamic>));
      }
      return offers;
    });
  }

  @override
  Future<AbstractOfferEntity>? getOffer({
    required String offerId,
  }) {
    return offers?.doc(offerId).get().then((snapshot) {
      return OfferModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<AbstractOfferEntity>? setOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    OfferModel offerModel = abstractOfferEntity as OfferModel;
    offers?.doc(offerModel.id).set(offerModel.toMap());
    return Future.value(offerModel);
  }

  @override
  Future<AbstractOfferEntity>? addOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    OfferModel offerModel = abstractOfferEntity as OfferModel;
    offers?.doc(offerModel.id).set(offerModel.toMap());
    return Future.value(offerModel);
  }

  @override
  Future<AbstractOfferEntity>? updateOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    OfferModel offerModel = abstractOfferEntity as OfferModel;
    Map<String, dynamic> mapStringDynamic = offerModel.toMap();
    Map<String, dynamic> newMapStringDynamic = {};
    mapStringDynamic.forEach((key, value) {
      if (value != null) {
        newMapStringDynamic.putIfAbsent(key, () => value);
      }
    });
    offers?.doc(offerModel.id).update(newMapStringDynamic);
    return Future.value(offerModel);
  }

  @override
  Future<AbstractOfferEntity>? startOffer({
    required String offerId,
  }) {}

  @override
  Future<AbstractOfferEntity>? finishOffer({
    required String offerId,
  }) {}
}
