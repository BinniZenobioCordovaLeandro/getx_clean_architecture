import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/add_offer_usecase.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:uuid/uuid.dart';

class OfferController extends GetxController {
  static OfferController get instance => Get.put(OfferController());

  final Uuid _uuid = const Uuid();
  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  var maxCount = ''.obs;
  var price = ''.obs;

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  final AddOfferUsecase _addOfferUsecase = AddOfferUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  Future<bool>? sendNotification({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'Oferta registrada, destino "${abstractRouteEntity.to}"',
          body:
              'Ahora eres visible para los usuarios en esta ruta:\nDestino: ${abstractRouteEntity.to}\nOrigen: ${abstractRouteEntity.from}',
        )
        .then((value) => value);
    return futureBool;
  }

  void onSumbit({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    bool isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      isLoading.value = true;
      _verifySessionUsecase
          .call()
          .then((AbstractSessionEntity abstractSessionEntity) {
        if (abstractSessionEntity.isSigned!) {
          _getUserUsecase
              .call(userId: abstractSessionEntity.idUsers!)!
              .then((AbstractUserEntity abstractUserEntity) {
            if (abstractUserEntity.isDriver == '1') {
              AbstractOfferEntity abstractOfferEntity = OfferModel(
                id: _uuid.v1(),
                routeId: abstractRouteEntity.id,
                count: '0',
                maxCount: maxCount.value,
                price: price.value,
                startLat: abstractRouteEntity.startLat,
                startLng: abstractRouteEntity.startLng,
                endLat: abstractRouteEntity.endLat,
                endLng: abstractRouteEntity.endLng,
                wayPoints: '[]',
                userId: abstractSessionEntity.idUsers,
                userName: abstractUserEntity.name,
                userAvatar: abstractUserEntity.avatar,
                userCarPlate: abstractUserEntity.carPlate,
                userCarPhoto: abstractUserEntity.carPhoto,
                userCarModel: abstractUserEntity.carModel,
                userCarColor: abstractUserEntity.carColor,
                userPhoneNumber: abstractUserEntity.phoneNumber,
                userRank: abstractUserEntity.rank,
                updatedAt: '${DateTime.now().millisecondsSinceEpoch}',
                createdAt: '${DateTime.now().millisecondsSinceEpoch}',
              );
              _addOfferUsecase
                  .call(abstractOfferEntity: abstractOfferEntity)!
                  .then((AbstractOfferEntity abstractOfferEntity) {
                isLoading.value = false;
                formKey.currentState!.reset();
                sendNotification(
                  abstractRouteEntity: abstractRouteEntity,
                );
                Get.back();
              });
            }
          });
        } else {
          isLoading.value = false;
        }
      }).catchError((error) {
        isLoading.value = false;
      });
    }
  }
}
