import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offers_grouped_usecase.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
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

  final GetOffersGroupedUsecase _getOffersUsecase = GetOffersGroupedUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  var isSigned = false.obs;
  var isPhoneVerified = false.obs;
  var isFiltered = false.obs;
  var isDriver = false.obs;
  var onRoad = false.obs;
  var currentOfferId = ''.obs;

  Rx<Map<String, List<AbstractOfferEntity>>> mapStringListAbstractOfferEntity =
      Rx<Map<String, List<AbstractOfferEntity>>>({});
  var listAbstractRouteEntity = <AbstractRouteEntity>[].obs;
  var filteredOffers = Rx<Map<String, List<AbstractOfferEntity>>>({});
  var filteredRoutes = <AbstractRouteEntity>[].obs;

  onFilterDestain(
    String? destain,
  ) {
    if (destain != null && destain.isNotEmpty) {
      isFiltered.value = true;
      filteredOffers.value = {};
      filteredRoutes.value =
          listAbstractRouteEntity.value.where((AbstractRouteEntity route) {
        bool isMatch = route.to != null &&
            (route.to!.toLowerCase().similarityTo(destain.toLowerCase()) >=
                    0.5 ||
                route.to!.toLowerCase().contains(destain.toLowerCase()));
        if (isMatch) {
          String routeId = route.id!;
          List<AbstractOfferEntity>? routeOffers =
              mapStringListAbstractOfferEntity.value[routeId];
          if (routeOffers != null && routeOffers.isNotEmpty) {
            var newMap = filteredOffers.value;
            var newEntry = <String, List<AbstractOfferEntity>>{};
            newEntry[routeId] = routeOffers;
            newMap.addEntries(newEntry.entries);
            filteredOffers.value = newMap;
          }
        }
        return isMatch;
      }).toList();
    } else {
      isFiltered.value = false;
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
    _getOffersUsecase()?.then((Map<String, List<AbstractOfferEntity>>
        mapStringListAbstractOfferEntity) {
      this.mapStringListAbstractOfferEntity.value =
          mapStringListAbstractOfferEntity;
    });
  }

  @override
  void onReady() {
    initialize();
    super.onReady();
  }
}
