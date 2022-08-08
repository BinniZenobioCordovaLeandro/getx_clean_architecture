import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
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
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.put(PaymentController());

  final formKey = GlobalKey<FormState>();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final AddOrderUsecase addOrderUsecase = AddOrderUsecase(
    abstractOrderRepository: HttpOrderDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  AbstractOfferEntity? abstractOfferEntity;

  final isLoading = false.obs;
  final seats = 0.obs;
  final originLatLng = LatLng(0, 0).obs;
  final destinationLatLng = LatLng(0, 0).obs;
  final payMethod = 1.obs;

  Future<bool>? sendNotification({
    required AbstractOrderEntity abstractOrderEntity,
  }) {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'ORDEN CREADA CON EXITO',
          body: 'Su orden ha sido creada con exito',
        )
        .then((value) => value);
    return futureBool;
  }

  @override
  void onReady() {
    abstractOfferEntity = Get.arguments['abstractOfferEntity'];
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
                price: abstractOfferEntity.price,
                count: seats.value,
                total: double.parse(
                  (abstractOfferEntity.price! * seats.value).toStringAsFixed(3),
                ),
                stateId:
                    '- 1', // Esperando -1, enCarretera 0 , Completado 1, Cancelado 2
                stateDescription:
                    'Esperando', // Esperando -1, enCarretera 0 , Completado 1, Cancelado 2
                userId: abstractUserEntity.id,
                userName: abstractUserEntity.name,
                userEmail: abstractUserEntity.email,
                userAvatar: abstractUserEntity.avatar,
                userPhone: abstractUserEntity.phoneNumber,
                userPickPointLat: '${originLatLng.value.latitude}',
                userPickPointLng: '${originLatLng.value.longitude}',
                userDropPointLat: '${destinationLatLng.value.latitude}',
                userDropPointLng: '${destinationLatLng.value.longitude}',
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
