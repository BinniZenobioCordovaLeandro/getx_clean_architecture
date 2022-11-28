import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offers_usecase.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasources/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/get_routes_usecase.dart';

class ConsolidatePositionController extends GetxController {
  static ConsolidatePositionController get instance =>
      Get.put(ConsolidatePositionController());

  final GetRoutesUsecase _getRoutesUsecase = GetRoutesUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  final GetOffersUsecase _getOffersUsecase = GetOffersUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  var isSigned = false.obs;
  var isPhoneVerified = false.obs;
  var isDriver = false.obs;
  var onRoad = false.obs;
  var currentOfferId = ''.obs;

  var listAbstractOfferEntity = <AbstractOfferEntity>[].obs;
  var listAbstractRouteEntity = <AbstractRouteEntity>[].obs;
  var filteredOffers = <AbstractOfferEntity>[].obs;
  var filteredRoutes = <AbstractRouteEntity>[].obs;

  onFilterDestain(
    String? destain,
  ) {
    if (destain != null) {
      filteredOffers.value =
          listAbstractOfferEntity.value.where((AbstractOfferEntity offer) {
        bool isMatch = offer.routeTo != null &&
            (offer.routeTo!.toLowerCase().similarityTo(destain.toLowerCase()) >=
                    0.5 ||
                offer.routeTo!.toLowerCase().contains(destain.toLowerCase()));
        return isMatch;
      }).toList();
      filteredRoutes.value =
          listAbstractRouteEntity.value.where((AbstractRouteEntity route) {
        bool isMatch = route.to != null &&
            (route.to!.toLowerCase().similarityTo(destain.toLowerCase()) >=
                    0.5 ||
                route.to!.toLowerCase().contains(destain.toLowerCase()));
        return isMatch;
      }).toList();
    }
  }

  Future<bool> verifySession() {
    Future<bool> futureBool =
        _verifySessionUsecase.call().then((abstractSessionEntity) {
      isSigned.value = abstractSessionEntity.isSigned!;
      isPhoneVerified.value = abstractSessionEntity.isPhoneVerified ?? false;
      isDriver.value = abstractSessionEntity.isDriver ?? false;
      onRoad.value = abstractSessionEntity.onRoad ?? false;
      currentOfferId.value = abstractSessionEntity.currentOfferId ?? '';
      return isSigned.value;
    });
    return futureBool;
  }

  void initialize() {
    _getRoutesUsecase()?.then(
      (List<AbstractRouteEntity> listAbstractRouteEntity) {
        this.listAbstractRouteEntity.value = listAbstractRouteEntity;
      },
    );
    _getOffersUsecase()
        ?.then((List<AbstractOfferEntity> listAbstractOfferEntity) {
      this.listAbstractOfferEntity.value = listAbstractOfferEntity;
    });
  }

  @override
  void onReady() {
    initialize();
    super.onReady();
  }
}
