import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/get_offer_usecase.dart';
import 'package:pickpointer/packages/order_package/data/datasources/http_order_datasource.dart';
import 'package:pickpointer/packages/order_package/data/models/order_model.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/usecases/add_order_usecase.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/providers/polyline_provider.dart';
import 'package:pickpointer/src/core/util/decode_list_waypoints.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.put(PaymentController());

  final formKey = GlobalKey<FormState>();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final PolylineProvider? polylineProvider = PolylineProvider.getInstance();

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final GetOfferUsecase _getOfferUsecase = GetOfferUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  final AddOrderUsecase addOrderUsecase = AddOrderUsecase(
    abstractOrderRepository: HttpOrderDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  MapController? mapController;
  AbstractOfferEntity? abstractOfferEntity;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var offerPrice = 0.0.obs;
  var offerAvailableSeats = 0.obs;
  var seats = 0.obs;
  var offerStartLatLng = LatLng(0, 0).obs;
  var offerEndLatLng = LatLng(0, 0).obs;
  var offerWayPoints = <LatLng>[].obs;
  var userOriginLatLng = LatLng(0, 0).obs;
  var userDestinationLatLng = LatLng(0, 0).obs;
  var payMethod = 1.obs;

  var basePolylineListLatLng = <LatLng>[].obs;
  var userPolylineListLatLng = <LatLng>[].obs;

  var subtotal = 0.0.obs;
  var aditionalCost = 0.0.obs;
  var total = 0.0.obs;

  Future<bool>? calculateAditionalPrice() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      PolylineResult baseRoutePolylineResult =
          await polylineProvider!.getPolylineBetweenCoordinates(
        origin: offerStartLatLng.value,
        destination: offerEndLatLng.value,
        wayPoints: offerWayPoints.value,
      );

      List<LatLng> wayspointsWithUser = List<LatLng>.from(offerWayPoints.value);
      wayspointsWithUser.add(userOriginLatLng.value);
      wayspointsWithUser.add(userDestinationLatLng.value);
      PolylineResult userRoutePolylineResult =
          await polylineProvider!.getPolylineBetweenCoordinates(
        origin: offerStartLatLng.value,
        destination: offerEndLatLng.value,
        wayPoints: wayspointsWithUser,
      );

      int baseTravelDuration = baseRoutePolylineResult.duration.inMinutes;
      int userTravelDuration = userRoutePolylineResult.duration.inMinutes;
      if (userTravelDuration < baseTravelDuration) {
        // error user travel never can be less than base travel duration
        errorMessage.value =
            'No logramos obtener una ruta viable para los puntos que marcaste.\nRecuerda marcar un origen y destino dentro de la ruta.';
        isLoading.value = false;
        return Future.value(false);
      } else if (userTravelDuration > baseTravelDuration) {
        aditionalCost.value =
            (userTravelDuration * offerPrice.value / baseTravelDuration) -
                offerPrice.value;
      } else {
        aditionalCost.value = 0.0;
      }
      subtotal.value = offerPrice.value * seats.value;
      total.value = subtotal.value + aditionalCost.value;

      basePolylineListLatLng.value = polylineProvider!
          .convertPointToLatLng(baseRoutePolylineResult.points);
      userPolylineListLatLng.value = polylineProvider!
          .convertPointToLatLng(userRoutePolylineResult.points);

      Future.delayed(const Duration(seconds: 1), () {
        mapController?.fitBounds(
          LatLngBounds(
            offerStartLatLng.value,
            offerEndLatLng.value,
          ),
        );
      });

      isLoading.value = false;
      return Future.value(true);
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      return Future.value(false);
    }
  }

  Future<bool>? sendNotification({
    required AbstractOrderEntity abstractOrderEntity,
  }) {
    Future<bool>? futureBool = notificationProvider
        ?.sendLocalNotification(
          title: 'ORDEN CREADA CON EXITO',
          body: 'Su orden ha sido creada con exito',
        )
        .then((value) => value);
    return futureBool;
  }

  void initialize(AbstractOfferEntity abstractOfferEntity) {
    // abstractOfferEntity = Get.arguments['abstractOfferEntity'];
    abstractOfferEntity = abstractOfferEntity;
    offerPrice.value = abstractOfferEntity.price!;
    offerStartLatLng.value = LatLng(
      double.parse(abstractOfferEntity.startLat!),
      double.parse(abstractOfferEntity.startLng!),
    );
    offerEndLatLng.value = LatLng(
      double.parse(abstractOfferEntity.endLat!),
      double.parse(abstractOfferEntity.endLng!),
    );
    List<LatLng> listLatLng = [];
    String? wayPoints = abstractOfferEntity.wayPoints;
    if (wayPoints != null && wayPoints.length > 10) {
      listLatLng = decodeListWaypoints(wayPoints);
    }
    offerWayPoints.value = listLatLng;
    offerAvailableSeats.value =
        (abstractOfferEntity.maxCount! - abstractOfferEntity.count!);
  }

  @override
  void onReady() {
    String? abstractOfferEntityId;
    if (Get.arguments != null && Get.arguments['abstractOfferEntity'] != null) {
      initialize(Get.arguments['abstractOfferEntity']);
    } else if (Get.arguments != null &&
        Get.arguments['abstractOfferEntityId'] != null) {
      abstractOfferEntityId = Get.arguments['abstractOfferEntityId'];
    } else {
      abstractOfferEntityId = Get.parameters['abstractOfferEntityId'];
    }
    _getOfferUsecase
        .call(offerId: abstractOfferEntityId!)
        ?.then((AbstractOfferEntity? abstractOfferEntity) {
      initialize(abstractOfferEntity!);
    });
    super.onReady();
  }

  onSubmit({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    bool isValidForm = formKey.currentState!.validate();
    if (isValidForm && payMethod.value != 0) {
      isLoading.value = true;
      _verifySessionUsecase
          .call()
          .then((AbstractSessionEntity abstractSessionEntity) {
        // if (abstractSessionEntity.isSigned == true &&
        //     abstractSessionEntity.onRoad != true) {
        if (abstractSessionEntity.isSigned == true) {
          _getUserUsecase
              .call(userId: abstractSessionEntity.idUsers!)!
              .then((AbstractUserEntity abstractUserEntity) {
            print('abstractUserEntity');
            addOrderUsecase
                .call(
              order: OrderModel(
                id: '1',
                orderId: '123456789',
                price: offerPrice.value,
                count: seats.value,
                subtotal: subtotal.value,
                total: total.value,
                stateId:
                    '- 1', // Esperando -1, enCarretera 0 , Completado 1, Cancelado 2
                stateDescription:
                    'Esperando', // Esperando -1, enCarretera 0 , Completado 1, Cancelado 2
                userId: abstractUserEntity.id,
                userName: abstractUserEntity.name,
                userEmail: abstractUserEntity.email,
                userAvatar: abstractUserEntity.avatar,
                userPhone: abstractUserEntity.phoneNumber,
                userPickPointLat: '${userOriginLatLng.value.latitude}',
                userPickPointLng: '${userOriginLatLng.value.longitude}',
                userDropPointLat: '${userDestinationLatLng.value.latitude}',
                userDropPointLng: '${userDestinationLatLng.value.longitude}',
                userTokenMessaging: abstractSessionEntity.tokenMessaging,
                offerId: abstractOfferEntity.id,
                offerCount: abstractOfferEntity.count,
                offerMaxCount: abstractOfferEntity.maxCount,
                offerPrice: abstractOfferEntity.price,
                offerStartLat: abstractOfferEntity.startLat,
                offerStartLng: abstractOfferEntity.startLng,
                offerEndLat: abstractOfferEntity.endLat,
                offerEndLng: abstractOfferEntity.endLng,
                offerWayPoints: abstractOfferEntity.wayPoints,
                offerOrders: abstractOfferEntity.orders,
                routeId: abstractOfferEntity.routeId,
                routeTitle: abstractOfferEntity.routeTitle,
                routeDescription: abstractOfferEntity.routeDescription,
                routePrice: abstractOfferEntity.routePrice,
                routeFrom: abstractOfferEntity.routeFrom,
                routeTo: abstractOfferEntity.routeTo,
                routeStartLat: abstractOfferEntity.routeStartLat,
                routeStartLng: abstractOfferEntity.routeStartLng,
                routeEndLat: abstractOfferEntity.routeEndLat,
                routeEndLng: abstractOfferEntity.routeEndLng,
                driverId: abstractOfferEntity.userId,
                driverName: abstractOfferEntity.userName,
                driverEmail: abstractOfferEntity.userEmail,
                driverAvatar: abstractOfferEntity.userAvatar,
                driverCarPlate: abstractOfferEntity.userCarPlate,
                driverCarPhoto: abstractOfferEntity.userCarPhoto,
                driverCarModel: abstractOfferEntity.userCarModel,
                driverCarColor: abstractOfferEntity.userCarColor,
                driverPhoneNumber: abstractOfferEntity.userPhoneNumber,
                driverRank: abstractOfferEntity.userRank,
                driverTokenMessaging: abstractOfferEntity.userTokenMessaging,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              ),
            )
                .then((AbstractOrderEntity abstractOrderEntity) {
              isLoading.value = false;
              sendNotification(abstractOrderEntity: abstractOrderEntity);
              _updateSessionUsecase.call(
                abstractSessionEntity:
                    (abstractSessionEntity as SessionModel).copyWith(
                  onRoad: true,
                  currentOfferId: abstractOfferEntity.id,
                  currentOrderId: abstractOrderEntity.id,
                ),
              );
              var message =
                  'Perfecto!, compraste ${abstractOrderEntity.count} asiento(s)';
              if (abstractOrderEntity.offerCount != null &&
                  abstractOrderEntity.offerMaxCount != null &&
                  abstractOrderEntity.offerCount! + abstractOrderEntity.count! <
                      abstractOrderEntity.offerMaxCount!) {
                int pendingComplete = abstractOrderEntity.offerMaxCount! -
                    abstractOrderEntity.offerCount! -
                    abstractOrderEntity.count!;
                message +=
                    '\nEspera un poco, estamos trabajando en completar los $pendingComplete pasajero(s) restantes';
              }
              GetxSnackbarWidget(
                title: 'ORDEN CREADA!',
                subtitle: message,
                duration: const Duration(seconds: 15),
              );
              Get.offAll(
                () => OrderPage(
                  abstractOrderEntity: abstractOrderEntity,
                ),
                arguments: {
                  'abstractOrderEntity': abstractOrderEntity,
                },
              );
            }).catchError((error) {
              print('// TODO: Order is not created, not available');
              isLoading.value = false;
              print(error);
            });
          });
        } else {
          isLoading.value = false;
          print('// TODO: user is currently in road!');
        }
      });
    }
  }
}
