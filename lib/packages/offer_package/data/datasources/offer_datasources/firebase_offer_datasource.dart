import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/repositories/abstract_offer_repository.dart';

class FirebaseOfferDatasource implements AbstractOfferRepository {
  FirebaseOfferDatasource();
  @override
  Future<List<AbstractOfferEntity>>? getOffers() {
    return null;
  }

  @override
  Future<List<AbstractOfferEntity>>? getOffersByRoute({
    required String routeId,
  }) {
    return Future.value(<AbstractOfferEntity>[
      const OfferModel(
        id: '1',
        routeId: '1',
        count: '3',
        maxCount: '4',
        price: '6.00',
        userId: '1',
        userName: 'John Doe',
        userAvatar: 'https://www.niemanlab.org/images/Greg-Emerson-edit-2.jpg',
        userCarPlate: 'K069-CWD',
        userCarPhoto:
            'https://www.motorshow.me/uploadImages/GalleryPics/295000/B295521-2021-Peugeot-2008-GT--5-.jpg',
        userPhoneNumber: '987654321',
        userRank: '1',
      ),
      const OfferModel(
        id: '2',
        routeId: '1',
        count: '0',
        maxCount: '4',
        price: '5.50',
        userId: '3',
        userName: 'Jose Robert',
        userAvatar:
            'https://i.pinimg.com/474x/f3/9c/0b/f39c0bc82fc9d9dea79decf69735f519.jpg',
        userCarPlate: 'ALF-326',
        userCarPhoto:
            'https://imganuncios.mitula.net/peugeot_gasolina_kamikaze_peru_peugeot_301_2016_7960126530282900928.jpg',
        userPhoneNumber: '987123456',
        userRank: '4.87',
      ),
      const OfferModel(
        id: '3',
        routeId: '1',
        count: '0',
        maxCount: '4',
        price: '5.50',
        userId: '3',
        userName: 'Jose Robert',
        userAvatar:
            'https://i.pinimg.com/474x/f3/9c/0b/f39c0bc82fc9d9dea79decf69735f519.jpg',
        userCarPlate: 'ALF-326',
        userCarPhoto:
            'https://imganuncios.mitula.net/peugeot_gasolina_kamikaze_peru_peugeot_301_2016_7960126530282900928.jpg',
        userPhoneNumber: '987123456',
        userRank: '4.87',
      ),
    ]);
  }

  @override
  Future<AbstractOfferEntity>? getOffer({
    required String id,
  }) {
    return null;
  }

  @override
  Future<AbstractOfferEntity>? setOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    return null;
  }

  @override
  Future<AbstractOfferEntity>? addOffer({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    return null;
  }
}