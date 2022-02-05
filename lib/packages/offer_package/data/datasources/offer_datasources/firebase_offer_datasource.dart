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
        startLat: '-12.123276353363956',
        startLng: '-76.87233782753958',
        endLat: '-12.0552257792263',
        endLng: '-76.96429734159008',
        wayPoints: '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
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
        startLat: '-12.056521974628302',
        startLng: '-76.96826304806027',
        endLat: '-12.12309955704797',
        endLng: '-76.87257722740875',
        wayPoints: '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
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
        startLat: '-12.123276353363956',
        startLng: '-76.87233782753958',
        endLat: '-12.0552257792263',
        endLng: '-76.96429734159008',
        wayPoints: '["-12.082493257253164, -76.93516669081016"]',
        userId: '3',
        userName: 'Roberto Washinton',
        userAvatar:
            'https://www.congreso.gob.pe/Docs/comisiones2018/Mujer/images/foto_tania5.png',
        userCarPlate: '5074-01',
        userCarPhoto:
            'https://www.laprensalatina.com/wp-content/uploads/2021/05/17561882w.jpg',
        userPhoneNumber: '987123456',
        userRank: '3.5',
      ),
      const OfferModel(
        id: '4',
        routeId: '1',
        count: '0',
        maxCount: '4',
        price: '5.50',
        startLat: '-12.123276353363956',
        startLng: '-76.87233782753958',
        endLat: '-12.0552257792263',
        endLng: '-76.96429734159008',
        wayPoints: '[-12.063478953141573, -76.94567353007427]',
        userId: '3',
        userName: 'Jose Roberto',
        userAvatar:
            'https://i.pinimg.com/474x/f3/9c/0b/f39c0bc82fc9d9dea79decf69735f519.jpg',
        userCarPlate: 'ALF-326',
        userCarPhoto:
            'https://imganuncios.mitula.net/peugeot_gasolina_kamikaze_peru_peugeot_301_2016_7960126530282900928.jpg',
        userPhoneNumber: '987123456',
        userRank: '4.87',
      ),
      const OfferModel(
        id: '5',
        routeId: '1',
        count: '0',
        maxCount: '4',
        price: '5.50',
        startLat: '-12.123276353363956',
        startLng: '-76.87233782753958',
        endLat: '-12.0552257792263',
        endLng: '-76.96429734159008',
        wayPoints: '[-12.079295567423781, -76.8919271250854]',
        userId: '3',
        userName: 'Roberto Washinton',
        userAvatar:
            'https://www.congreso.gob.pe/Docs/comisiones2018/Mujer/images/foto_tania5.png',
        userCarPlate: '5074-01',
        userCarPhoto:
            'https://www.laprensalatina.com/wp-content/uploads/2021/05/17561882w.jpg',
        userPhoneNumber: '987123456',
        userRank: '3.5',
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
