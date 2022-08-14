import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
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

  @override
  Future<AbstractOfferEntity>? updateOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {}

  @override
  Future<AbstractOfferEntity>? startOffer({
    required String offerId,
  }) {
    Future<AbstractOfferEntity> futureAbstractOfferEntity = http
        .put(
      Uri.parse('https://us-central1-pickpointer.cloudfunctions.net/startTrip'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'offer_id': offerId,
      }),
    )
        .then((http.Response value) {
      return OfferModel.fromJson(value.body);
    });
    return futureAbstractOfferEntity;
  }

  @override
  Future<AbstractOfferEntity>? finishOffer({
    required String offerId,
  }) {
    Future<AbstractOfferEntity> futureAbstractOfferEntity = http
        .put(
      Uri.parse(
          'https://us-central1-pickpointer.cloudfunctions.net/finishTrip'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'offer_id': offerId,
      }),
    )
        .then((http.Response value) {
      return OfferModel.fromJson(value.body);
    });
    return futureAbstractOfferEntity;
  }
}
